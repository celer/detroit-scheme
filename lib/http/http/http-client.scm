; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; http-server

; request 
(define http:client:request
  (method "nativehttp.NativeHttpConnection" "request" "java.lang.String" "java.lang.String" "java.lang.String" "java.lang.String"))

; get request
(define (http:get url) (http:client:request "GET" url "" "")) 

; delete request
(define (http:delete url) (http:client:request "DELETE" url "" ""))

; post request
(define (http:post url data content-type) (http:client:request "POST" url data content-type))

; put request
(define (http:put url data content-type) (http:client:request "PUT" url data content-type))
