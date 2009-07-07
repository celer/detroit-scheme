; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (intersection . list) ==> list
;
; Compute the intersection of a number of sets.
;
; Arguments: a* := sets
;

(define (intersection . a*)
  (letrec
    ((intersection3 (lambda (a b r)
      (cond ((null? a)
              (reverse r))
            ((member (car a) b)
              (intersection3 (cdr a) b (cons (car a) r)))
            (else (intersection3 (cdr a) b r))))))
    (if (null? a*)
        a*
        (fold-left (lambda (a b) (intersection3 a b '()))
                   (car a*)
                   (cdr a*)))))
