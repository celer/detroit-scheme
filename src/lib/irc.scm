; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; IRC Client Library 

(use 'net)

; global irc connection io
(define irc:con #f)

; format: '(nick username hostname servername realname)
(define irc:user #f)

; make a connection to the irc server
(define (irc:connect server port . password)
  (set! irc:con (net:client server port))
  (unless (null? password) (net:print con (conc "PASS " password)))
  irc:con)

; store user information and send it to the irc server
(define (irc:set-user! nick username hostname servername realname)
  (set! irc:user (list nick username hostname servername realname))
  (net:print irc:con (conc "NICK " nick))
  (net:print irc:con (conc "USER " username " " hostname " " servername " :" realname)))

; get the current nick
(define (irc:get-nick)
  (car irc:user))

; write a raw line to the irc server
(define (irc:raw:write line)
  (net:print irc:con line))

; read a raw line from the irc server
(define (irc:raw:read)
  (net:read irc:con))

; disconnect from the server and send a quite message
(define (irc:quit message)
  (net:print irc:con (conc "QUIT :" message))
  (net:close irc:con))

; join a channel
(define (irc:join channel)
  (irc:raw:write (conc "JOIN " channel)))

; send a message to a recipient 
(define (irc:say recipient message)
  (irc:raw:write (conc "PRIVMSG " recipient " :" message)))

; handle irc event messages
;(define (irc:events handler)
;	; we loop here
;	; each line is passed to handler
;) 
;
;; default event handler
;(define (irc:handle-events line)
;	; this will be a simple evaluator for handling standard IRC messages
;)

