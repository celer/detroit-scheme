; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(use pregexp)

; url

; make a new url object
(define (url:new url)
  ((constructor "java.net.URL" "java.lang.String")
   (string->symbol url)))

; get part of a url
(define (url:get part url)
  (let ((result
          ((method
             "java.net.URL"
             (string->symbol
               (format #f "get~@(~a"
                       (symbol->string part))))
           url)))
    (if (null? result)
      ""
      (symbol->string result))))

; parse query portion of a url
(define (url:query:parse query)
  (let ((table (make-hash-table)))
    (for-each
      (lambda (l)
        (let* ((kv (pregexp-split "=" l))
               (key (car kv))
               (value (cadr kv)))
          (hash-table-set! table key value)))
      (pregexp-split "&" query))
    table))

; find a key in the query table
(define (url:query:key ht key)
  (hash-table-ref ht key))

