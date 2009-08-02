; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.


;; TCP library 

;; server

; create a server socket
(define (tcp:server-socket port)
  ((constructor "java.net.ServerSocket" "int") port))

; accept a connnection on a server socket
(define (tcp:server-accept s)
  ((method "java.net.ServerSocket" "accept") s))

; close a server socket
(define (tcp:server-close s)
  ((method "java.net.ServerSocket" "close") s))

; set the reuse flag on a socket
(define (tcp:server-reuse s b)
  ((method "java.net.ServerSocket" "setReuseAddress" "boolean") s b))

; get a socket input stream
(define (tcp:socket-get-input-stream s)
  ((method "java.net.Socket" "getInputStream") s))

; get a socket output stream
(define (tcp:socket-get-output-stream s)
  ((method "java.net.Socket" "getOutputStream") s))

; close a client socket
(define (tcp:socket-close s)
  ((method "java.net.Socket" "close") s))

; connection predicate
(define (tcp:connected? s)
  ((method "java.net.Socket" "isConnected") s))

; socket state
(define (tcp:closed? s)
  ((method "java.net.Socket" "isClosed") s))

; read-half 
(define (tcp:input-available? s)
  (not ((method "java.net.Socket" "isInputShutdown") s)))

; write-half
(define (tcp:output-available? s)
  (not ((method "java.net.Socket" "isOutputShutdown") s)))

; check that a connection is still valid
(define (tcp:established? io)
  (let ((s (tcp:io-get-socket io)))
    (and 
      (tcp:connected? s)
      (not (tcp:closed? s))
      (tcp:input-available? s)
      (tcp:output-available? s))))

; print to a server writer
(define (tcp:server-print io m)
  (print-stream-println (tcp:io-get-output io) m))

; open io for server
(define (tcp:server-open-io s)
  (list
    'server
    (new-buffered-reader (new-input-stream-reader (tcp:socket-get-input-stream s)))
    (new-io-print-stream (tcp:socket-get-output-stream s))
    s))

; close server io
(define (tcp:close-server io)
  (print-stream-flush (tcp:io-get-output io)) 
  (print-stream-close (tcp:io-get-output io)) 
  (buffered-reader-close (tcp:io-get-input io))
  (tcp:socket-close (tcp:io-get-socket io)))

; server accept handler
(define (tcp:accept-handler proc cs)
  (let ((io (tcp:server-open-io cs)))
    (proc io cs)))

; inner accept loop
(define (tcp:server-accept-loop proc srv)
  (letrec ((accept-loop
	     (lambda ()
	       (try-catch-finally
		 (lambda ()
		   (let ((cs (tcp:server-accept srv)))
		     (thread-start! 
		       (make-thread
			 (lambda ()
			   (tcp:accept-handler proc cs)))))
		   (accept-loop))
		 #f
		 #f))))
    (accept-loop)))

; start a simple tcp server on a port send requests to procedure
(define (tcp:server proc port)
  (let ((srv (tcp:server-socket port)))
    (tcp:server-reuse srv #t)
    (let ((tid
	    (thread-start! 
	      (make-thread
		(lambda ()
		  (tcp:server-accept-loop proc srv))))))
      (list srv tid))))

; shutdown a running server
(define (tcp:server-shutdown sid)
  (tcp:server-close (car sid))
  (thread-terminate! (cadr sid)))

;; client

; create a client socket
(define (tcp:client-socket ip port)
  ((constructor "java.net.Socket" "java.lang.String" "int") ip port))

; open io for client
(define (tcp:client-open-io s)
  (list
    'client
    (new-buffered-reader (new-input-stream-reader (tcp:socket-get-input-stream s)))
    (new-java-io-printwriter (tcp:socket-get-output-stream s))
    s))

; close client io
(define (tcp:close-client io)
  (print-writer-flush (tcp:io-get-output io))
  (print-writer-close (tcp:io-get-output io)) 
  (buffered-reader-close (tcp:io-get-input io))
  (tcp:socket-close (tcp:io-get-socket io)))

; print to client io 
(define (tcp:client-print io m)
  (print-writer-print (tcp:io-get-output io) m)
  (print-writer-flush (tcp:io-get-output io)))

; create a client socket
(define (tcp:client ip port) 
  (tcp:client-open-io 
    (tcp:client-socket ip port)))

;; common 

; close a socket 
(define (tcp:close-socket s)
  ((method "java.net.Socket" "close") s))

; accessors
(define (tcp:io-get-type io) (car io))
(define (tcp:io-get-input io) (cadr io))
(define (tcp:io-get-output io) (caddr io))
(define (tcp:io-get-socket io) (cadddr io))

; io predicates
(define (tcp:client-io? io) (if (equal? (tcp:io-get-type io) 'client) #t #f))
(define (tcp:server-io? io) (if (equal? (tcp:io-get-type io) 'server) #t #f))

; close io
(define (tcp:close io)
  (if (tcp:client-io? io)
    (tcp:close-client io)
    (tcp:close-server io)))

; print to io 
(define (tcp:print io m)
  (if (tcp:client-io? io)
    (tcp:client-print io m)
    (tcp:server-print io m)))

; read input from io
(define (tcp:read io) 
  (buffered-reader-readline (tcp:io-get-input io)))

; read-lines from io
(define (tcp:read-lines io)
  (letrec
    ((collect-lines
       (lambda (ln lines)
         (cond ((or (eof-object? ln) (null? ln))
                (reverse lines))
               (else (collect-lines (net:read io) 
                                    (cons ln lines)))))))
    (collect-lines (net:read io) '())))

