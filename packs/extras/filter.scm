; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (filter proc^1 list) ==> list
;
; Extract elements from a list.
; The predicate P describes the property
; of the elements to be extracted.
;
; Arguments: p - predicate
;            a - source list
;

(define (filter p a)
  (letrec
    ((filter2
       (lambda (a r)
         (cond ((null? a) r)
               ((p (car a))
                 (filter2 (cdr a) (cons (car a) r)))
               (else (filter2 (cdr a) r))))))
    (filter2 (reverse a) '())))
