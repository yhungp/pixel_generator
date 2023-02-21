import threading
import cv2
import json
from flask import Flask, request, jsonify
from time import sleep

global video
global cam
global reset
global play_pause
global frame_counter
global video_frame_counter
global fps

video = ""

cam = cv2.VideoCapture(video)

reset = False
play_pause = False

frame_counter = 0
video_frame_counter = 0

fps = 0.0

app = Flask(__name__)

def thread_function():
    global reset
    global play_pause
    global frame_counter
    
    while True:
        if reset:
            frame_counter = 0

        if not play_pause or fps == 0:
            sleep(0.1)
            continue

        sleep(1 / fps)
        
        frame_counter += 1

        if frame_counter >= video_frame_counter:
            frame_counter = 0
        

x = threading.Thread(target=thread_function,)
x.start()

@app.route('/')
def index():
    global cam
    ret, frame = cam.read()

    if not ret:
        cam = cv2.VideoCapture(video)
        ret, frame = cam.read()

    image_bytes = cv2.imencode('.jpg', frame)[1]
    return json.dumps({'bytes': image_bytes.tolist()})

@app.route('/get_video')
def get_video():
    return json.dumps({'video': video})

@app.route('/set_video',methods = ['POST'])
def postVideo():
    global video
    global cam
    global video_frame_counter
    global fps

    if request.method == 'POST':
        video = request.json['video']

        cam = cv2.VideoCapture(video)
        video_frame_counter = int(cam.get(cv2.CAP_PROP_FRAME_COUNT))
        fps = cam.get(cv2.CAP_PROP_FPS)

        resp = jsonify(success=True)
        return resp

@app.route('/set_current_frame', methods = ['POST', 'GET'])
def set_current_frame():
    global video
    global cam
    global frame_counter

    if request.method == 'POST':
        frame = request.json['frame']
        cam.set(cv2.CAP_PROP_POS_FRAMES, frame) 
        frame_counter = frame
        resp = jsonify(success=True)
        return resp

@app.route('/get_current_frame')
def get_current_frame():
    global video
    global cam
    global frame_counter

    cam.set(cv2.CAP_PROP_POS_FRAMES, frame_counter) 
    ret, frame = cam.read()

    if not ret:
        cam = cv2.VideoCapture(video)
        ret, frame = cam.read()

    image_bytes = cv2.imencode('.jpg', frame)[1]
    return json.dumps(
        {
            'bytes': image_bytes.tolist(),
            'frame_counter': frame_counter,
        }
    )

@app.route('/get_current_frame_index')
def get_current_frame_index():
    global frame_counter

    return json.dumps({'frame_counter': frame_counter})

@app.route('/play_pause')
def play_pause_call():
    global play_pause
    global reset

    reset = False
    play_pause = not play_pause
    
    resp = jsonify(success=True)
    return resp
    

@app.route('/stop_video')
def stop_video():
    global reset
    global play_pause

    reset = True
    play_pause = False
    
    resp = jsonify(success=True)
    return resp

app.run()
