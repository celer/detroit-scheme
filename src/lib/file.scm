; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


;; file utilities

; create a new file object
(define (file:new name)
  ((constructor "java.io.File" "java.lang.String") name))

; check if the path exists
(define (file:exist? path)
  ((method "java.io.File" "exists")
   (file:new path)))

