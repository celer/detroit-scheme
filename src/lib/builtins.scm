; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(define (list . items)
  items)

(define (null? x) (eq? x '()))

(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cdar x) (cdr (car x)))
(define (cddr x) (cdr (cdr x)))

(define (caaar x) (car (caar x)))
(define (caadr x) (car (cadr x)))
(define (cadar x) (car (cdar x)))
(define (caddr x) (car (cddr x)))
(define (cdaar x) (cdr (caar x)))
(define (cdadr x) (cdr (cadr x)))
(define (cddar x) (cdr (cdar x)))
(define (cdddr x) (cdr (cddr x)))

(define (caaaar x) (car (caaar x)))
(define (caaadr x) (car (caadr x)))
(define (caadar x) (car (cadar x)))
(define (caaddr x) (car (caddr x)))
(define (cadaar x) (car (cdaar x)))
(define (cadadr x) (car (cdadr x)))
(define (caddar x) (car (cddar x)))
(define (cadddr x) (car (cdddr x)))
(define (cdaaar x) (cdr (caaar x)))
(define (cdaadr x) (cdr (caadr x)))
(define (cdadar x) (cdr (cadar x)))
(define (cdaddr x) (cdr (caddr x)))
(define (cddaar x) (cdr (cdaar x)))
(define (cddadr x) (cdr (cdadr x)))
(define (cdddar x) (cdr (cddar x)))
(define (cddddr x) (cdr (cdddr x)))

(define make-type-predicate
  ((lambda (is-instance?)
     (lambda (type)
       ((lambda (class) 
          (lambda (x)
            (call-method is-instance? class x)))
        (class type))))
   (method "java.lang.Class"
           "isInstance"
           (list
             (class "java.lang.Object")))))

(define symbol? (make-type-predicate "java.lang.String"))
(define pair? (make-type-predicate "detroit.Pair"))

(define (map fun l)
  (if (null? l)
    '()
    (cons (fun (car l))
          (map fun (cdr l)))))

(add-macro 'let
           (lambda args
             (if (symbol? (car args))
               (begin
                 (list (list 'lambda
                             (list (car args))
                             (list 'set! (car args)
                                   (cons 'lambda
                                         (cons (map car (cadr args))
                                               (cddr args))))
                             (cons (car args)
                                   (map cadr (cadr args))))
                       '()))
               (begin
                 (cons (cons 'lambda
                             (cons (map car (car args))
                                   (cdr args)))
                       (map cadr (car args)))))))

(add-macro 'let* (lambda (vars . body)
                   (let loop ((vars vars))
                     (if (null? vars)
                       (cons 'let (cons '() body))
                       (list 'let (list (car vars)) (loop (cdr vars)))))))

(define unspecified (let ((unspec (if #f #f))) (lambda () unspec)))

(define (not x) (if x #f #t))

(define (zero? x) (= x 0))

(define (reverse! list)
  (let loop ((list list)
             (last-pair '()))
    (if (null? list)
      last-pair
      (let ((rest (cdr list)))
        (set-cdr! list last-pair)
        (loop rest list)))))

(add-macro 'simple-cond
           (lambda exprs
             (let loop ((exprs exprs))
               (if (null? exprs)
                 (unspecified)
                 (if (eq? (caar exprs) 'else)
                   (cons 'begin (cdar exprs))
                   (cons 'if
                         (cons (caar exprs)
                               (cons (cons 'begin (cdar exprs))
                                     (cons (loop (cdr exprs)) ())))))))))

(add-macro 'and (lambda args
                  (simple-cond
                    ((null? args) #t)
                    ((null? (cdr args)) (car args))
                    (else (list 'if (car args) (cons 'and (cdr args)) #f)))))

(add-macro 'quasiquote
           (lambda (x)
             (let expand ((form x)
                          (nesting 0))
               (simple-cond
                 ((if (symbol? form)
                    #t
                    (null? form))
                  (list 'quote form))
                 ((not (pair? form)) 
                  form)
                 ((eq? (car form) 'unquote)
                  (if (zero? nesting)
                    (cadr form)
                    (list 'list
                          (list 'quote 'unquote)
                          (expand (cadr form) (- nesting 1)))))
                 ((eq? (car form) 'quasiquote)
                  (list 'list
                        (list 'quote 'quasiquote)
                        (expand (cadr form) (+ nesting 1))))
                 ((and (pair? (car form))
                       (eq? (caar form) 'unquote-splicing)
                       (zero? nesting))
                  (list 'append
                        (cadar form)
                        (expand (cdr form) nesting)))
                 (else
                   (list 'cons
                         (expand (car form) nesting)
                         (expand (cdr form) nesting)))))))

(add-macro 'when (lambda (test . body)
                   `(if ,test
                      (begin ,@body))))

(add-macro 'unless (lambda (test . body)
                     `(if (not ,test)
                        (begin ,@body))))

(define method
  (let ((built-in method))
    (lambda (clas name . types)
      (let ((m (built-in clas name (map class types))))
        (lambda args
          (apply call-method m args))))))

(define constructor
  (let ((get-con (method "java.lang.Class" "getConstructor" "[Ljava.lang.Class;"))) 
    (lambda (clas . args)
      (let ((c (get-con (class clas) (make-array "java.lang.Class"
                                                 (map class args)))))
        (lambda args
          (apply call-constructor c args))))))

(define field
  (let ((get-field (method "java.lang.Class" "getField" "java.lang.String"))
        (field-modifiers (method "java.lang.reflect.Field" "getModifiers"))
        (field-ref (method "java.lang.reflect.Field" "get" "java.lang.Object"))
        (field-set! (method "java.lang.reflect.Field" "set" "java.lang.Object" "java.lang.Object"))
        (is-static (method "java.lang.reflect.Modifier" "isStatic" "int")))

    (lambda (clas name)
      (let ((field (get-field (class clas) name)))
        (if (is-static (field-modifiers field))
          (lambda new-val
            (if (pair? new-val)
              (field-set! field '() (car new-val))
              (field-ref field '()))) 
          (lambda (obj . new-val)
            (if (pair? new-val)
              (field-set! field obj (car new-val))
              (field-ref field obj))))))))

(define jstring (constructor "java.lang.String" "[C"))

(define vector-length (method "java.lang.reflect.Array" "getLength" "java.lang.Object"))
(define vector-ref (method "java.lang.reflect.Array" "get" "java.lang.Object" "int"))
(define vector-set! (method "java.lang.reflect.Array" "set" "java.lang.Object" "int" "java.lang.Object"))

(define (vector->list v)
  (let loop ((i 0)
             (len (vector-length v))
             (acc '()))
    (if (= i len)
      (reverse! acc)
      (loop (+ i 1) len (cons (vector-ref v i) acc)))))

(define (list->vector list)
  (make-array "java.lang.Object" list))

(define (vector . elements)
  (list->vector elements))


(define string? (make-type-predicate "[C"))

(define string<?  #f)
(define string<=? #f)
(define string=?  #f)
(define string>=? #f)
(define string>?  #f)

(define string-ci<?  #f)
(define string-ci<=? #f)
(define string-ci=?  #f)
(define string-ci>=? #f)
(define string-ci>?  #f)

(let* ((compare-to (method "java.lang.String" "compareTo" "java.lang.String"))
       (lower (method "java.lang.String" "toLowerCase"))
       (compare-to-ci (lambda (a b)
                        (compare-to (lower a) (lower b)))))

  (set! string<?  (lambda (a b) (<  (compare-to (jstring a) (jstring b)) 0)))
  (set! string<=? (lambda (a b) (<= (compare-to (jstring a) (jstring b)) 0)))
  (set! string=?  (lambda (a b) (=  (compare-to (jstring a) (jstring b)) 0)))
  (set! string>=? (lambda (a b) (>= (compare-to (jstring a) (jstring b)) 0)))
  (set! string>?  (lambda (a b) (>  (compare-to (jstring a) (jstring b)) 0)))
  (set! string-ci<?  (lambda (a b) (<  (compare-to-ci (jstring a) (jstring b)) 0)))
  (set! string-ci<=? (lambda (a b) (<= (compare-to-ci (jstring a) (jstring b)) 0)))
  (set! string-ci=?  (lambda (a b) (=  (compare-to-ci (jstring a) (jstring b)) 0)))
  (set! string-ci>=? (lambda (a b) (>= (compare-to-ci (jstring a) (jstring b)) 0)))
  (set! string-ci>?  (lambda (a b) (>  (compare-to-ci (jstring a) (jstring b)) 0))))

(define string-length (method "java.lang.reflect.Array" "getLength" "java.lang.Object"))
(define string-ref (method "java.lang.reflect.Array" "getChar" "java.lang.Object" "int"))
(define string-set! (method "java.lang.reflect.Array" "setChar" "java.lang.Object" "int" "char"))

(define string->symbol
  (let ((ns (constructor "java.lang.String" "[C"))
        (intern (method "java.lang.String" "intern")))
    (lambda (str)
      (intern (ns str)))))

(define symbol->string (method "java.lang.String" "toCharArray")) 

(define (substring string start end)
  (let ((len (- end start))
        (res '()))
    (set! res (make-string len))
    (string-blit! string start res 0 len)
    res))

(define (string-copy string)
  (let ((len (string-length string))
        (res '()))
    (set! res (make-string len))
    (string-blit! string 0 res 0 len)
    res))

(define (string-append . parts)
  (let ((len (let loop ((parts parts)
                        (acc 0))
               (if (null? parts)
                 acc
                 (loop (cdr parts) (+ acc (string-length (car parts)))))))
        (res '()))
    (set! res (make-string len))
    (let loop ((parts parts)
               (index 0))
      (if (null? parts)
        res
        (let ((len (string-length (car parts))))
          (string-blit! (car parts) 0 res index len)
          (loop (cdr parts) (+ index len)))))))

(define conc string-append)

(define (list->string chars)
  (let ((res (make-string (length chars))))
    (let loop ((idx 0)
               (chars chars))
      (if (null? chars)
        res
        (begin
          (string-set! res idx (car chars))
          (loop (+ idx 1) (cdr chars)))))))

(define (string->list str)
  (let loop ((idx 0)
             (len (string-length str)))
    (if (eqv? idx len)
      '()
      (cons (string-ref str idx) (loop (+ idx 1) len)))))

(define (string . chars)
  (make-array "char" chars))

(define string->number
  (let ((parseInt (method "java.lang.Integer" "parseInt" "java.lang.String"))
        (parseDouble (method "java.lang.Double" "valueOf" "java.lang.String")))
    (lambda (str)
      (let ((string (jstring str)))
        (try-catch-finally
          (lambda ()
            (parseInt string))
          (lambda ()
            (try-catch-finally
              (lambda ()
                (parseDouble string))
              (lambda ()
                #f)
              #f))
          #f)))))

(define number->string
  (let ((toString (method "java.lang.Number" "toString")))
    (lambda (x)
      (symbol->string (toString x)))))


(define debug
  (let ((err ((field "java.lang.System" "err")))
        (println (method "java.io.PrintStream" "println" "java.lang.Object")))
    (lambda (x)
      (println err (if (string? x)
                     (jstring x)
                     x))
      x)))

(define gensym
  (let ((counter 0))
    (lambda rest
      (set! counter (+ counter 1))
      (jstring (string-append "__sym__" (number->string counter))))))

(add-macro 'cond (lambda exprs
                   (let ((tmp (gensym)))
                     (let loop ((exprs exprs))
                       (simple-cond
                         ((null? exprs)
                          #f)
                         ((eq? (caar exprs) 'else)
                          `(begin . ,(cdar exprs)))
                         ((null? (cdar exprs))
                          `(let ((,tmp ,(caar exprs)))
                             (if ,tmp
                               ,tmp
                               ,(loop (cdr exprs)))))
                         ((eq? (cadar exprs) '=>)
                          `(let ((,tmp ,(caar exprs)))
                             (if ,tmp
                               (,(caddar exprs) ,tmp)
                               ,(loop (cdr exprs)))))
                         (else
                           `(if ,(caar exprs)
                              (begin . ,(cdar exprs))
                              ,(loop (cdr exprs)))))))))

(add-macro 'or (lambda args
                 (cond
                   ((null? args)
                    #f)
                   ((null? (cdr args))
                    (car args))
                   (else
                     (let ((tmp (gensym)))
                       `(let ((,tmp ,(car args)))
                          (if ,tmp ,tmp
                            ,(let loop ((args (cdr args)))
                               (if (null? (cdr args))
                                 (car args)
                                 `(begin
                                    (set! ,tmp ,(car args))
                                    (if ,tmp ,tmp
                                      ,(loop (cdr args)))))))))))))


(define full-eval (method "detroit.Interpreter" "eval" "java.lang.Object" "java.lang.Object" "detroit.Environment"))

(add-macro 'raw (lambda (form)
                  `(full-eval (interpreter)
                              '()
                              '(identity
                                 ,form)
                              (current-environment))))

(define make-char-array (constructor "detroit.CharArray" "[C"))
(define char-array? (make-type-predicate "detroit.CharArray"))
(define char-array-of (field "detroit.CharArray" "charArray"))

(define (ht-wrap-key key)
  (if (string? key)
    (make-char-array key)
    key))

(define (ht-unwrap-key key)
  (if (char-array? key)
    (char-array-of key)
    key))

(define ht-null (cons #f #f))

(define (ht-wrap-value value)
  (if (null? value)
    ht-null
    value))

(define (ht-unwrap-value value)
  (if (eq? value ht-null)
    '()
    value))


(define make-hash-table (constructor "java.util.Hashtable"))
(define hash-table? (make-type-predicate "java.util.Hashtable"))

(define native-hash-table-ref #f)
(define native-hash-table-ref/default #f)
(define native-hash-table-set! #f)
(define native-hash-table-exists? #f)
(define native-hash-table-delete! #f)
(define native-hash-table-keys #f)
(define native-hash-table-values #f)
(define native-hash-table-for-each #f)
(define native-hash-table-map #f)

(let ((get (method "java.util.Hashtable" "get" "java.lang.Object"))
      (put (method "java.util.Hashtable" "put" "java.lang.Object" "java.lang.Object"))
      (exists (method "java.util.Hashtable" "containsKey" "java.lang.Object"))
      (delete (method "java.util.Hashtable" "remove" "java.lang.Object"))
      (hasMoreElements (method "java.util.Enumeration" "hasMoreElements"))
      (nextElement (method "java.util.Enumeration" "nextElement"))
      (keys (method "java.util.Hashtable" "keys"))
      (elements (method "java.util.Hashtable" "elements")))

  (set! native-hash-table-ref
    (lambda (ht key)
      (ht-unwrap-value (get ht (ht-wrap-key key)))))

  (set! native-hash-table-ref/default
    (lambda (ht key . opt-default)
      (let ((res (native-hash-table-ref ht key)))
        (if (and (null? res) (pair? opt-default))
          (car opt-default)
          res))))

  (set! native-hash-table-set!
    (lambda (ht key val)
      (put ht (ht-wrap-key key) (ht-wrap-value val))))

  (set! native-hash-table-exists?
    (lambda (ht key)
      (exists ht (ht-wrap-key key))))

  (set! native-hash-table-delete!
    (lambda (ht key)
      (delete ht (ht-wrap-key key))))

  (let ((gather (lambda (proc enum)
                  (let loop ((acc '()))
                    (if (hasMoreElements enum)
                      (loop (cons (proc (nextElement enum)) acc))
                      acc)))))

    (set! native-hash-table-keys
      (lambda (ht)
        (gather ht-unwrap-key (keys ht))))

    (set! native-hash-table-values
      (lambda (ht)
        (gather ht-unwrap-value (elements ht))))

    (set! native-hash-table-for-each
      (lambda (ht proc)
        (let loop ((enum (keys ht)) (acc '()))
          (if (hasMoreElements enum)
            (loop enum (let ((key (nextElement enum)))
                         (proc (ht-unwrap-key key)
                               (ht-unwrap-value (get ht key)))))))))

    (set! native-hash-table-map
      (lambda (ht proc)
        (gather
          (lambda (key)
            (proc (ht-unwrap-key key)
                  (ht-unwrap-value (get ht key))))
          (keys ht))))))


(define make-parameter
  (let ((current-thread (method "java.lang.Thread" "currentThread")))
    (lambda (initial-value . opt-converter)
      (let ((thread-locals (make-hash-table))
            (converter (if (pair? opt-converter)
                         (car opt-converter)
                         (lambda (x) x))))
        (set! initial-value (converter initial-value))
        (lambda opt-new-value
          (if (pair? opt-new-value)
            (begin
              (native-hash-table-set! thread-locals (current-thread) (converter (car opt-new-value)))
              (unspecified))
            (native-hash-table-ref/default thread-locals (current-thread) initial-value)))))))

(define get-env (method "detroit.Interpreter" "getEnv" "java.lang.Object"))

(define (lookup-environment name)
  (if (or (symbol? name)
          (pair? name))
    (get-env (interpreter) name)
    name))

(define scheme-report-environment (make-parameter 'r5rs lookup-environment))
(define current-environment scheme-report-environment)
(define interaction-environment current-environment)

(define env-macros (field "detroit.Environment" "macros"))

(add-macro 'define-macro
           (lambda (name+args . body)
             (native-hash-table-set!
               (env-macros (current-environment))
               (car name+args)
               (full-eval (interpreter)
                          identity
                          `(lambda ,(cdr name+args)
                             . ,body)
                          (current-environment)))
             #f))


(add-macro 'case (lambda (var . exprs)
                   (let ((tmp (gensym)))
                     `(let ((,tmp ,var))
                        ,(let loop ((exprs exprs))
                           (cond
                             ((null? exprs)
                              '(if #f #f))
                             ((eq? (caar exprs) 'else)
                              `(begin . ,(cdar exprs)))
                             (else
                               `(if (memv ,tmp ',(caar exprs))
                                  (begin . ,(cdar exprs))
                                  ,(loop (cdr exprs))))))))))

(add-macro 'letrec* (lambda (vars . body)
                      `((lambda ,(map car vars)
                          ,@(map (lambda (var)
                                   (cons 'set! var))
                                 vars)
                          . ,body)
                        . ,(map (lambda (x) #f) vars))))

(add-macro 'letrec (lambda args
                     `(letrec* . ,args)))

(add-macro 'do (lambda (bindings test-and-result . body)
                 (let ((variables (map (lambda (clause)
                                         (list (car clause) (cadr clause)))
                                       bindings))
                       (steps (map (lambda (clause)
                                     (if (null? (cddr clause))
                                       (car clause)   
                                       (caddr clause)))
                                   bindings))
                       (test (car test-and-result))
                       (result (cdr test-and-result))
                       (loop (gensym)))
                   `(let ,loop ,variables
                      (if ,test
                        (begin ,(if (null? result)
                                  '(unspecified)
                                  (car result)))
                        (begin
                          ,@body
                          (,loop ,@steps)))))))


(define (integer? x)
  (if (exact? x)
    #t
    (inexact? x)))

(define rational? integer?)
(define real? rational?)
(define complex? real?)
(define number? complex?)

(define exact? (make-type-predicate "java.lang.Integer"))
(define inexact? (make-type-predicate "java.lang.Double"))

(define (zero? x)
  (= x 0))

(define (positive? x)
  (> x 0))

(define (negative? x)
  (< x 0))

(define (odd? x)
  (= (modulo x 2) 1))

(define (even? x)
  (= (modulo x 2) 0))

(define (min . args)
  (let loop ((min (car args))
             (rest (cdr args)))
    (cond
      ((null? rest)
       min)
      ((< (car rest) min)
       (loop (car rest) (cdr rest)))
      (else
        (loop min (cdr rest))))))

(define (max . args)
  (let loop ((max (car args))
             (rest (cdr args)))
    (cond
      ((null? rest)
       max)
      ((> (car rest) max)
       (loop (car rest) (cdr rest)))
      (else
        (loop max (cdr rest))))))

(define (abs x)
  (if (< x 0)
    (- x)
    x))

(define floor (method "java.lang.Math" "floor" "double"))
(define ceiling (method "java.lang.Math" "ceil" "double"))

(define exp (method "java.lang.Math" "exp" "double"))
(define log (method "java.lang.Math" "log" "double"))

(define sin (method "java.lang.Math" "sin" "double"))
(define cos (method "java.lang.Math" "cos" "double"))
(define tan (method "java.lang.Math" "tan" "double"))

(define asin (method "java.lang.Math" "asin" "double"))
(define acos (method "java.lang.Math" "acos" "double"))

(define atan1 (method "java.lang.Math" "atan" "double"))
(define atan2 (method "java.lang.Math" "atan2" "double" "double"))
(define (atan x . opt-y)
  (if (pair? opt-y)
    (atan2 x (car opt-y))
    (atan1 x)))

(define sqrt (method "java.lang.Math" "sqrt" "double"))
(define expt (method "java.lang.Math" "pow" "double" "double"))

(define exact->inexact (method "java.lang.Number" "doubleValue"))
(define inexact->exact (method "java.lang.Number" "intValue"))


(define boolean? (make-type-predicate "java.lang.Boolean"))

(define (list-ref list count)
  (car (list-tail list count)))

(define (memq item list)
  (cond
    ((null? list)
     #f)
    ((eq? item (car list))
     list)
    (else (memq item (cdr list)))))

(define (memv item list)
  (cond
    ((null? list)
     #f)
    ((eqv? item (car list))
     list)
    (else (memv item (cdr list)))))

(define (member item list)
  (cond
    ((null? list)
     #f)
    ((equal? item (car list))
     list)
    (else (member item (cdr list)))))

(define (assq item list)
  (cond
    ((null? list)
     #f)
    ((eq? item (caar list))
     (car list))
    (else (assq item (cdr list)))))

(define (assv item list)
  (cond
    ((null? list)
     #f)
    ((eqv? item (caar list))
     (car list))
    (else (assv item (cdr list)))))

(define (assoc item list)
  (cond
    ((null? list)
     #f)
    ((equal? item (caar list))
     (car list))
    (else (assoc item (cdr list)))))

(define char? (make-type-predicate "java.lang.Character"))

(define char->integer (constructor "java.lang.Integer" "int"))

(define char-upcase (method "java.lang.Character" "toUpperCase" "char"))
(define char-downcase (method "java.lang.Character" "toLowerCase" "char"))

(define (char=? a b) (= (char->integer a) (char->integer b)))
(define (char<? a b) (< (char->integer a) (char->integer b)))
(define (char>? a b) (> (char->integer a) (char->integer b)))
(define (char<=? a b) (<= (char->integer a) (char->integer b)))
(define (char>=? a b) (>= (char->integer a) (char->integer b)))

(define (char-ci=? a b) (char=? (char-downcase a) (char-downcase b)))
(define (char-ci<? a b) (char<? (char-downcase a) (char-downcase b)))
(define (char-ci>? a b) (char>? (char-downcase a) (char-downcase b)))
(define (char-ci<=? a b) (char<=? (char-downcase a) (char-downcase b)))
(define (char-ci>=? a b) (char>=? (char-downcase a) (char-downcase b)))

(define char-alphabetic? (method "java.lang.Character" "isLetter" "char"))
(define char-numeric? (method "java.lang.Character" "isDigit" "char"))
(define char-whitespace? (method "java.lang.Character" "isWhitespace" "char"))
(define char-upper-case? (method "java.lang.Character" "isUpperCase" "char"))
(define char-lower-case? (method "java.lang.Character" "isLowerCase" "char"))

(define vector? (make-type-predicate "[Ljava.lang.Object;"))

(define (make-vector k . opt-fill)
  (let ((fill (if (pair? opt-fill)
                (car opt-fill)
                (unspecified))))
    (list->vector (let loop ((idx 0))
                    (if (= idx k)
                      '()
                      (cons fill (loop (+ idx 1))))))))

(define procedure? (make-type-predicate "detroit.Procedure"))

(define for-each #f)

(let ((map-into (lambda (fun src dst)
                  (let loop ((src src) (dst dst))
                    (unless (null? src)
                      (set-car! dst (fun (car src)))
                      (loop (cdr src) (cdr dst))))
                  dst))

      (make-blank-copy (lambda (l)
                         (let loop ((l l) (acc '()))
                           (if (null? l)
                             acc
                             (loop (cdr l) (cons #f acc)))))))

  (set! map (lambda (fun . lists)
              (cond
                ((null? (cdr lists))
                 (map-into fun (car lists) (make-blank-copy (car lists))))
                (else
                  (let ((cars (make-blank-copy lists))
                        (results (make-blank-copy (car lists))))
                    (let loop ((remaining results))
                      (if (null? remaining)
                        results
                        (begin
                          (set-car! remaining (apply fun (map-into car lists cars)))
                          (map-into cdr lists lists)
                          (loop (cdr remaining))))))))))

  (set! for-each (lambda (fun . lists)
                   (cond
                     ((null? (cdr lists))
                      (let loop ((list (car lists)))
                        (if (null? list)
                          (if #f #f)
                          (begin (fun (car list))
                                 (loop (cdr list))))))
                     (else
                       (let ((cars (make-blank-copy lists)))
                         (let loop ()
                           (if (null? (car lists))
                             (if #f #f)
                             (begin
                               (apply fun (map-into car lists cars))
                               (map-into cdr lists lists)
                               (loop))))))))))


(define call/cc (raw (lambda (cont proc)
                       (proc cont (lambda (cont- res) (cont res))))))
(define call-with-current-continuation call/cc)

(define call-with-values
  (raw (lambda (cont generator consumer)
         (generator (lambda values
                      (apply cont consumer values))))))

(define dynamic-winds '())

(define dynamic-wind
  (lambda (before thunk after)
    (before)
    (set! dynamic-winds (cons (cons before after) dynamic-winds))
    (call-with-values
      thunk
      (lambda results
        (set! dynamic-winds (slot dynamic-winds 1))
        (after)
        (apply values results)))))

(define eval
  (raw (lambda (cont form env)
         (interpreter
           (lambda (i)
             (lookup-environment
               (lambda (l)
                 (full-eval identity i cont form l))
               env))))))

(define (call-with-input-file name proc)
  (let ((port (open-input-file name)))
    (try-catch-finally
      (lambda ()
        (proc port))
      #f
      (lambda ()
        (close-input-port port)))))

(define (parse-output-flag flag)
  (if (pair? flag)
    (car flag)
    #f))

(define (call-with-output-file name proc . flag)
  (let ((port (open-output-file name (parse-output-flag flag))))
    (try-catch-finally
      (lambda ()
        (proc port))
      #f
      (lambda ()
        (close-output-port port)))))

(define input-port? (make-type-predicate "java.io.BufferedReader"))
(define output-port? (make-type-predicate "java.io.Writer"))



(define new-buffered-reader (constructor "java.io.BufferedReader"
                                         "java.io.Reader"))
(define new-buffered-writer (constructor "java.io.BufferedWriter"
                                         "java.io.Writer"))

(define new-input-stream-reader (constructor "java.io.InputStreamReader"
                                             "java.io.InputStream"))

(define new-output-stream-writer (constructor "java.io.OutputStreamWriter"
                                              "java.io.OutputStream"))

(define current-input-port 
  (make-parameter (new-buffered-reader
                    ((constructor "java.io.InputStreamReader"
                                  "java.io.InputStream")
                     ((field "java.lang.System" "in"))))))

(define current-output-port
  (make-parameter (new-buffered-writer
                    ((constructor "java.io.OutputStreamWriter"
                                  "java.io.OutputStream")
                     ((field "java.lang.System" "out"))))))

(define current-error-port
  (make-parameter (new-buffered-writer
                    ((constructor "java.io.OutputStreamWriter"
                                  "java.io.OutputStream")
                     ((field "java.lang.System" "err"))))))

(define (with-input-from-file name thunk)
  (let ((orig (current-input-port))
        (port (open-input-file name)))
    (try-catch-finally
      (lambda ()
        (current-input-port port)
        (thunk))
      #f
      (lambda ()
        (current-input-port orig)
        (close-input-port port)))))

(define (with-output-to-file name thunk . flag)
  (let ((orig (current-output-port))
        (port (open-output-file name (parse-output-flag flag))))
    (try-catch-finally
      (lambda ()
        (current-output-port port)
        (thunk))
      #f
      (lambda ()
        (current-output-port orig)
        (close-output-port port)))))


(define (open-input-file name)
  (new-buffered-reader
    ((constructor "java.io.FileReader" "java.lang.String") name)))

(define (open-output-file name . flag)
  (new-buffered-writer
    ((constructor
       "java.io.FileWriter"
       "java.lang.String"
       "boolean")
     name
     (parse-output-flag flag))))

(define close-input-port (method "java.io.Reader" "close"))
(define close-output-port (method "java.io.Writer" "close"))

(define eof-object
  (let ((eof (jstring "#<eof>")))
    (lambda ()
      eof)))

(define read
  (let ((new-reader (constructor "detroit.Reader" "java.io.BufferedReader"))
        (read (method "detroit.Reader" "read")))
    (lambda opt-input-port
      (try-catch-finally
        (lambda ()
          (read (new-reader (if (pair? opt-input-port)
                              (car opt-input-port)
                              (current-input-port)))))
        (lambda (e)
          (eof-object))
        #f))))

(define read-char
  (let ((read (method "java.io.Reader" "read")))
    (lambda opt-input-port
      (let ((result (read (if (pair? opt-input-port)
                            (car opt-input-port)
                            (current-input-port)))))
        (if (= result -1)
          (eof-object)
          (integer->char result))))))

(define peek-char
  (let ((read (method "java.io.Reader" "read"))
        (mark (method "java.io.Reader" "mark" "int"))
        (reset (method "java.io.Reader" "reset")))
    (lambda opt-input-port
      (let ((input-port (if (pair? opt-input-port)
                          (car opt-input-port)
                          (current-input-port)))
            (result #f))
        (mark input-port 1)
        (set! result (read input-port))
        (reset input-port)
        (if (= result -1)
          (eof-object)
          (integer->char result))))))

(define (eof-object? x)
  (eq? x (eof-object)))

(define char-ready?
  (let ((ready (method "java.io.Reader" "ready")))
    (lambda opt-input-port
      (ready (if (pair? opt-input-port)
               (car opt-input-port)
               (current-input-port))))))

(define write-char
  (let ((write (method "java.io.Writer" "write" "int")))
    (lambda (char . opt-output-port)
      (write (if (pair? opt-output-port)
               (car opt-output-port)
               (current-output-port))
             char)
      (unspecified))))

(define write-string
  (let ((write (method "java.io.Writer" "write" "[C")))
    (lambda (string . opt-output-port)
      (write (if (pair? opt-output-port)
               (car opt-output-port)
               (current-output-port))
             string)
      (unspecified))))

(define flush-output
  (let ((flush (method "java.io.Writer" "flush")))
    (lambda opt-output-port
      (flush (if (pair? opt-output-port)
               (car opt-output-port)
               (current-output-port)))
      (unspecified))))

(define (newline . opt-output-port)
  (let ((output-port (if (pair? opt-output-port)
                       (car opt-output-port)
                       (current-output-port))))
    (write-char #\newline output-port)
    (flush-output output-port)))

(define write #f)
(define display #f)
(define write-with-shared-structure #f)
(define write/ss #f)

(letrec ((to-string (method "java.lang.Object" "toString"))
         (output (lambda (form readable? seen-list out)
                   (let ((cyclic (assq form seen-list)))
                     (when cyclic
                       (write-char #\# out)
                       (output (caddr cyclic) #t '() out))
                     (cond
                       ((and cyclic
                             (cadr cyclic))
                        (write-char #\# out))
                       ((null? form)
                        (write-string "()" out))
                       ((eq? form #t)
                        (write-string "#t" out))
                       ((eq? form #f)
                        (write-string "#f" out))
                       ((char? form)
                        (cond
                          ((and readable?
                                (char=? form #\space))
                           (write-string "#\\space" out))
                          ((and readable?
                                (char=? form #\newline))
                           (write-string "#\\newline" out))
                          (readable?
                            (write-string "#\\" out)
                            (write-char form out))
                          (else
                            (write-char form out))))
                       ((number? form)
                        (write-string (number->string form) out))
                       ((symbol? form)
                        (write-string (symbol->string form) out))
                       ((string? form)
                        (cond
                          (readable?
                            (write-char #\" out)
                            (let ((len (string-length form))
                                  (c #f))
                              (let loop ((idx 0))
                                (unless (eqv? idx len)
                                  (set! c (string-ref form idx))
                                  (if (or (char=? c #\\ ) (char=? c #\"))
                                    (write-char #\\ out))
                                  (write-char c out)
                                  (loop (+ idx 1)))))
                            (write-char #\" out))
                          (else
                            (write-string form out))))
                       ((pair? form)
                        (write-char #\( out)
                        (output (car form) readable? seen-list out)
                        (let loop ((form (cdr form)))
                          (cond
                            ((pair? form)
                             (write-char #\space out)
                             (output (car form) readable? seen-list out)
                             (loop (cdr form)))
                            ((null? form)
                             (write-char #\) out))
                            (else
                              (write-string " . " out)
                              (output form readable? seen-list out)
                              (loop '())))))
                       ((vector? form)
                        (write-char #\# out)
                        (output (vector->list form) readable? seen-list out))
                       (else
                         (write-string "#<unknown " out)
                         (write-string (symbol->string (to-string form)) out)
                         (write-string ">" out)))))))

  (set! write
    (lambda (form . opt-output-port)
      (output form #t '() (if (pair? opt-output-port)
                            (car opt-output-port)
                            (current-output-port)))))

  (set! display
    (lambda (form . opt-output-port)
      (output form #f '() 
              (if (pair? opt-output-port)
                (car opt-output-port)
                (current-output-port)))
      (flush-output
        (if (pair? opt-output-port)
          (car opt-output-port)
          (current-output-port))))))

(define new-string-reader (constructor "java.io.StringReader"
                                       "java.lang.String"))

(define (open-input-string str)
  (new-buffered-reader (new-string-reader str)))

(define (get-output-string os)
  ((method "java.io.StringWriter" "flush") os)
  (let ((rs ((method "java.io.StringWriter" "toString") os)))
    ((method "java.io.StringWriter" "close") os)
    rs))

(define (open-output-string)
  ((constructor "java.io.StringWriter")))

(define (with-input-from-string s)
  (read (open-input-string s)))

(define (with-output-to-string f)
  (let ((os (open-output-string))) 
    (write f os)
    (get-output-string os)))

(define (make-thread thunk)
  ((constructor "detroit.NativeThread" "detroit.Interpreter" "java.lang.Object") (interpreter) thunk))

(define (thread-terminate! t)
  ((method "java.lang.Thread" "interrupt") t))

(define (thread-start! t)
  ((method "java.lang.Thread" "start") t)
  t)

(define (thread-yield! t)
  ((method "java.lang.Thread" "yield") t))

(define (thread-join! t . timeout)
  (if (pair? timeout)
    ((method "java.lang.Thread" "join" "long") t (car timeout))
    ((method "java.lang.Thread" "join") t)))

(define (thread-sleep! t . timeout)
  (if (pair? timeout)
    ((method "java.lang.Thread" "sleep" "long") t (car timeout))
    ((method "java.lang.Thread" "sleep") t)))

(define new-io-print-stream (constructor "java.io.PrintStream" "java.io.OutputStream"))
(define (buffered-reader-read-char i) ((method "java.io.BufferedReader" "read") i))
(define (buffered-reader-read i len)
  (letrec 
    ((read-loop
       (lambda (i c where)
         (cond ((= where 0) 
                (list->string 
                  (reverse c)))
               (else (read-loop i (cons (integer->char (buffered-reader-read-char i)) c) (- where 1)))))))
    (read-loop i '() len)))

(define (buffered-reader-readline i) ((method "java.io.BufferedReader" "readLine") i))
(define (buffered-reader-close o) ((method "java.io.BufferedReader" "close") o))
(define (print-stream-println o s) ((method "java.io.PrintStream" "println" "java.lang.String") o s))
(define (print-stream-flush o) ((method "java.io.PrintStream" "flush") o))
(define (print-stream-close o) ((method "java.io.PrintStream" "close") o))
(define new-java-io-printwriter (constructor "java.io.PrintWriter" "java.io.OutputStream"))
(define (print-writer-print w s) ((method "java.io.PrintWriter" "println" "java.lang.String") w s))
(define (print-writer-close w) ((method "java.io.PrintWriter" "close") w))
(define (print-writer-flush w) ((method "java.io.PrintWriter" "flush") w))

(define load
  (let ((load-from-jar (method "detroit.Interpreter" "loadFromJar" "java.lang.String" "detroit.Environment")))
    (lambda (filename)
      (load-from-jar (interpreter) filename (current-environment)))))

(set! debug
  (lambda (x)
    (write x)(newline)
    x))

(define load-jar (method "detroit.Interpreter" "loadJar" "java.lang.String"))

(define get-environment-variable (method "java.lang.System" "getenv" "java.lang.String"))
(define get-environment-variables (method "java.lang.System" "getenv"))



(define jfloat (constructor "java.lang.Float" "double"))
(define jbyte (constructor "java.lang.Byte" "byte"))

(define new-exception (constructor "java.lang.Exception" "java.lang.String"))
(define (error string . rest)
  (let ((port ((constructor "java.io.StringWriter"))))
    (display string port)
    (for-each (lambda (item)
                (display " " port)
                (write item port))
              rest)
    (newline port)
    (throw (new-exception ((method "java.lang.Object" "toString") port)))))

(define argv '())

(define bitwise (eval 'bitwise 'r5rs))

(define (fixnum-not fx)
  (bitwise #\~ fx))

(define (fixnum-and fx1 fx2)
  (bitwise #\& fx1 fx2))

(define (fixnum-ior fx1 fx2)
  (bitwise #\| fx1 fx2))

(define (fixnum-xor fx1 fx2)
  (bitwise #\^ fx1 fx2))

(define bitwise-not fixnum-not)
(define bitwise-and fixnum-and)
(define bitwise-or fixnum-ior)
(define bitwise-xor fixnum-xor)

(define new-buffered-reader (constructor "java.io.BufferedReader"
                                         "java.io.Reader"))
(define new-string-reader (constructor "java.io.StringReader"
                                       "java.lang.String"))

(define (open-string-input-port str)
  (new-buffered-reader (new-string-reader str)))

(define (hash-table-ref ht key)
  (native-hash-table-ref ht (with-output-to-string key)))

(define (hash-table-ref/default ht key . opt-default)
  (native-hash-table-ref/default ht (with-output-to-string key) opt-default))

(define (hash-table-set! ht key val)
  (native-hash-table-set! ht (with-output-to-string key) val))

(define (hash-table-exists? ht key)
  (native-hash-table-exists? ht (with-output-to-string key)))

(define (hash-table-delete! ht key)
  (native-hash-table-delete! ht (with-output-to-string key)))

(define (hash-table-for-each ht proc)
  (native-hash-table-for-each
    ht
    (lambda (k v)
      (proc (with-input-from-string k) v))))

(define (hash-table-map ht proc)
  (native-hash-table-map
    ht
    (lambda (k v)
      (proc (with-input-from-string k) v))))

(define (hash-table-keys ht)
  (map
    (lambda (k)
      (with-input-from-string k))
    (native-hash-table-keys ht)))

(define hash-table-values native-hash-table-values)

(define (check-arg pred val caller)
  (if (not (pred val))
    (error val caller))
  val)

(define (char-cased? c)
  (or (char-lower-case? c)
      (char-upper-case? c)
      (char-title-case? c)))

(define java:exit (method "java.lang.System" "exit" "int"))
(define (exit) (java:exit 0))
(define quit exit)
(define (sleep s) ((method "java.lang.Thread" "sleep" "long") (* 1000 s)))

;; file utilities

; create a new file object
(define (file:new name)
  ((constructor "java.io.File" "java.lang.String") name))

; check if the path exists
(define (file:exist? path)
  ((method "java.io.File" "exists")
   (file:new path)))

;; require syntax

; make a require path
(define (make-require-path lib)
  (string-append "detroit/lib/" lib ".scm"))

; require
(define (require lib)
  (try-catch-finally
    (lambda ()
      (load (make-require-path (symbol->string lib))) #t)
    (lambda ()
      (load (string-append (symbol->string lib) ".scm")) #t)
    #f))

; alias for require
(define use require)

; load an srfi by number
(define (srfi num)
  (load (make-require-path (number->string num))) #t)

; load a package by name
(define (include name)
  (let* ((jar-file (string-append (symbol->string name) ".jar"))
         (jar-file-installed (conc "/usr/local/lib/detroit/" jar-file)))
    (cond ((file:exist? jar-file) (load-jar jar-file))
          ((file:exist? jar-file-installed) (load-jar jar-file-installed))
          (else #f))))

; split string at character
(define (string-split str ch)
  (let ((len (string-length str)))
    (letrec
      ((split
         (lambda (a b)
           (cond
             ((>= b len) (if (= a b) '() (cons (substring str a b) '())))
             ((char=? ch (string-ref str b)) (if (= a b)
                                               (split (+ 1 a) (+ 1 b))
                                               (cons (substring str a b) (split b b))))
             (else (split a (+ 1 b)))))))
      (split 0 0))))

