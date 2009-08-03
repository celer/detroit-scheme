; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


;; Read/Eval/Print Loop

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
	  (lambda (exc)
	    ((method "java.lang.Exception" "printStackTrace") exc)
	    (newline))
	  #f)
	(loop)))))

