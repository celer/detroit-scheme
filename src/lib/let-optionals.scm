; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(define-syntax :optional
  (syntax-rules ()
                ((:optional x default)
                 (let ((x x))
                   (if (pair? x)
                     (if (not (null? (cdr x)))
                       (error "Too many arguments in :OPTIONAL.")
                       (car x))
                     default)))
                ((:optional x default check)
                 (let ((x x))
                   (if (pair? x)
                     (cond ((not (null? (cdr x)))
                            (error "Too many arguments in :OPTIONAL."))
                           ((not (check (car x)))
                            (error "Value in :OPTIONAL does not check out OK: " (car x)))
                           (else
                             (car x)))
                     default)))))

(define-syntax let-optionals* 
  (syntax-rules ()
                ((_ opt-ls () body ...)
                 (let () body ...))
                ((_ (expr ...) vars body ...)
                 (let ((tmp (expr ...)))
                   (let-optionals* tmp vars body ...)))
                ((_ tmp ((var default) . rest) body ...)
                 (let ((var (if (pair? tmp) (car tmp) default))
                       (tmp2 (if (pair? tmp) (cdr tmp) '())))
                   (let-optionals* tmp2 rest body ...)))
                ((_ tmp tail body ...)
                 (let ((tail tmp))
                   body ...))))

(define-syntax let-optionals 
  (syntax-rules ()
                ((_ opt-ls () body ...)
                 (let () body ...))
                ((_ (expr ...) vars body ...)
                 (let ((tmp (expr ...)))
                   (let-optionals tmp vars body ...)))
                ((_ tmp ((var default) . rest) body ...)
                 (let ((var (if (pair? tmp) (car tmp) default))
                       (tmp2 (if (pair? tmp) (cdr tmp) '())))
                   (let-optionals tmp2 rest body ...)))
                ((_ tmp tail body ...)
                 (let ((tail tmp))
                   body ...))))
