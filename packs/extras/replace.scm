; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (replace form_1 form_2 pair) ==> pair
;
; Replace elements of a pair.
;
; Arguments: old  - element to replace
;            new  - element to insert in the place of OLD
;            form - pair in which elements will be replaced
;

(define (replace old new form)
  (cond ((equal? form old) new)
        ((pair? form)
          (cons (replace old new (car form))
                (replace old new (cdr form))))
        (else form)))
