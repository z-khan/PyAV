cimport libav as lib

from av.frame cimport Frame
from av.sidedata.sidedata cimport SideData


cdef class _DetectionBBoxes(SideData):

    cdef dict _bboxes
    cdef int _len


cdef class DetectionBBox:

    cdef _DetectionBBoxes parent
    cdef lib.AVDetectionBBox *ptr
