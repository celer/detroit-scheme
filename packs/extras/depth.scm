; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (depth list) ==> integer
;
; Compute the depth of a list.
;
; Arguments: a - list
;

(define (depth a)
  (if (pair? a)
      (+ 1 (apply max (map depth a)))
      0))
