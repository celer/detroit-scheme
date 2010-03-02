; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; Read/Eval/Print Loop

; set the global error to a nil value
(define repl:error #f) 

; print the last exception as a stack trace
(define (repl:last-error)
 (if repl:error
  (exception:print-stacktrace repl:error))
 repl:error)

; print java exceptions to repl
(define (repl:print-error e form)
 (format #t "[repl:error]:~a =>~%  ~a~%for details: (repl:last-error)~%" (cadr (string-split (exception:get-cause e) #\;)) form))

; Read Eval Print Loop
(define (repl prompt)
  (let loop ()
    (if prompt (write-string ";% ") 
      (write-string ""))
    (flush-output)
    (let ((form (read)))
      (unless (eof-object? form)
        (try-catch-finally
          (lambda () 
            (call-with-values (lambda () (eval form (current-environment)))
                              (lambda values
                                (for-each (lambda (value)
                                            (write value)
                                            (newline))
                                          values))))
          (lambda (e)
    	    ; set global error
	    (set! repl:error e)
            (repl:print-error e form))
          #f)
        (loop)))))

