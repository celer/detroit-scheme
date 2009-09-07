; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(define (test:with-io-strings)
  (let ((r (eval 
    (with-input-from-string 
      (with-output-to-string '(+ 2 2))) 
    (current-environment))))
	(check r => 4)))

(test:with-io-strings)
