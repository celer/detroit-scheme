; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (count pair) ==> integer
;
; Count the atomic members of a pair.
;
; Arguments: x - list to count
;

(define (count x)
  (cond ((null? x) 0)
        ((pair? x)
          (+ (count (car x))
             (count (cdr x))))
        (else 1)))
