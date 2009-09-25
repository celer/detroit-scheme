; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; json test

(use json)

(define (test:json)
  (let ((json-object (json:parse "{\"two\":[\"two\",\"two\"],\"one\":\"one\"}")))
    (check (json:to_json json-object) => "{\"two\":[\"two\",\"two\"],\"one\":\"one\"}")
    (check (json:object? json-object) => #t) 
    (check (json:object-ref json-object "one") => "one")
    (check (json:array? (json:object-ref json-object "two")) => #t)
    (check (json:array-map (lambda (e) e) (json:object-ref json-object "two")) => '("two" "two"))
    (json:object-map
      (lambda (k v)
        (if (equal? k "two")
          (check (json:array? v) => #t))
        (format #t "~A:~A~%" k v))
      json-object)
    (json:object-set! json-object "three" "three")
    (check (json:to_json json-object) => "{\"two\":[\"two\",\"two\"],\"one\":\"one\",\"three\":\"three\"}")

    (json:array-set! (json:object-ref json-object "two") 0 "hello set!")
    (json:array-append! (json:object-ref json-object "two") "hello append!")
    (check (json:to_json json-object) => "{\"two\":[\"hello set!\",\"two\",\"hello append!\"],\"one\":\"one\",\"three\":\"three\"}")
    (check (json:object-length json-object) => 3)
    (check (json:array-length (json:object-ref json-object "two")) => 3)
    (check (json:array-delete! (json:object-ref json-object "two") 2) => "hello append!")
    (check (json:array-length (json:object-ref json-object "two")) => 2)
    (check (json:array? (json:object-delete! json-object "two")) => #t)
    (check (json:object-length json-object) => 2)))

(test:json)
