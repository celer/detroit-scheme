(define test:tid:one #f)
(define test:tid:two #f)

(define (test:infinite message)
  (display (conc "test:infinite: " message)) (newline)
  (sleep 1)
  (test:infinite message))

(define (test:thread)
  (set! test:tid:one (thread (lambda () (test:infinite "thread one"))))
  (set! test:tid:two (thread (lambda () (test:infinite "thread two"))))
  (display "sleeping...") (newline)
  (sleep 5)
  (display test:tid) (newline)
  (display "stopping...") (newline)
  (thread-stop test:tid:one)
  (thread-stop test:tid:two))

(test:thread)
