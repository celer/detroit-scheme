; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; json library

; parse json string
(define json:parse (constructor "org.json.JSONObject" "java.lang.String"))

; produce json string from object
(define json:to_json (method "org.json.JSONObject" "toString"))

; XXX: accessors to object
; json <-> sexp
