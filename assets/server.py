import cv2
import json
from flask import Flask

global cam
cam = cv2.VideoCapture("/media/yanhung/Elements/twitter_20220619_184851.mp4")

# get image from web camera
#ret, frame = cam.read()

# convert to jpeg and save in variable
#image_bytes = cv2.imencode('.jpg', frame)[1].tobytes()
#image_bytes = str(image_bytes)[2:-2]
#image_bytes = cv2.imencode('.jpg', frame)[1]
#print(image_bytes)
#for colors in image_bytes:
#    print(colors)

app = Flask(__name__)
@app.route('/')
def index():
    global cam
    ret, frame = cam.read()
    if not ret:
        cam = cv2.VideoCapture("/media/yanhung/Elements/twitter_20220619_184851.mp4")
        ret, frame = cam.read()

    image_bytes = cv2.imencode('.jpg', frame)[1]
    return json.dumps({'bytes': image_bytes.tolist()})

app.run()
