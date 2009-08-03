; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(define-syntax receive
  (syntax-rules ()
                ((receive formals expression body ...)
                 (call-with-values (lambda () expression)
                                   (lambda formals body ...)))))

