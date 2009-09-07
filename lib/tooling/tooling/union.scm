; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (union . list) ==> list
;
; Compute the union of a number of sets.
;
; Arguments: a* - sets
;

(use list-to-set)

(define (union . a*)
  (list->set (apply append a*)))
