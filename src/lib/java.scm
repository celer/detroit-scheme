; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


;; java system support

; set a system property
(define (java:set-property! k v)
  ((method "java.lang.System" "setProperty" "java.lang.String" "java.lang.String") k v))

; get a system property
(define (java:get-property k)
  ((method "java.lang.System" "getProperty" "java.lang.String") k))

; get system property as a string
(define (java:get-property-string k)
  (symbol->string (java:get-property k)))

; get all java system properties
(define (java:get-properties)
  ((method "java.lang.System" "getProperties")))

; java spec version
(define (java:specification-version)
  (java:get-property-string "java.specification.version"))

; java version
(define (java:version)
  (java:get-property-string "java.version"))

