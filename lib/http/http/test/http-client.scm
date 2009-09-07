; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(use http-client)

; test http client 
(define (test:http:client type)
  (check (http:post (conc type "://localhost:9000/index.html?search=term&lang=en") "some data" "text/text") =>
         "<h1> term en some data </h1>")
  (check (http:get (conc type "://localhost:9000/index.html?search=term&lang=en")) => 
         "<h1> term en no data </h1>")
  (check (http:put (conc type "://localhost:9000/index.html?search=term&lang=en") "some data" "text/text") =>
         "<h1> term en some data </h1>")
  (check (http:delete (conc type "://localhost:9000/index.html?search=term&lang=en")) =>
         "<h1> term en no data </h1>"))

; run http client test
;(test:http:client "http")
(test:http:client "https")
