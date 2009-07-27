; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; library for managing generating todo item lists
; description: a string describing the task
; details: a list as data describing the details of the task
; if eval-flag is set, the details are assumed to be evaluable code
(define (todo eval-flag description . details)
  (format #t "~a:~%" description)
  (if eval-flag
    (if (pair? details)
      (eval details))
    (if (pair? details) (format #t "  - ~a~%" (car details)))))

