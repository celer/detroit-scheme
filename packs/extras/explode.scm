; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (explode symbol) ==> list
;
; Explode a symbol into a list of single-character symbols.
;
; Arguments: x - symbol to explode
;

(define (explode x)
  (map (lambda (x)
         (string->symbol (string x)))
       (string->list (symbol->string x))))
