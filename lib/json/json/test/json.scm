; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; json test

(use json)

(define test:json:object:string "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\"}")

(define (test:json)
  (let ((json-object (string->json test:json:object:string)))
    (check (json:object? (string->json "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\",\"three\":true}")) => #t)
    (check (json:array? (string->json "[\"one\",{\"two\":false},\"three\"]")) => #t)
    (check (json->string json-object) => "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\"}")
    (check (json:object? json-object) => #t) 
    (check (json:object-ref json-object "one") => "one")
    (check (json:array? (json:object-ref json-object "two")) => #t)
    (check (json:map (lambda (e) e) json-object) => '())
    (check (json:array-map (lambda (e) e) (json:object-ref json-object "two")) => '("one" "two" "three"))
    (check (length 
             (json:object-map
               (lambda (k v)
                 (cond ((equal? k "two") (check (json:array? v) => #t))
                       ((equal? k "one") (check v => "one")))
                 (list k v))
               json-object)) 
           => 2)
    (json:object-set! json-object "three" "three")
    (check (json->string json-object) => "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\",\"three\":\"three\"}") 
    (json:array-set! (json:object-ref json-object "two") 0 "hello set!")
    (json:array-append! (json:object-ref json-object "two") "hello append!")
    (check (json->string json-object) => "{\"two\":[\"hello set!\",\"two\",\"three\",\"hello append!\"],\"one\":\"one\",\"three\":\"three\"}") 
    (check (json:object-length json-object) => 3)
    (check (json:array-length (json:object-ref json-object "two")) => 4)
    (check (json:array-delete! (json:object-ref json-object "two") 3) => "hello append!")
    (check (json:array-length (json:object-ref json-object "two")) => 3)
    (check (json:array? (json:object-delete! json-object "two")) => #t)
    (check (json:object-length json-object) => 2)))

(test:json)
