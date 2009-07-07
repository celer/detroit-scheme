; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
; (exists proc . list) ==> boolean
;
; Test whether a given property exists in a sequence of lists.
; The property is expressed using the N-ary predicate P. P is
; first applied to a list consisting of the first member of each
; given list. If P returns truth, EXISTS returns #T immediately.
; Otherwise it is applied to a list consisting of the second
; member of each given list, etc. If P returns falsity for all
; sets of members, EXISTS returns #F.
;
; Arguments: proc - predicate
;            a*   - lists
;

(define (exists p . a*)
  (letrec
    ((car-of
       (lambda (a)
         (map car a)))
     (cdr-of
       (lambda (a)
         (map cdr a)))
     (any-null?
       (lambda (a)
         (and (memq #t (map null? a)) #t)))
     (exists*
       (lambda (a*)
         (if (any-null? a*)
             #f
             (or (apply p (car-of a*))
                 (exists* (cdr-of a*)))))))
    (exists* a*)))
