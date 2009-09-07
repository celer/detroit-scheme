; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(include tooling) 
(use read-file)

(define test:output-file "/tmp/test.log")

(define (test:with-output-to-file line)
  (with-output-to-file
    test:output-file
    (lambda () (display line) (newline))))

(define (test:with-output-to-file-append line)
  (with-output-to-file
    test:output-file
    (lambda () (display line) (newline)) #t))
	
(test:with-output-to-file "first line")	
(test:with-output-to-file "second line")	
(test:with-output-to-file-append "first line")	
(test:with-output-to-file-append  "second line")

(define (test:output-file-contents)
  (check (read-file (open-input-file test:output-file)) => '("second line" "first line" "second line")))

(test:output-file-contents)

(check-report)
