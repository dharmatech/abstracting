
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

;; Compatibility with R6RS bytevectors

(use srfi-4)

(define (make-bytevector n)
  (u8vector->blob/shared (make-u8vector n)))

(define bytevector-length blob-size)

(define (bytevector-s32-native-ref bv i)
  (s32vector-ref (blob->s32vector/shared bv) (/ i 4)))

(define (bytevector-ieee-double-native-ref bv i)
  (f64vector-ref (blob->f64vector/shared bv) (/ i 8)))

(define (bytevector-ieee-double-native-set! bv i val)
  (f64vector-set! (blob->f64vector/shared bv) (/ i 8) val))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Compatability with R6RS hashtables

(define (make-eq-hashtable) (make-hash-table eq?))

(define hashtable-size hash-table-size)

(define hashtable-ref  hash-table-ref/default)

(define hashtable-set! hash-table-set!)

(define hashtable-delete! hash-table-delete!)

(define hashtable-contains? hash-table-exists?)

(define hashtable-copy hash-table-copy)

;; (define hashtable-clear! ...)

(define hashtable-keys hash-table-keys)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (inc name)

  (let ((source-file ((-> loader 'lib-source-file) name)))

    `(include ,source-file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(chicken-scheme-load "src/boot/boot.scm")