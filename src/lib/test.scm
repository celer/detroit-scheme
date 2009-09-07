; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
(srfi 78)

; run a unit test 
(define-macro
  (test:unit . tests)
  (check-reset!)
  (for-each
    (lambda (test)
      (require (string->symbol (conc "test/" (symbol->string test)))))
    tests)
  (check-report))
