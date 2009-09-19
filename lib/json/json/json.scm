; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; json library

; parse json string
(define json:parse (constructor "org.json.JSONObject" "java.lang.String"))

; produce json string from object
(define json:to_json (method "org.json.JSONObject" "toString"))

; get the value associated with a key
(define json:object-ref (method "org.json.JSONObject" "get" "java.lang.String"))

; associate a value with a key
(define json:object-set! (method "org.json.JSONObject" "put" "java.lang.String" "java.lang.Object"))

; get the object length
(define json:object-length (method "org.json.JSONObject" "length"))

; delete an object with key
(define json:object-delete! (method "org.json.JSONObject" "remove" "java.lang.String"))

; get an index for an array
(define json:array-ref (method "org.json.JSONArray" "get" "int"))

; put an object at the index
(define json:array-set! (method "org.json.JSONArray" "put" "int" "java.lang.Object"))

; delete an object at the index
(define json:array-delete! (method "org.json.JSONArray" "remove" "int"))

; get the length of a json array
(define json:array-length (method "org.json.JSONArray" "length"))

; XXX: accessors to object
; json <-> sexp
