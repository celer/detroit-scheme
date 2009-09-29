; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; json test

(use json)

(define (test:json)
  (let* ((json-object-str "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\"}")
         (json-array-str "[\"one\",{\"two\":2},\"three\"]")
         (json-object (json:parse json-object-str))
         (json-array (json:parse json-array-str)))
    (check (json:object? (json:parse "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\",\"three\":true}")) => #t)
    (check (json:array? (json:parse "[\"one\",{\"two\":false},\"three\"]")) => #t)
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
    ;k/v -> '((k v) (k v) (k v)) ; object as a-list, uses assoc
    ; XXX: this is in reverse!
    (check (json->list "{1:1, 2:2, 3:3}") => '(("1" 1) ("2" 2) ("3" 3))) 
    ;array -> '(1 2 3 4 5 6) ; object as list
    ; XXX: this is out of order!
    (check (json->list "[1, 2, 3, 4, 5]") => '(1 2 3 4 5))
    ;k/v + array -> '((k (1 2 3)) (k v)) ; k/v with internal array list
    ; XXX: this is in reverse!
    (check (json->list "{1:[1, 2, 3], 2:2}") => '(("1" (1 2 3)) ("2" 2))) 
    ;array + k/v -> '(1 2 3 ((k v) (k v)) 4 5 6) ; array with internal objects
    ; XXX: this is in order!
    (check (json->list "[1, 2, 3, { 1:1, 2:2 }]") => '(1 2 3 (("2" 2) ("1" 1)))) 
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
