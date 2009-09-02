; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; java exceptions library

; get the message as a string 
(define (exception:get-message e)
  (symbol->string
    ((method "java.lang.Exception" "getMessage") e)))

; get the cause as a list 
(define (exception:get-cause e)
  (symbol->string
    ((method "java.lang.Throwable" "toString")
     ((method "java.lang.Exception" "getCause") e))))

