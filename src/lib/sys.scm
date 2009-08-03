; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; system utilities 

; operating system name
(define (sys:os:name)
  (java:get-property-string "os.name"))

; operating system version
(define (sys:os:version)
  (java:get-property-string "os.version"))

; operating system architecture
(define (sys:hardware:arch)
  (java:get-property-string "os.arch"))

; machine endianness
(define (sys:hardware:endian)
  (java:get-property-string "sun.cpu.endian"))

; jvm encoding
(define (sys:encoding:default)
  (java:get-property-string "sun.jnu.encoding"))

; file encoding
(define (sys:encoding:file)
  (java:get-property-string "file.encoding"))

; user home directory
(define (sys:user:home)
  (java:get-property-string "user.home"))

; start directory 
(define (sys:user:start)
  (java:get-property-string "user.dir")) 

; username
(define (sys:user:name)
  (java:get-property-string "user.name"))

; langauge
(define (sys:language)
  (java:get-property-string "user.language"))

; timezone
(define (sys:timezone)
  (java:get-property-string "user.timezone"))

; country
(define (sys:country)
  (java:get-property-string "user.country"))

; path seperator token
(define (sys:path-seperator)
  (java:get-property-string "path.seperator"))

; line seperator token
(define (sys:line-seperator)
  (java:get-property-string "line.seperator"))

; all operating system related values as a string
(define (sys:version)
  (string-append (sys:os:name) " v" (sys:os:version) " (" (sys:hardware:arch) ")"))

