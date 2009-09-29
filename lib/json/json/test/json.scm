; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; json test

(use json)

(define test:json:native:object:string "{\"two\":[\"one\",\"two\",\"three\"],\"one\":\"one\"}")

(define (test:json:native)
  (let ((json-object (json:parse test:json:native:object:string)))
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


(define (test:json)
    ;k/v -> '((k v) (k v) (k v)) ; object as a-list, uses assoc
    (check (json->list "{1:1, 2:2, 3:3}") => '(("1" 1) ("2" 2) ("3" 3))) 
    ;array -> '(1 2 3 4 5 6) ; object as list
    (check (json->list "[1, 2, 3, 4, 5]") => '(1 2 3 4 5))
    ;k/v + array -> '((k (1 2 3)) (k v)) ; k/v with internal array list
    ; XXX: for some reason the keys are coming back as being symbols and then converted to strings when they're numbers
    (check (json->list "{1:[1, 2, 3], 2:2}") => '(("1" (1 2 3)) ("2" 2))) 
    ;array + k/v -> '(1 2 3 ((k v) (k v)) 4 5 6) ; array with internal objects
    (check (json->list "[1, 2, 3, { 1:1, 2:2 }]") => '(1 2 3 (("1" 1) ("2" 2))))
    ; XXX: ->json 
  )

;(test:json:native)
(test:json)
