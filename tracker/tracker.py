from ultralytics.trackers.bot_sort import BOTSORT
from ultralytics import YOLO
import numpy as np
import cv2
import yaml
from types import SimpleNamespace

class Tracker:
    def __init__(self):
        config = yaml.safe_load(open("config.yaml"))
        args = SimpleNamespace(**config)
        self.bot_sort = BOTSORT(args, frame_rate=30)
        self.frame_count = 0

    # def update(self, dets, scores, cls, img=None):
        # tracks = self.bot_sort.init_track(dets, scores, cls, img)
        # for track in tracks:
        #     track.activate(kalman_filter=self.bot_sort.kalman_filter, frame_id=self.frame_count)
        # self.bot_sort.multi_predict(tracks)
    
    def update_yolo_output(self, yolo_output):
        yolo_output = yolo_output.cpu().numpy()
        tracks = self.bot_sort.update(yolo_output.boxes)
        
                
        if len(tracks) > 0:
            yolo_output.update(tracks[:, :-1])
        
        self.frame_count += 1
        return yolo_output
    


if __name__ == '__main__':
    tracker = Tracker()
    yolo = YOLO("test/yolov8n.pt")
    video_path = "test/1572547-uhd_2560_1440_24fps.mp4"
    cap = cv2.VideoCapture(video_path)
    # Loop through the video frames
    while cap.isOpened():
        # Read a frame from the video
        success, frame = cap.read()
        
        if success:
            # resize
            frame = cv2.resize(frame, (640, 360))

            detection = yolo.predict(frame)[0]
            
            # remove all boxes except cars
            car_mask = detection.boxes.cls == 2
            detection.boxes = detection.boxes[car_mask]
            
            detection = tracker.update_yolo_output(detection)
            
            id_mask = detection.boxes.id == 1
            objective_track = detection.boxes[id_mask]
            
            if len(objective_track) == 0:
                print("Object Lost!")
                # break

            # Visualize the results on the frame
            annotated_frame = detection.plot()

            # Display the annotated frame
            cv2.imshow("YOLO Tracking", annotated_frame)

            # Break the loop if 'q' is pressed
            if cv2.waitKey(1) & 0xFF == ord("q"):
                break
        else:
            # Break the loop if the end of the video is reached
            break
