; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(define-syntax and-let*
  (syntax-rules ()
                ((and-let* ())
                 #t)
                ((and-let* ((var exp)))
                 exp)
                ((and-let* ((exp)))
                 exp)
                ((and-let* (var))
                 var)
                ((and-let* () . body)
                 (begin . body))
                ((and-let* ((var val) more ...) . body)
                 (let ((var val))
                   (if var
                     (and-let* (more ...) . body)
                     #f)))
                ((and-let* ((exp junk . more-junk) more ...) . body)
                 (error "syntax error"
                        '(and-let* ((exp junk . more-junk) more ...) . body)))
                ((and-let* ((exp) more ...) . body)
                 (if exp
                   (and-let* (more ...) . body)
                   #f))
                ((and-let* (var more ...) . body)
                 (if var
                   (and-let* (more ...) . body)
                   #f))))
