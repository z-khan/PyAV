from typing import Any, Sequence, overload

import numpy as np

from .sidedata import SideData

class DetectionBBoxes(SideData, Sequence[DetectionBBox]):
    @overload
    def __getitem__(self, index: int): ...
    @overload
    def __getitem__(self, index: slice): ...
    @overload
    def __getitem__(self, index: int | slice): ...
    def __len__(self) -> int: ...
    def to_ndarray(self) -> np.ndarray[Any, Any]: ...

class DetectionBBox:
    x: int
    y: int
    width: int
    height: int
    confidence: float
    label: int
