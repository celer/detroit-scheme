; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


; search for resource files 
(define (resource:source)
  (if (file:exist? "detroitrc")
    (load "detroitrc")
    (let ((home-resource (string-append (sys:user:home) "/.detroitrc")))
      (if (file:exist? home-resource)
	(load home-resource) #f))))

; source resource files 
(resource:source)

