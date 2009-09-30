; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(use url)

; http-server

; server resources
(define http:server:resources (make-hash-table))

(define (http:server:not-found)
  "<h1> 404 Not Found </h1>")

; add a resource based on CRUD operation and uri
(define (http:server:add-resource operation uri proc)
  (let ((crud-table
          (if (hash-table-exists? http:server:resources uri)
            (hash-table-ref http:server:resources uri)
            (make-hash-table))))
    (hash-table-set! crud-table operation proc)
    (hash-table-set! http:server:resources uri crud-table)))

; find a resource based on CRUD operation and uri
(define (http:server:find-resource operation uri)
  (if (hash-table-exists? http:server:resources uri)
    (let ((uri-table (hash-table-ref http:server:resources uri)))
      (if (hash-table-exists? uri-table operation)
        (hash-table-ref uri-table operation)))))

; http dispatcher 
(define (http:server:dispatcher request-method request-uri protocol request)
  (let* ((request-url (url:new (conc "http://localhost" request-uri)))
         (uri (url:get 'path request-url))
         (query (url:query:parse (url:get 'query request-url)))
         (proc (http:server:find-resource request-method uri)))
    (if (procedure? proc)
      (proc query request)
      (http:server:not-found))))

; ssl flag
(define http:server:ssl #f)

; set the keystore
(define (http:server:ssl! keystore passphrase)
  (set! http:server:ssl
    (list keystore passphrase)))

; start http server
(define (http:server:start port)
  (let* ((server
           ((method "nativehttp.NativeHttp"
                    "createServer"
                    "java.lang.String"
                    "int"
                    "boolean"
                    "detroit.Interpreter"
                    "java.lang.Object"
                    "java.lang.String"
                    "[C")
            (string->symbol "/")
            port
            (if http:server:ssl #t #f)
            (interpreter)
            http:server:dispatcher
            (if http:server:ssl (car http:server:ssl) "")
            (if http:server:ssl (cadr http:server:ssl) ""))))
    ((method "com.sun.net.httpserver.HttpServer" "start") server)
    server))

; stop http server
(define (http:server:stop server)
  ((method "com.sun.net.httpserver.HttpServer" "stop" "int") server 0)
  #t)

; get
(define-syntax get
  (syntax-rules ()
                ((_ route (args ...) body ...)
                 (http:server:add-resource 
                   "GET" route
                   (lambda (args ...)
                     body ...)))))

; post
(define-syntax post
  (syntax-rules ()
                ((_ route (args ...) body ...)
                 (http:server:add-resource 
                   "POST" route
                   (lambda (args ...)
                     body ...)))))

; put
(define-syntax put 
  (syntax-rules ()
                ((_ route (args ...) body ...)
                 (http:server:add-resource 
                   "PUT" route
                   (lambda (args ...)
                     body ...)))))

; delete
(define-syntax delete 
  (syntax-rules ()
                ((_ route (args ...) body ...)
                 (http:server:add-resource 
                   "DELETE" route
                   (lambda (args ...)
                     body ...)))))
