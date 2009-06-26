(use 'test)

; load the test jar file
(load-jar "test/test.jar")

(define (test:load-jar)
 (let ((test-1 (method "test.Test" "test1")))
  ; call test method on java class
  (check (test-1) => 1)
  ; load scheme code from jar file
  (load "testfun.scm")
  ; call the loaded function
  (check (testfun #t) => #t)))

(test:load-jar)

(check-report)
