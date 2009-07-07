; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (iota integer_1 integer_2) ==> list
;
; Create ranges of integers.
;
; Arguments: l - least integer in range
;            h - greatest integer in range
;

(define (iota l h)
  (letrec
    ((j (lambda (x r)
          (if (= x l)
              (cons l r)
              (j (- x 1) (cons x r))))))
    (if (> l h)
        (wrong "iota: bad range" (list l h)))
        (j h '())))
