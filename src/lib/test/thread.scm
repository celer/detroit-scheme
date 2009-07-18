(use 'test)

(define (test:loop message)
  (display (conc "test:loop: " message)) (newline)
  (sleep 1)
  (test:loop message))

(define (test:thread)
  (let ((one (thread (lambda () (test:loop "thread one"))))
	(two (thread (lambda () (test:loop "thread two: join thread - ctrl-c me")))))
    (display "sleeping...") (newline)
    (sleep 5)
    (display "stopping...") (newline)
    (thread-stop one)
    (thread-join! two)))

(test:thread)
