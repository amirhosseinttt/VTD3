from utils import load_model, plot_image
import cv2

class Detector:
    def __init__(self, model_path, threshold=0.5):
        self.model = load_model(model_path)
        self.threshold = threshold

    def detect(self, image):
        result = self.model(image)
        return result
    
    
    

if __name__ == "__main__":
    detector = Detector("models/Autonomoid/yolov8-car-front-rear-left-right-top/best.pt")
    output = detector.detect("dataset/test.jpg")[0]
    # plot yolo outpt with bbox
    for box in output.boxes:
        x1, y1, x2, y2 = box.xyxy[0]
        x1, y1, x2, y2 = int(x1), int(y1), int(x2), int(y2)
        cv2.rectangle(output.orig_img, (x1, y1), (x2, y2), (0, 255, 0), 2)
    plot_image(output.orig_img)
    