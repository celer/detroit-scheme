; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(use http-server)

; handler for http server test
(define (test:http:server query request) 
  (format 
    #f "<h1> ~a ~a ~a </h1>~%"
    (url:query:key query "search") 
    (url:query:key query "lang") 
    (if (equal? "" request)
      "no data" 
      request)))

; test http crud operations 
(get "/index.html" (query request) (test:http:server query request))
(post "/index.html" (query request) (test:http:server query request))
(put "/index.html" (query request) (test:http:server query request)) 
(delete "/index.html" (query request) (test:http:server query request)) 

(http:server:ssl! "test/http.keystore" "changeit")
(http:server:start 9000)
