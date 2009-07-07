; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (make-partitions integer) =&gt; list
;
; Create all partitions of a positive integer.
; A (number-theoretical) partition of a positive integer N
; is a set of integers whose sum is equal to N.
;
; Arguments: n - integer to partition
;

(use 'iota)
(use 'filter)

(define (make-partitions n)
  (letrec
    ((partition
       (lambda (n)
         (cond ((zero? n) '(()))
               ((= n 1) '((1)))
               (else (apply append
                            (map (lambda (x)
                                   (map (lambda (p)
                                          (cons x p))
                                        (partition (- n x))))
                                 (iota 1 n)))))))
     (filter-descending
       (lambda (x)
         (filter (lambda (p) (or (null? p)
                                 (null? (cdr p))
                                 (apply >= p)))
                 x))))
    (reverse (filter-descending (partition n)))))
