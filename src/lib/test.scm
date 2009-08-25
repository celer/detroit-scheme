; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
(srfi 78)

; run a unit test 
(define (test:unit name)
  (require (string->symbol (conc "test/" (symbol->string name)))))

