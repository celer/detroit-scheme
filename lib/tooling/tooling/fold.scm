; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.
(define (map-car f a)
  (letrec
    ((mapcar1
       (lambda (a r)
         (if (null? a)
             (reverse r)
             (mapcar1 (cdr a)
                      (cons (f (car a)) r))))))
    (mapcar1 a '())))

(define car-of
  (let ((map-car map-car))
    (lambda (a*)
      (map-car car a*))))

(define cdr-of
  (let ((map-car map-car))
    (lambda (a*)
      (map-car cdr a*))))

(define any-null?
  (let ((map-car map-car))
    (lambda (a*)
      (and (memq #t (map-car null? a*)) #t))))

(define fold-left
  (let ((car-of car-of)
	(cdr-of cdr-of
		(any-null? any-null?)))
    (lambda (f b . a*)
      (letrec
	((fold
	   (lambda (a* r)
	     (if (any-null? a*)
	       r
	       (fold (cdr-of a*)
		     (apply f r (car-of a*)))))))
	(if (null? a*)
	  (wrong "fold-left: too few arguments")
	  (fold a* b))))))

(define fold-right
  (let ((car-of car-of)
	(cdr-of cdr-of
		(any-null? any-null?)))
    (lambda (f b . a*)
      (letrec
	((foldr
	   (lambda (a* r)
	     (if (any-null? a*)
	       r
	       (foldr (cdr-of a*)
		      (apply f (append (car-of a*)
				       (list r))))))))
	(if (null? a*)
	  (wrong "fold-right: too few arguments")
	  (foldr (map reverse a*) b))))))

