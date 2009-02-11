
(import

 (rnrs base)
 (rnrs io simple)
 (err5rs records syntactic)
 (err5rs load)
 (primitives current-directory do file-exists?)
        
 )

(define scheme-implementation 'larceny)

(load "src/boot/boot.scm")
