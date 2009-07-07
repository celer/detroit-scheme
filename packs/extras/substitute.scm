; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (substitute pair alist) ==> pair
;
; Substitute subforms of a given form.
; The association list ALIST contains the
; forms to be substituted as keys and the
; substitutes as values.
;
; arguments: form  - source form
;            alist - substitutions
;

(define (substitute x a)
  (cond ((assoc x a) => cdr)
        ((pair? x)
          (cons (substitute (car x) a)
                (substitute (cdr x) a)))
        (else x)))
