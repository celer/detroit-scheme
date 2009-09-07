; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; lib/net testing

(use net)

(define test:port 9000)

(define test:net-repl:sid #f)

(define (test:net-repl port)
  (set! test:net-repl:sid (net:repl port))
  (format #t "repl started on ~A~%" port))

(define (test:net-client port)
  (let ((io (net:client "127.0.0.1" port)))
    (net:print io "(+ 2 2)")
    (check (symbol->string (net:read io)) => "4")
    (net:close io)))

(define (test:net port)
  (test:net-repl port)
  (sleep 2)
  (test:net-client port)
  (net:server-shutdown test:net-repl:sid))

(define (test:net-ssl port)
  (net:ssl! "test/TestKeystore" "123456")
  (test:net port))

(test:net test:port) 
(test:net-ssl test:port) 
