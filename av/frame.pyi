from fractions import Fraction
from typing import TypedDict

from av.sidedata.motionvectors import MotionVectors
from av.sidedata.detectionbboxes import DetectionBBoxes

class SideData(TypedDict, total=False):
    MOTION_VECTORS: MotionVectors
    DETECTION_BBOXES: DetectionBBoxes

class Frame:
    dts: int | None
    pts: int | None
    time: float | None
    time_base: Fraction
    is_corrupt: bool
    side_data: SideData
    opaque: object

    def make_writable(self) -> None: ...
