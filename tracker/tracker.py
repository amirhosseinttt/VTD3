from ultralytics.trackers.bot_sort import BOTSORT
import numpy as np
import yaml
from types import SimpleNamespace

class Tracker:
    def __init__(self):
        config = yaml.safe_load(open("config.yaml"))
        args = SimpleNamespace(**config)
        self.bot_sort = BOTSORT(args, frame_rate=30)
        self.frame_count = 0

    def track(self, dets, scores, cls, img=None):
        tracks = self.bot_sort.init_track(dets, scores, cls, img)
        for track in tracks:
            track.activate(kalman_filter=self.bot_sort.kalman_filter, frame_id=self.frame_count)
        self.bot_sort.multi_predict(tracks)
        
        self.frame_count += 1
        return tracks


if __name__ == '__main__':
    tracker = Tracker()
    tracker.track(np.array([[1, 1, 2, 2, 0]]), np.array([0.9]), np.array([0]))
    tracker.track(np.array([[1, 1, 2, 2, 0]]), np.array([0.9]), np.array([0]))
    
