
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

      ;; (system (string-append "csc -dynamic " scheme-file))

      (let ((include-path-options (generate-include-path-options)))

        (system
         (string-append "csc -dynamic "
                        include-path-options
                        " -extend /scratch/_chicken-inc-macro-a.scm "
                        scheme-file)))

      ;; Alternate method:
      ;;   analyze file being compiled
      ;;   gather filenames referenced by load lines
      ;;   if file contains macros, include it
      
      ;; (system (string-append "csc -dynamic -run-time-macros " scheme-file))

      ;; (system
      ;;  (string-append
      ;;   "csc -dynamic -run-time-macros "
      ;;   "-extend /root/abstracting/src/boot/chicken/chicken.scm "
      ;;   scheme-file))

      ;; (system
      ;;  (string-append
      ;;   "csc -dynamic -run-time-macros "
      ;;   "-extend /root/abstracting/src/boot/chicken/chicken.scm "
      ;;   scheme-file))

      ;; (let ((include-dirs
      ;;        (apply string-append
      ;;               (map (lambda (path-string)
      ;;                      (string-append "-I " path-string " "))
      ;;                    (vector->list (-> (-> loader 'roots) 'raw))))))
        
        ;; (system (string-append "csc -dynamic -run-time-macros "
        ;;                        include-dirs
        ;;                        " "
        ;;                        scheme-file))
      
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

(use vector-lib)

;; (define srfi-43-vector-map vector-map)

;; (define vector-map
;;   (lambda (f . vectors)
;;     (apply srfi-43-vector-map (lambda (i . elts) (apply f elts)) vectors)))

;; (define srfi-43-vector-for-each vector-for-each)

;; (define vector-for-each
;;   (lambda (f . vectors)
;;     (apply srfi-43-vector-for-each (lambda (i . elts) (apply f elts)) vectors)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define-macro (lib-source name)
;;   ((-> loader 'lib-source-file) name))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(chicken-scheme-load "src/boot/boot.scm")