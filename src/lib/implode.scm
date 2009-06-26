; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (implode list) ==> symbol
;
; Implode a list of single-character symbols into a symbol.
;
; Arguments: list - list to implode
;

(define (implode x)
  (letrec
    ((sym->char
       (lambda (x)
         (let ((str (symbol->string x)))
           (if (= (string-length str) 1)
               (string-ref str 0)
               (wrong "bad symbol in implode" x))))))
    (string->symbol
      (list->string (map sym->char x)))))
