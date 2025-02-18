from ultralytics.trackers.bot_sort import BOTrack
import numpy as np

class Tracker:
    def __init__(self):
        self.bot_sort = None
        self.frame_count = 0

    def track(self, detection):
        new_track = BOTrack(detection["tlwh"], detection["confidence"], detection["class"], feat=np.random.rand(128))
        if self.bot_sort is None:
            self.bot_sort = new_track
            self.bot_sort.activate(kalman_filter=self.bot_sort.shared_kalman, frame_id=self.frame_count)
            self.bot_sort.predict()
        else:
            self.bot_sort.update(new_track, frame_id=self.frame_count)
        
        self.frame_count += 1
        print(self.bot_sort.track_id)

if __name__ == '__main__':
    tracker = Tracker()
    detection = {"tlwh": np.array([0, 0, 10, 10, 0]), "confidence": 0.9, "class": 0}
    tracker.track(detection)
    
    