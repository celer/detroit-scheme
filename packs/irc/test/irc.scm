;; test the irc library

(use 'test)
(use 'irc)

(define test:channel "#detroit-scheme")

(define (irc:events:filter event)
  (display "XXX: replace this with a check of some kind for the report") (newline)
  event)

; test a simple irc connection
(define (test:irc:connect)
  (set! irc:log-file "irc.log")
  (irc:connect "irc.freenode.net" 6667)
  (irc:set-user! "detroitirc" "detroit" "localhost" "localhost" "detroit")
  (irc:join test:channel) 
  (irc:say test:channel "test")
  (sleep 5)
  (irc:quit "bye"))

; test the irc library and produce a report
(test:irc:connect)
(check-report)
