; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; IRC Client Library 

(use 'net)

; global irc connection io
(define irc:con #f)

; format: '(nick username hostname servername realname)
(define irc:user #f)

; the last event recieved
(define irc:events:last #f)

; thread id of the event handler
(define irc:events:tid #f)

; log file
(define irc:log-file #f)

; default event filter routine
(define (irc:events:filter event) event)

; log irc events to disk
(define (irc:events:log event)
  (if irc:log-file
    (with-output-to-file
      irc:log-file
      (lambda ()
	(display event)
	(newline))
      #t))) ; XXX: this is not behaving as #f when called without optional arguments 

; handle irc events
; XXX: implement ping/pong here
(define (irc:events:handler)
  (letrec ((reader
	     (lambda ()
	       (let ((r (irc:raw:read)))
		 (unless (null? r)
		   (begin
		     (set! irc:events:last r)
		     (irc:events:log r)
		     (irc:events:filter r)
		     (reader)))))))
    (reader)))

; start up the event handler
(define (irc:events:start)
  (set! irc:events:tid
    (thread
      (lambda ()
        (irc:events:handler)))))

; make a connection to the irc server
(define (irc:connect server port . password)
  (set! irc:con (net:client server port))
  (irc:events:start)
  (unless (null? password) (irc:raw:write (conc "PASS " password)))
  irc:con)

; store user information and send it to the irc server
(define (irc:set-user! nick username hostname servername realname)
  (set! irc:user (list nick username hostname servername realname))
  (irc:raw:write (conc "NICK " nick))
  (irc:raw:write (conc "USER " username " " hostname " " servername " :" realname)))

; get the current nick
(define (irc:get-nick)
  (car irc:user))

; write a raw line to the irc server
(define (irc:raw:write line)
  (irc:events:log line)
  (net:print irc:con line))

; read a raw line from the irc server
(define (irc:raw:read)
  (net:read irc:con))

; disconnect from the server and send a quite message
(define (irc:quit message)
  (irc:raw:write (conc "QUIT :" message)))

; join a channel
(define (irc:join channel)
  (irc:raw:write (conc "JOIN " channel)))

; send a message to a recipient 
(define (irc:say recipient message)
  (irc:raw:write (conc "PRIVMSG " recipient " :" message)))

