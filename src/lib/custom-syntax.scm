; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; custom syntax specific to detroit-scheme

; put a string to the terminal
(define (puts ln) (format #t "~a~%" ln))
(define print puts)

; run a test
(define (test:unit name)
  (require (string->symbol (conc "test/" (symbol->string name)))))

; fuzz a type
(define (type? object)
  (cond ((symbol? object) 'symbol)
        ((pair? object) 'pair)
        ((string? object) 'string)
        ((char-array? object) 'char-array)
        ((hash-table? object) 'hash-table)
        ((exact? object) 'exact)
        ((inexact? object) 'inexact)
        ((boolean? object) 'boolean)
        ((char? object) 'char)
        ((vector? object) 'vector)
        ((procedure? object) 'procedure)
        ((input-port? object) 'input-port)
        ((output-port? object) 'output-port)
        (else #f)))
