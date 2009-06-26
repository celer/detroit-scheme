; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


;; SSL library 

(use 'keystore)

; setup a keystore and a truststore to use the same keystore file
(define (ssl:set! ksts password)
  (keystore:set! ksts password)
  #t)

; create an ssl server socket factory
(define (ssl:server-socket-factory)
  ((method "javax.net.ssl.SSLServerSocketFactory" "getDefault")))

; create an ssl server socket
(define (ssl:server-socket-create sf port)
  ((method 
     "javax.net.ssl.SSLServerSocketFactory" "createServerSocket" "int")
   sf port))

; create a server socket using ssl
(define (ssl:server-socket port)
  (ssl:server-socket-create
    (ssl:server-socket-factory)
    port))

; create an ssl client socket factory
(define (ssl:client-socket-factory)
  ((method "javax.net.ssl.SSLSocketFactory" "getDefault")))

; create an ssl client socket
(define (ssl:client-socket-create sf ip port)
  ((method 
     "javax.net.ssl.SSLSocketFactory" "createSocket" "java.lang.String" "int")
   sf ip port))

; create a client socket using ssl
(define (ssl:client-socket ip port)
  (ssl:client-socket-create
    (ssl:client-socket-factory)
    ip port))

