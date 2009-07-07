; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (transpose list) ==> list
;
; Transpose a matrix.
; A matrix is represented using a nested list, where each
; inner list is a column of the matrix.
;
; Arguments: x - matrix
;

(define (transpose x)
  (apply map list x))
