; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (quicksort proc^2 list) ==> list
;
; Sort lists using the quicksort algorithm.
; The predicate P describes the desired order.
;
; Arguments: p - predicate
;            a - list
;

(use 'partition)

(define (quicksort p a)
  (letrec
    ((sort
       (lambda (a)
         (if (or (null? a)
                 (null? (cdr a)))
             a
             (let ((p* (partition (lambda (x) (p (car a) x))
                                  (cdr a))))
               (append (sort (cadr p*))
                       (list (car a))
                       (sort (car p*))))))))
    (sort a)))
