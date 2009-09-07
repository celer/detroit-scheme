; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; print and puts
(define (puts s) (format #t "~a~%" s))
(define print puts)

; lambda alternative syntax
(define-syntax .\
  (syntax-rules ()
                ((_  (args ...) body ...)
                 (lambda (args ...)
                   body ...))))

; define short form
(define-syntax def
  (syntax-rules ()
                ((_ (proc args ...) body ...)
                 (define (proc args ...)
                   body ...))
                ((_ proc body ...)
                 (define proc body ...))))

