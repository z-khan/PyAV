from collections.abc import Sequence

cdef object _cinit_bypass_sentinel = object()

cdef class _DetectionBBoxes(SideData):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._bboxes = {}
        self._len = self.ptr.size // sizeof(lib.AVDetectionBBox)

    def __repr__(self):
        return f"<av.sidedata.DetectionBBoxes {self.ptr.size} bytes of {len(self)} bounding boxes at 0x{<unsigned int>self.ptr.data:0x}>"

    def __getitem__(self, int index):
        try:
            return self._bboxes[index]
        except KeyError:
            pass

        if index >= self._len:
            raise IndexError(index)

        bbox = self._bboxes[index] = DetectionBBox(_cinit_bypass_sentinel, self, index)
        return bbox

    def __len__(self):
        return self._len

    def to_ndarray(self):
        import numpy as np
        return np.frombuffer(self, dtype=np.dtype([
            ("x", "int32"),
            ("y", "int32"),
            ("width", "int32"),
            ("height", "int32"),
            ("confidence", "float32"),
            ("label", "uint32"),
        ], align=True))

class DetectionBBoxes(_DetectionBBoxes, Sequence):
    pass


cdef class DetectionBBox:
    def __init__(self, sentinel, _DetectionBBoxes parent, int index):
        if sentinel is not _cinit_bypass_sentinel:
            raise RuntimeError("Cannot manually instantiate DetectionBBox")

        self.parent = parent
        cdef lib.AVDetectionBBox *base = <lib.AVDetectionBBox*>parent.ptr.data
        self.ptr = base + index

    def __repr__(self):
        return f"<av.sidedata.DetectionBBox {self.width}x{self.height} at ({self.x},{self.y}), confidence={self.confidence}, label={self.label}>"

    @property
    def x(self):
        return self.ptr.x

    @property
    def y(self):
        return self.ptr.y

    @property
    def width(self):
        return self.ptr.w

    @property
    def height(self):
        return self.ptr.h

    @property
    def confidence(self):        
        return self.ptr.detect_confidence.num / self.ptr.detect_confidence.den

    @property
    def label(self):
        return self.ptr.detect_label.decode('utf-8')
