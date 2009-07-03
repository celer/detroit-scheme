;; test the irc library

(use 'test)
(use 'irc)

(define test:channel "#detroit-scheme")

; XXX: obviously this is for testing
(define (poll-irc)  
  (display "poll-irc") (newline)
  (letrec ((poll (lambda ()
		   (let ((r (irc:raw:read)))
		     (unless (null? r)
		       (begin (display r) (newline) (poll)))))))
    (poll)))

; test a simple irc connection
(define (test:irc:connect)
  (irc:connect "irc.freenode.net" 6667)
  (poll-irc)
  (irc:set-user! "detroitirc" "detroit" "localhost" "localhost" "detroit")
  (poll-irc)
  (irc:join test:channel) 
  (irc:say test:channel "test")
  (display (irc:raw:read)) (newline)
  (irc:quit))

; test the irc library and produce a report
(test:irc:connect)
(check-report)
