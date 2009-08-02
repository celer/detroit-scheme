; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(use 'irc)

; the nick of the irc bot
; XXX: this should be taken from the user list instead
(define irc:bot:nick "irc-bot")

; evaluate commands directed to the bot
(define (irc:bot:eval from command) 
  (cond ((pregexp-match "quit" command) (irc:quit "recieved quit command, shutting down..."))
        (else (irc:say from command))))

; event filter for irc:bot, parses messages directly to the bot
(define (irc:events:filter event)
  (if (pair? (pregexp-match (conc ":" irc:bot:nick ":") event))
    (irc:bot:eval 
      (list-ref (pregexp-split " " event) 2)
      (cadr (pregexp-split (conc ":" irc:bot:nick ": ") event))))
  event)

(define (irc:bot server port channel nick . password)
  (irc:connect server port)
  (set! irc:bot:nick nick)
  (irc:set-user! nick nick "localhost" "localhost" nick)
  ; XXX: test this at some point
  (if (pair? password) (irc:say "nickserv" (conc "identify " (car password))))
  (irc:join channel)
  (irc:wait))
