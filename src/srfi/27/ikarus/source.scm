
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import (ikarus foreign))

(define srandom
  ((make-c-callout 'void '(unsigned-long)) (dlsym (dlopen) "srandom")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define default-random-source #t)

(define (random-source-randomize! source)
  (srandom (time-second (current-time))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define random-integer random)

(define (random-real)
  (/ (random-integer 1000000)
     1000000.0))