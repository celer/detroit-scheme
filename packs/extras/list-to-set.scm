; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (list->set list) ==> list
;
; Convert list to set.
; A set is a list containing only unique members.
;
; Arguments: a - list
;

(define (list->set a)
  (letrec
    ((l->s
       (lambda (a r)
         (cond ((null? a)
                 (reverse r))
               ((member (car a) r)
                 (l->s (cdr a) r))
               (else (l->s (cdr a)
                           (cons (car a) r)))))))
    (l->s a '())))
