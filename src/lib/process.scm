; Copyright (c) 2009, Raymond R. Medeiros. All rights reserved.

;; process utils

; execute a command string 
(define (process:exec cmd)
  ((method "java.lang.Runtime" "exec"  "java.lang.String")
   ((method "java.lang.Runtime" "getRuntime"))
   cmd))

; get the output stream for the process
(define (process:output-stream process)
  (new-buffered-reader
  (new-input-stream-reader 
    ((method "java.lang.Process" "getInputStream") process)
  )
  )
)

; read a line from the output stream for the process returns null when done
(define (process:readline output-stream)
  ((method "java.io.BufferedReader" "readLine") output-stream)
)

; wait for the process to end and return the code from the executed process
(define (process:wait process)
   ((method "java.lang.Process" "waitFor") process))

; get the return code from the executed process
(define (process:return process)
   ((method "java.lang.Process" "exitValue") process))

; kill a process by process handle
(define (process:kill process)
  ((method "java.lang.Process" "destroy") process))

