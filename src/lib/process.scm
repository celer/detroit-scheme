; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; process utils

; execute a command string 
(define (process:exec cmd)
  ((method "java.lang.Runtime" "exec"  "java.lang.String")
   ((method "java.lang.Runtime" "getRuntime"))
   cmd))

; kill a process by process handle
(define (process:kill process)
  ((method "java.lang.Process" "destroy") process))

