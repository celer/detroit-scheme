; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


;; Debugging library 

(define dbg:debug-flag #f)

(define (dbg:start) (set! dbg:debug-flag #t))
(define (dbg:stop) (set! dbg:debug-flag #f))

(define (dbg:msg message)
  (newline)
  (display (list 'debug message))
  (newline)) 

(define (dbg:debug message) 
  (if dbg:debug-flag 
    (dbg:msg message)))
