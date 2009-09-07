; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; testing of core library 

(define (test:core)
 (check (call-with-values (lambda () (values 1 2)) (lambda (x y) y)) => 2)
 (check (receive (a b) (values 1 2) (list a b)) => '(1 2)))

(test:core)
