
(import (core))

(define scheme-implementation 'ypsilon)

(define original-load load)

(define (load file)
  (if (file-exists? file)
      (original-load file)
      (original-load (string-append file ".scm"))))

(load "src/boot/boot.scm")