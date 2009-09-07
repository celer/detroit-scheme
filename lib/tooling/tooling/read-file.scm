; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (read-file . port) ==> list of string
;
; Read a text file from an input port, return a list of lines.
;
; Arguments: port - port to read, default = current input port
;

(use read-line)

(define (read-file . port)
  (letrec
    ((collect-lines
       (lambda (ln lines)
         (cond ((eof-object? ln)
                 (reverse lines))
               (else (collect-lines (apply read-line port)
                                    (cons ln lines)))))))
    (collect-lines (apply read-line port) '())))
