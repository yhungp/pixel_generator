import json
from optparse import OptionParser
import cv2, time, os
import numpy as np

parser = OptionParser()
 
# add options
parser.add_option("-t", "--temp",
                  dest = "temp",
                #   help = "write report to FILE",
                  metavar = "TEMP")

parser.add_option("-n", "--base_name",
                  dest = "base_name",
                #   help = "write report to FILE",
                  metavar = "BASE_NAME")

parser.add_option("-f", "--file",
                  dest = "filename",
                #   help = "write report to FILE",
                  metavar = "FILE")

parser.add_option("-c", "--crop_start",
                  dest = "crop_start",
                #   help = "write report to FILE",
                  metavar = "CROP_START")

parser.add_option("-s", "--crop_size",
                  dest = "crop_size",
                #   help = "write report to FILE",
                  metavar = "CROP_SIZE")

parser.add_option("-r", "--resize",
                  dest = "resize",
                #   help = "write report to FILE",
                  metavar = "RESIZE")

parser.add_option("-a", "--start",
                  dest = "start",
                #   help = "write report to FILE",
                  metavar = "START")

parser.add_option("-e", "--end",
                  dest = "end",
                #   help = "write report to FILE",
                  metavar = "END")

parser.add_option("-p", "--fps",
                  dest = "fps",
                #   help = "write report to FILE",
                  metavar = "FPS")
 
(options, args) = parser.parse_args()

cam = cv2.VideoCapture(options.filename)

video_fps = cam.get(cv2.CAP_PROP_FPS)
step = int(int(options.fps) / video_fps * 1000)

base_name = options.base_name
temp_dir = options.temp

offset = str(options.crop_start).split("x")
x = int(offset[0])
y = int(offset[1])

size = str(options.crop_size).split("x")
w = int(size[0])
h = int(size[1])

resize = str(options.resize).split("x")
rw = int(resize[0])
rh = int(resize[1])

dim = (rw, rh)

images = []

for i in range(int(options.start), int(options.end), step):
    cam.set(cv2.CAP_PROP_POS_MSEC, float(i)) 
    ret, frame = cam.read()

    if not ret:
        break

    if not os.path.exists(temp_dir):
        os.mkdir(temp_dir)

    frame = frame[y:y+h, x:x+w]
    frame = cv2.resize(frame, dim, interpolation = cv2.INTER_AREA)

    # images.append([i, frame.tolist()])

    cv2.imwrite(f'{temp_dir}{base_name}{i}.png', frame)
    
    # image_bytes = cv2.imencode('.jpg', frame)[1]
    # print(json.dumps({'bytes': image_bytes.tolist()}))

# images = {
#     str(elem[0]) : elem[1] for elem in images
# }

# with open(f"{temp_dir}{base_name}.json", "w") as write_file:
#     json.dump(images, write_file, indent=4)