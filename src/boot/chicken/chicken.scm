
(define scheme-implementation 'chicken)

(use posix)

(define mod modulo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define inexact exact->inexact)
(define exact   inexact->exact)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define loader #f)

(define (generate-include-path-options)

  (if loader
  
      (apply string-append
             (vector->list
              (-> ((-> (-> loader 'roots) 'map)
                   (lambda (dir)
                     (string-append " -include-path " dir " ")))
                  'raw)))

      " "))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use files)
(use posix)

(define chicken-scheme-load load)

(define (file-newer? a b)
  (> (file-change-time a)
     (file-change-time b)))

(define (load scheme-file)

  (let ((so-file (pathname-replace-extension scheme-file "so")))

    (cond

     ((and (file-exists? so-file)
           (file-newer? so-file scheme-file))
      (chicken-scheme-load so-file))

     (else
      (display "Compiling file: ") (display scheme-file) (newline)

      (let ((include-path-options (generate-include-path-options)))

        (system
         (string-append "csc -dynamic "
                        include-path-options
                        " -extend "
                        (string-append abstracting-root-directory
                                       "/src/boot/chicken/inc/inc.scm")
                        " "
                        scheme-file)))

        (load scheme-file)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use srfi-4)

(define (make-bytevector n)
  (u8vector->blob/shared (make-u8vector n)))

(define bytevector-length blob-size)

(define (bytevector-ieee-double-native-ref bv i)
  (f64vector-ref (blob->f64vector/shared bv) (/ i 8)))

(define (bytevector-ieee-double-native-set! bv i val)
  (f64vector-set! (blob->f64vector/shared bv) (/ i 8) val))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (inc name)

  (let ((source-file ((-> loader 'lib-source-file) name)))

    `(include ,source-file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(chicken-scheme-load "src/boot/boot.scm")