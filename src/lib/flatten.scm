; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (flatten pair) ==> list
;
; Convert tree to flat list.
;
; Arguments: tree - tree to flatten
;

(define (flatten x)
  (letrec
    ((f (lambda (x r)
          (cond ((null? x) r)
                ((pair? x)
                  (f (car x)
                     (f (cdr x) r)))
                (else (cons x r))))))
    (f x '())))
