; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; Networking API

(use 'tcp)
(use 'ssl)

(define net:print tcp:print)
(define net:read tcp:read)
(define net:read-lines tcp:read-lines)
(define net:close tcp:close)
(define net:client tcp:client)
(define net:server tcp:server)
(define net:established? tcp:established?)
(define net:server-shutdown tcp:server-shutdown)

; evaluator callback for repl 
(define (net:repl-eval io cs)
  (tcp:print 
    io
    (with-output-to-string
      (eval (with-input-from-string
              (tcp:read io))
            (current-environment))))
  (tcp:close io)
  (tcp:close-socket cs))

; interface to start tcp:repl
(define (net:repl port) (tcp:server net:repl-eval port))

; setup ssl
(define (net:ssl! ks pass)
  (ssl:set! ks pass)
  (set! tcp:client-socket ssl:client-socket)
  (set! tcp:server-socket ssl:server-socket))

