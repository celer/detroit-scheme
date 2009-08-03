; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; keystore library 

; set the ssl keystore property
(define (keystore:ks! ks)
  (java:set-property! "javax.net.ssl.keyStore" ks))

; set the ssl keystore password property
(define (keystore:ks-password! password)
  (java:set-property! "javax.net.ssl.keyStorePassword" password))

; setup an ssl keystore
(define (keystore:keystore! ks password)
  (keystore:ks! ks)
  (keystore:ks-password! password))

; set the ssl truststore property
(define (keystore:ts! ts)
  (java:set-property! "javax.net.ssl.trustStore" ts))

; set the ssl truststore password property
(define (keystore:ts-password! password)
  (java:set-property! "javax.net.ssl.trustStorePassword" password))

; setup an ssl truststore
(define (keystore:truststore! ts password)
  (keystore:ts! ts)
  (keystore:ts-password! password))

; setup ks/ts
(define (keystore:set! ksts password)
  (keystore:keystore! ksts password)
  (keystore:truststore! ksts password))

