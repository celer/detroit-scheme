; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (remove proc^1 list) ==> list
;
; Remove elements from a list.
; The predicate P describes the property
; of the elements to be removed.
;
; Arguments: p - predicate
;            a - source list
;

(use 'filter)

(define (remove p a)
  (filter (lambda (x) (not (p x))) a))
