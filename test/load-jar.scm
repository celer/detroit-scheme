(use 'test)

(load-jar "test/test.jar")

(define test-1 (method "test.Test" "test1"))

(define (test:load-jar)
  (check (test-1) => 1))

(test:load-jar)
(check-report)
