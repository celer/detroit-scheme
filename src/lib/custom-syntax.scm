; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; custom syntax specific to detroit-scheme

; put a string to the terminal
(define (puts ln) (format #t "~a~%" ln))
(define print puts)
