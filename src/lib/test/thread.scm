; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(define (test:loop message)
  (display (conc "test:loop: " message)) (newline)
  (sleep 1)
  (test:loop message))

(define (test:thread)
  (let ((one (thread-start! (make-thread (lambda () (test:loop "thread one")))))
	(two (thread-start! (make-thread (lambda () (test:loop "thread two: join thread - ctrl-c me"))))))
    (display "sleeping...") (newline)
    (sleep 5)
    (display "stopping...") (newline)
    (thread-terminate! one)
    (thread-join! two)))

(test:thread)
