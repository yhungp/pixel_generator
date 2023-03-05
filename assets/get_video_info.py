from optparse import OptionParser
import cv2, datetime

parser = OptionParser()

def get_propperty(property, camera):
    if property == "fps":
        return camera.get(cv2.CAP_PROP_FPS)
    
    if property == "size":
        width  = int(camera.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(camera.get(cv2.CAP_PROP_FRAME_HEIGHT))
        
        return f"{width}x{height}"
    
    if property == "duration":
        frames = camera.get(cv2.CAP_PROP_FRAME_COUNT)
        fps = camera.get(cv2.CAP_PROP_FPS)

        seconds = round(frames / fps)
        video_time = datetime.timedelta(seconds=seconds)
        
        return video_time

parser.add_option("-f", "--file",
                  dest = "filename",
                #   help = "write report to FILE",
                  metavar = "FILE")

parser.add_option("-p", "--property",
                  dest = "property",
                #   help = "write report to FILE",
                  metavar = "PROPERTY")
 
(options, args) = parser.parse_args()

cam = cv2.VideoCapture(options.filename)

print(get_propperty(options.property, cam))