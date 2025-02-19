import torch
from ultralytics import YOLO
import cv2

def load_model(model_path):
    # define yolov8n
    model = YOLO(model_path)
    model.eval()
    return model

def plot_image(img):
    cv2.imshow("image", img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()