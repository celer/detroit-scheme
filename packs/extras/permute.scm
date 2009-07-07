; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (permute integer list) ==> list
; (permute* integer list) ==> list
;
; Create permutations of sets.
; PERMUTE creates permutations without repetition,
; and PERMUTE* creates permutations with repetition.
; The result is a list of sets (lists).
;
; Arguments: n   - size of sets to create
;            set - source set
;

(use 'combine)

(define (permute n set)
  (letrec
    ((rotate
       (lambda (x)
         (append (cdr x) (list (car x)))))
     (rotations
       (lambda (x)
         (letrec
           ((rot (lambda (x n)
                   (if (null? n)
                       '()
                       (cons x (rot (rotate x)
                                    (cdr n)))))))
           (rot x x))))
     (permutations
       (lambda (set)
         (cond ((null? set) '())
               ((null? (cdr set)) (list set))
               ((null? (cddr set)) (rotations set))
               (else (apply append
                            (map (lambda (rotn)
                                   (map (lambda (x)
                                          (cons (car rotn) x))
                                        (permutations (cdr rotn))))
                                 (rotations set))))))))
    (apply append (map permutations (combine n set)))))

(define (permute* n set)
  (cond ((zero? n) '())
        ((= n 1) (map list set))
        (else (apply append
                     (map (lambda (x)
                            (map (lambda (sub)
                                   (cons x sub))
                                 (permute* (- n 1) set)))
                          set)))))
