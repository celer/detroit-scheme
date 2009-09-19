; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(include tooling)
(use json custom)

(define (test:json)
  (let ((json-object (json:parse "{\"two\":[\"two\",\"two\"],\"one\":\"one\"}")))
    (check (json:to_json json-object) => "{\"two\":[\"two\",\"two\"],\"one\":\"one\"}")
    (check (json:object? json-object) => #t) 
    (check (json:object-ref json-object "one") => "one")
    (check (json:array? (json:object-ref json-object "two")) => #t)
    (json:object-set! json-object "three" "three")
    (check (json:to_json json-object) => "{\"two\":[\"two\",\"two\"],\"one\":\"one\",\"three\":\"three\"}")

    (json:array-set! (json:object-ref json-object "two") 0 "hello set!")
    (json:array-append! (json:object-ref json-object "two") "hello append!")
    (check (json:to_json json-object) => "{\"two\":[\"hello set!\",\"two\",\"hello append!\"],\"one\":\"one\",\"three\":\"three\"}")
    (check (json:object-length json-object) => 3)
    (check (json:array-length (json:object-ref json-object "two")) => 3)
    (puts (json:array-delete! (json:object-ref json-object "two") 2))
    (check (json:array-length (json:object-ref json-object "two")) => 2)
    (puts (json:object-delete! json-object "two"))
    (check (json:object-length json-object) => 2)))

(test:json)
