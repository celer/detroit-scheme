; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (read-line . port) ==> string
;
; Read a line from an input port.
;
; Arguments: port - port to read, default = current input port
;

(define (read-line . port)
  (letrec
    ((collect-chars
       (lambda (c s)
         (cond ((eof-object? c)
                 (if (null? s)
                     c
                     (list->string (reverse s))))
               ((char=? c #\newline)
                 (list->string (reverse s)))
               (else (collect-chars (apply read-char port)
                                    (cons c s)))))))
    (collect-chars (apply read-char port) '())))
