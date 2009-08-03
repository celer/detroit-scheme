; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; Digest Library 

; get an instance of a specific algorithm
(define (digest:algorithm algorithm)
  ((method "java.security.MessageDigest" "getInstance" "java.lang.String") 
   algorithm))

; call update on a message digest with a message
(define (digest:update md msg)
  ((method "java.security.MessageDigest" "update" "[B") md msg))

; call digest on a message digest
(define (digest:digest md)
  ((method "java.security.MessageDigest" "digest") md))

; convert string to bytes
(define (digest:string->bytes s)
  ((method "java.lang.String" "getBytes") (string->symbol s)))

; convert bytes to string
(define (digest:bytes->string b)
  ((constructor "java.lang.String" "[B") b))

; make a big integer
(define (digest:bigint:new b)
  ((constructor "java.math.BigInteger" "int" "[B") 1 b))

; get a string representation of a bigint
(define (digest:bigint->string bi r) 
  ((method "java.math.BigInteger" "toString" "int") bi r))

; convert to hex string
(define (digest:bytes->hex b) 
  (digest:bigint->string
    (digest:bigint:new b)
    16)) 

; call a has algorithm on a message string
(define (digest:hash algorithm msg)
  (let ((md (digest:algorithm algorithm)))
    (digest:update md (digest:string->bytes msg))
    (symbol->string
      (digest:bytes->hex
        (digest:digest md)))))

; MD5
(define (digest:md5 msg)
  (digest:hash "MD5" msg))

; SHA-1
(define (digest:sha-1 msg)
  (digest:hash "SHA-1" msg))

