; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (partition proc^1 list) ==> (list_1 list_2)
;
; Partition a list into elements with and without a given property.
; The predicate P specifies the property. The returned value
; contains two lists, where the first one holds the elements
; satisfying the property and the second one the elements not
; satisfying the property.
;
; Arguments: p - predicate
;            a - source list
;

(define (partition p a)
  (letrec
    ((partition3
       (lambda (a r+ r-)
         (cond
           ((null? a)
             (list r+ r-))
           ((p (car a))
             (partition3 (cdr a)
                         (cons (car a) r+)
                         r-))
           (else
             (partition3 (cdr a)
                         r+
                         (cons (car a) r-)))))))
    (partition3 (reverse a) '() '())))
