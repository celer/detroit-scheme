; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (mergesort proc^2 list) ==> list
;
; Sort lists using the mergesort algorithm.
; The predicate P describes the desired order.
;
; Arguments: p - predicate
;            a - list
;

(define (mergesort p a)
  (letrec
    ((split
       (lambda (a r1 r2)
         (cond ((or (null? a)
                    (null? (cdr a)))
                 (list (reverse r2) r1))
               (else (split (cddr a)
                            (cdr r1)
                            (cons (car r1) r2))))))
     (merge
       (lambda (a b r)
         (cond
           ((null? a)
             (if (null? b)
                 r
                 (merge a (cdr b) (cons (car b) r))))
           ((null? b)
             (merge (cdr a) b (cons (car a) r)))
           ((p (car a) (car b))
             (merge a (cdr b) (cons (car b) r)))
           (else (merge (cdr a) b (cons (car a) r))))))
     (sort
       (lambda (a)
         (cond
           ((or (null? a)
                (null? (cdr a)))
             a)
           (else (let ((p* (split a a '())))
                   (merge (reverse (sort (car p*)))
                          (reverse (sort (cadr p*)))
                          '())))))))
    (sort a)))
