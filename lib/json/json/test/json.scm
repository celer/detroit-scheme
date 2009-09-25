; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; json test

(use json)

(define (test:json)
  ; XXX: need some other values in here besides string
  (let ((json-object (json:parse "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\"}"))
        ; XXX: object inside
        (json-array (json:parse "[\"one\",\"two\",\"three\"]")))
    (display (json:parse "[\"one\",\"two\":\"two\",\"three\"]")) (newline)
    (check (json:to_json json-object) => "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\"}")
    (check (json:object? json-object) => #t) 
    (check (json:object-ref json-object "one") => "one")
    (check (json:array? (json:object-ref json-object "two")) => #t)
    (check (json:array-map (lambda (e) e) (json:object-ref json-object "two")) => '("one" "two" "three"))
    (check (length 
             (json:object-map
               (lambda (k v)
                 (cond ((equal? k "two") (check (json:array? v) => #t))
                       ((equal? k "one") (check v => "one")))
                 (list k v))
               json-object)) 
           => 2)
    ; XXX: fix form
    (check (json->list json-object) => '(("two" "one" "two" "three") ("one" . "one"))) 
    (check (json->list json-array) => '("one" "two" "three"))
    ; XXX: ->json 
    (json:object-set! json-object "three" "three")
    (check (json:to_json json-object) => "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\",\"three\":\"three\"}") 

    (json:array-set! (json:object-ref json-object "two") 0 "hello set!")
    (json:array-append! (json:object-ref json-object "two") "hello append!")
    (check (json:to_json json-object) => "{\"two\":[\"hello set!\",\"two\",\"three\",\"hello append!\"],\"one\":\"one\",\"three\":\"three\"}") 
    (check (json:object-length json-object) => 3)
    (check (json:array-length (json:object-ref json-object "two")) => 4)
    (check (json:array-delete! (json:object-ref json-object "two") 3) => "hello append!")
    (check (json:array-length (json:object-ref json-object "two")) => 3)
    (check (json:array? (json:object-delete! json-object "two")) => #t)
    (check (json:object-length json-object) => 2)))

(test:json)
