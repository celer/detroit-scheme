; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; digest testing 

(use 'test)
(use 'digest)

; the digest test message
(define test:digest:test-message "digest test message")

; test md5 hash
(define (test:digest:md5)
  (check (digest:md5 test:digest:test-message) => "27b1a4a2872a5afc8ad26b9a8850b62d"))

; test sha-1 hash
(define (test:digest:sha-1)
  (check (digest:sha-1 test:digest:test-message) => "5e38fc7a9d4ddc8d0dbbbee4da032ce833c56d88"))

(test:digest:md5)
(test:digest:sha-1)
(check-report)

