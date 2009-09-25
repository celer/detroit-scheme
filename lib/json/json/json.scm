; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; json library

; parse json string
(define json:parse (constructor "org.json.JSONObject" "java.lang.String"))

; produce json string from object
(define (json:to_json input)
  (let* ((get (method "org.json.JSONObject" "toString"))
         (result (get input)))
    (if (symbol? result)
      (symbol->string result)
      result)))

; get the value associated with a key
(define (json:object-ref object key) 
  (let* ((get (method "org.json.JSONObject" "get" "java.lang.String"))
         (result (get object key)))
    (if (symbol? result)
      (symbol->string result)
      result)))

; associate a value with a key
(define (json:object-set! object key value)
  (let ((put (method "org.json.JSONObject" "put" "java.lang.String" "java.lang.Object")))
    (if (string? value)
      (put object key (string->symbol value))
      (put object key value))))

; get the object length
(define json:object-length (method "org.json.JSONObject" "length"))

; delete an object with key
(define (json:object-delete! object key)
  (let* ((remove (method "org.json.JSONObject" "remove" "java.lang.String"))
         (result (remove object key)))
    (if (symbol? result)
      (symbol->string result)
      result)))

; get an index for an array
(define (json:array-ref object index)
  (let* ((get (method "org.json.JSONArray" "get" "int"))
         (result (get object index)))
    (if (symbol? result)
      (symbol->string result)
      result)))

; put an object at the index
(define (json:array-set! object index value)
  (let ((put (method "org.json.JSONArray" "put" "int" "java.lang.Object")))
    (if (string? value)
      (put object index (string->symbol value))
      (put object index value))))

; append an object to the array
(define (json:array-append! object value)
  (let ((put (method "org.json.JSONArray" "put" "java.lang.Object")))
    (if (string? value)
      (put object (string->symbol value))
      (put object value))))

; delete an object at the index
(define (json:array-delete! object index)
  (let* ((remove (method "org.json.JSONArray" "remove" "int"))
         (result (remove object index)))
    (if (symbol? result)
      (symbol->string result)
      result)))

; get the length of a json array
(define json:array-length (method "org.json.JSONArray" "length"))

; JSONObject type predicate
(define json:object? (make-type-predicate "org.json.JSONObject"))

; JSONArray type predicate
(define json:array? (make-type-predicate "org.json.JSONArray"))

; map a procedure over a json array
(define (json:array-map proc array)
  (if (json:array? array)
    (let ((len (json:array-length array)))
      (let loop ((current 0) (acc '()))
        (if (< current len)
          (loop
            (+ 1 current)
            (cons
              (proc (json:array-ref array current))
              acc))
          acc)))
    #f))

; map a procedure over a json object
(define (json:object-map proc obj)
  (if (json:object? obj)
    (let* ((get-keys (method "org.json.JSONObject" "keys"))
           (hasNext (method "java.util.Iterator" "hasNext"))
           (next (method "java.util.Iterator" "next"))
           (keys (get-keys obj)))
      (let loop ((acc '()))
        (if (hasNext keys)
          (let ((key (symbol->string (next keys))))
            (loop
              (cons
                (proc key (json:object-ref obj key))
                acc)))
          acc)))
    #f))

