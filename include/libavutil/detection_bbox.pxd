from libc.stdint cimport int32_t, uint32_t, int, uint8_t

cdef extern from "libavutil/detection_bbox.h" nogil:

    # Define the constants
    int AV_DETECTION_BBOX_LABEL_NAME_MAX_SIZE = 64
    int AV_NUM_DETECTION_BBOX_CLASSIFY = 4

    # Struct definitions
    cdef struct AVDetectionBBox:
        int x
        int y
        int w
        int h
        char detect_label[64]  # Use the constant value directly here
        AVRational detect_confidence
        uint32_t classify_count
        char classify_labels[4][64]  # Use the constant values directly
        AVRational classify_confidences[4]  # Use the constant value directly

    cdef struct AVDetectionBBoxHeader:
        char source[256]
        uint32_t nb_bboxes
        size_t bboxes_offset
        size_t bbox_size

    # Function definitions
    cdef AVDetectionBBox *av_get_detection_bbox(const AVDetectionBBoxHeader *header, unsigned int idx)

    cdef AVDetectionBBoxHeader *av_detection_bbox_alloc(uint32_t nb_bboxes, size_t *out_size)

    cdef AVDetectionBBoxHeader *av_detection_bbox_create_side_data(AVFrame *frame, uint32_t nb_bboxes)
