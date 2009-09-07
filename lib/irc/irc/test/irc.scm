; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; test the irc library

(use irc)

; default testing channel
(define test:channel "#detroit-scheme-test")

; number of events captured successfully
(define test:results 0)

; count the number of notices and mode changes, should be equal to 6
(define (irc:events:filter event)
  (if (pair? (pregexp-match "NOTICE AUTH :" event))
    (set! test:results (+ test:results 1)))
  event)

; test a simple irc connection
(define (test:irc:connect)
  (set! irc:log-file "irc.log")
  (irc:connect "irc.freenode.net" 6667)
  (irc:set-user! "detroitirc" "detroit" "localhost" "localhost" "detroit")
  (irc:join test:channel) 
  (irc:say test:channel "test")
  (sleep 5)
  (check test:results => 4)
  (irc:quit "bye"))

; test the irc library and produce a report
(test:irc:connect)
