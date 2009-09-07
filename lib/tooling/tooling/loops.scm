; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; while loop
(define-syntax while
  (syntax-rules ()
                ((while condition body ...)
                 (let loop ()
                   (if condition
                     (begin
                       body ...
                       (loop))
                     #f)))))

; for loop
(define-syntax for
  (syntax-rules (in as)
                ((for element in list body ...)
                 (for-each (lambda (element)
                        body ...)
                      list))
                ((for list as element body ...)
                 (for element in list body ...))))

; repeat until
(define-syntax repeat
  (syntax-rules ()
                ((repeat until test body ...)
                 (let loop ()
                   (begin
                     body ...
                     (unless test (loop)))))))

