; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; IRC Bot Library

(use 'irc)

; evaluate commands directed to the bot
(define (irc:bot:eval from command) 
  (cond ((pregexp-match "quit" command) (irc:quit "recieved quit command, shutting down..."))
        (else (irc:say from command))))

; event filter for irc:bot, parses messages directly to the bot
(define (irc:events:filter event)
  (if (pair? (pregexp-match (conc ":" (irc:nick) ":") event))
    (irc:bot:eval 
      (list-ref (pregexp-split " " event) 2)
      (cadr (pregexp-split (conc ":" (irc:nick) ": ") event))))
  event)

; create a bot
(define (irc:bot server port channel nick . password)
  (irc:connect server port)
  (irc:set-user! nick nick "localhost" "localhost" nick)
  ; XXX: test this at some point
  (if (pair? password) (irc:say "nickserv" (conc "identify " (car password))))
  (irc:join channel)
  (irc:wait))
