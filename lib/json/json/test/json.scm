; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(include tooling)
(use json custom)

(define json-object (json:parse "{\"two\":[\"two\",\"two\"],\"one\":\"one\"}"))

(puts json-object)
(puts (json:to_json json-object))
(puts (json:object-ref json-object "one"))
(puts (json:object-ref json-object "two"))
(json:object-set! json-object "three" "three")
(puts (json:to_json json-object))

(puts (json:object? json-object))
(puts (json:array? (json:object-ref json-object "two")))
(json:array-set! (json:object-ref json-object "two") 0 "hello set!")
(json:array-append! (json:object-ref json-object "two") "hello append!")
(puts (json:to_json json-object))
(puts (json:object? (json:object-ref json-object "two")))
(puts (json:object-length json-object))
(puts (json:array-length (json:object-ref json-object "two")))
(puts (json:array-delete! (json:object-ref json-object "two") 2)) 
(puts (json:to_json json-object))
(puts (json:object-delete! json-object "two"))
(puts (json:to_json json-object))

