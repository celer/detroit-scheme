; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; srfi general testing - dependency testing is considered transparent

(srfi 1 9 26)

;; let-optionals*
(define (test:let-optionals*)
  (check 
    (let-optionals* '(one two) ((a 1) (b 2) (c a))
		    (list a b c)) 
    => '(one two one)))

;; srfi-1
(define (test:srfi-1)
  (check (first '(1 2 3 4)) => 1)
  (check (second '(1 2 3 4)) => 2)
  (check (third '(1 2 3 4)) => 3)
  (check (fourth '(1 2 3 4)) => 4)
  (check (split-at '(1 2 3 4) 2) => '(1 2))
  (check (delete 2 '(1 2 3 4)) => '(1 3 4))
  (check (delete-duplicates '(1 2 2 3)) => '(1 2 3))
  (check (remove even? '(1 2 3 4)) => '(1 3)))

;; srfi-2
(define (test:srfi-2)
  (check 
    (and-let* ((test-list '(1 2 3 4)) 
	       ((not (null? test-list))))
	      test-list) 
    => '(1 2 3 4)))

;; srfi-9
(define-record-type 
  :pare
  (kons x y)
  pare?
  (x kar set-kar!)
  (y kdr))

(define (test:srfi-9)
  (let ((k (kons 1 2)))
    (check (pare? k) => #t)
    (set-kar! k 3)
    (check (kar k) => 3)
    (check (kdr k) => 2)))

;; srfi-11
;; TODO: finish port

;; srfi-16
(define plus
  (case-lambda 
    (() 0)
    ((x) x)
    ((x y) (+ x y))
    ((x y z) (+ (+ x y) z))
    (args (apply + args))))

(define (test:srfi-16)
  (check (plus) => 0)
  (check (plus 1) => 1)
  (check (plus 1 2 3) => 6))

;; srfi-26
(define (test:srfi-26)
  (check (procedure? (cut cons (+ a 1) <>)) => #t))

;; run tests
(test:let-optionals*)
(test:srfi-1)
(test:srfi-2)
(test:srfi-9)
(test:srfi-16)
(test:srfi-26)

;; produce a report
(check-report)

