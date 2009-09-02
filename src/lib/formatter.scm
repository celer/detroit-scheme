; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

; java formatter
(define (formatter format . args)
  (let ((format-method (method "java.lang.String" "format" "java.lang.String" "[Ljava.lang.Object;")))
    (format-method
      (string->symbol format)
      (make-array
        "java.lang.Object"
        (map
          (lambda (s)
            (if (string? s)
              (string->symbol s)
              s))
          args)))))

