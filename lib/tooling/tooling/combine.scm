; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (combine integer list) ==> list
; (combine* integer list) ==> list
;
; Create combinations of sets.
; COMBINE creates combinations without repetition,
; and COMBINE* creates combinations with repetition.
; The result is a list of sets (lists).
;
; Arguments: n   - size of sets to create
;            set - source set
;

(define (combine3 n set rest)
  (letrec
    ((tails-of
       (lambda (set)
         (cond ((null? set) '())
               (else (cons set (tails-of (cdr set)))))))
     (combinations
       (lambda (n set)
         (cond
           ((zero? n) '())
           ((= 1 n) (map list set))
           (else (apply
                   append
                   (map (lambda (tail)
                          (map (lambda (sub)
                                 (cons (car tail) sub))
                               (combinations (- n 1) (rest tail))))
                        (tails-of set))))))))
    (combinations n set)))

(define (combine n set)
  (combine3 n set cdr))

(define (combine* n set)
  (combine3 n set (lambda (x) x)))
