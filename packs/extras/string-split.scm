; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (string-split char string) ==> list
;
; Split a string into substrings.
; Return a list containing all cohesive sequences of
; non-separating characters contained in the given string.
;
; Arguments: c - separating character
;            s - string to split
;

(define (string-split c s)
  (letrec
    ((skip-separators
       (lambda (i k)
         (cond ((= i k) i)
               ((char=? (string-ref s i) c)
                 (skip-separators (+ i 1) k))
               (else i))))
     (split
       (lambda (i k tmp res)
         (cond ((= i k)
                 (if (string=? "" tmp)
                     res
                     (cons tmp res)))
               ((char=? (string-ref s i) c)
                 (split (skip-separators i k)
                        k
                        ""
                        (cons tmp res)))
               (else (split (+ 1 i)
                            k
                            (string-append
                              tmp
                              (string (string-ref s i)))
                            res))))))
    (let ((k (string-length s)))
      (reverse (split (skip-separators 0 k) k "" '())))))
