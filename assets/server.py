import cv2
import json
from flask import Flask, request, jsonify

global video
global cam

video = ""
cam = cv2.VideoCapture(video)

app = Flask(__name__)

@app.route('/')
def index():
    global cam
    ret, frame = cam.read()

    if not ret:
        cam = cv2.VideoCapture(video)
        ret, frame = cam.read()

    image_bytes = cv2.imencode('.jpg', frame)[1]
    return json.dumps({'bytes': image_bytes.tolist()})

@app.route('/video',methods = ['POST', 'GET'])
def postVideo():
    global video
    global cam

    if request.method == 'POST':
        v = request.form['video']
        video = v
        cam = cv2.VideoCapture(video)
        resp = jsonify(success=True)
        return resp


app.run()
