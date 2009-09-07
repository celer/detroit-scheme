; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; create a jdbc object
(define (jdbc:make-jdbc url driver)
  ((constructor
     "nativejdbc.NativeJDBC"
     "java.lang.String"
     "java.lang.String")
   url driver))

; execute a query on the object
(define (jdbc:execute handle query)
  ((method
    "nativejdbc.NativeJDBC"
    "execute"
    "java.lang.String")
   handle query))
