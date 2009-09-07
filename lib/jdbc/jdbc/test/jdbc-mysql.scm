; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

(include mysql-connector-java-5.1.8-bin)
(use jdbc)

; create a test test:jdbc:handle
(define test:jdbc:handle
  (jdbc:make-jdbc
    "jdbc:mysql://localhost/test?user=root&password=t00r"
    "com.mysql.jdbc.Driver"))

; test query
(define (test:jdbc:query query)
  (jdbc:execute test:jdbc:handle query))

; setup the database for the test
(define (test:jdbc:setup)
  ; drop any existing table
  (test:jdbc:query "drop table if exists test;") 
  ; create the database
  (test:jdbc:query "create table test (id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, data TEXT, num double, timeEnter DATE);"))

; test insert
(define (test:jdbc:insert)
  ; insert 4 rows
  (test:jdbc:query "insert into test (data,num) values ('sample data', 1);")
  (test:jdbc:query "insert into test (data,num) values ('sample data', 2);")
  (test:jdbc:query "insert into test (data,num) values ('sample data', 3);")
  (test:jdbc:query "insert into test (data,num) values ('sample data', 4);")
  ; select the rows and check length and contents
  (let ((rows 
          (test:jdbc:query
            "select * from test;")))
    (check (length rows) => 4)
    (for-each
      (lambda (row)
        (hash-table-map
          row
          (lambda (k v)
            (cond ((equal? k 'data)
                   (check v => "sample data"))
                  ((equal? k 'num)
                   (check (number? v) => #t))))))
      rows)))

; test null
(define (test:jdbc:null)
  (test:jdbc:query "insert into test (data,num) values (NULL, 5);")
  (let ((row
          (car
            (test:jdbc:query
              "select * from test where id = 5;"))))
    (check (hash-table-ref row 'data) => '())))

; test update
(define (test:jdbc:update)
  ; update the first row and check it's contents
  (test:jdbc:query "update test set data = 'updated data' where id = 1;")
  (let ((row
          (car
            (test:jdbc:query
              "select * from test where id = 1;"))))
    (check (hash-table-ref row 'data) => "updated data")))

; test delete 
(define (test:jdbc:delete)
  ; delete a row
  (test:jdbc:query "delete from test where id = 1;")
  ; check the count
  (check (length (test:jdbc:query "select * from test;")) => 3))

; perform all jdbc tests
(define (test:jdbc)
  (test:jdbc:setup)
  (test:jdbc:insert)
  (test:jdbc:update)
  (test:jdbc:delete)
  (test:jdbc:null))

(test:jdbc)
(check-report)

