        .386p
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) masking values for
; functions that need them.
;
; (ykumanan)
;
        @dseg

        public  LeftClipPlaneMask
        public  RightClipPlaneMask

; Plane masks for clipping left and right edges of rectangle.
LeftClipPlaneMask       db      00fh,00eh,00ch,008h
RightClipPlaneMask      db      00fh,001h,003h,007h

        ends

        end

