
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (load "~~/Gambit-C/lib/syntax-case.scm")

(load "support/gambit/srfi-1/srfi-1")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define scheme-implementation 'gambit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define abstracting-root-directory (current-directory))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *roots* #f)

(define *loaded* '())

(define *included* '())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (directory-contains file)
  (lambda (dir)
    (file-exists?
     (string-append dir "/" file))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (resolve lib)
  (let ((root (find (directory-contains lib) *roots*)))
    (if root (string-append root "/" lib) #f)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define (snarf dir)

;;   (let ((dir (resolve dir)))

;;     (let ((import-file    (string-append dir "/import"))
;;           (include-file   (string-append dir "/include"))
;;           (source-file    (string-append dir "/source"))
;;           (export-file    (string-append dir "/export"))
;;           (compiled-file  (string-append dir "/compiled-gambit")))

;;       (for-each (lambda (lib) (snarf (resolve lib)))
;;                 (read (open-input-file import-file)))

;;       (if (file-exists? compiled-file)
;;           (scheme-load-compiled-file compiled-file)
;;           (scheme-load-source-file source-file))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (load-include dir)

  (let ((file (string-append (resolve dir) "/" "source.scm")))

    (eval `(include ,file))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (require-include dir)
  (cond ((not (member dir *included*))
         (print "Including " dir "\n")
         (load-include dir)
         (set! *included* (cons dir *included*)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (load-source dir)

  (let ((dir (resolve dir)))

    (let ((import-file  (string-append dir "/import"))
          (include-file (string-append dir "/include"))
          (source-file  (string-append dir "/source.scm")))

      (if (file-exists? import-file)
          
          (let ((import-list (call-with-input-file import-file read)))

            (for-each load-source import-list)))

      (if (file-exists? include-file)

          (let ((include-list (call-with-input-file include-file read)))

            (for-each require-include include-list)))

      (print "Loading " source-file "\n")

      (load source-file))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (require-source dir)
  (cond ((not (member dir *loaded*))
         (load-source dir)
         (set! *loaded* (cons dir *loaded*)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (compile-lib dir)

  (print "Compiling " dir "\n")

  (let ((dir (resolve dir)))

    (let ((compiled-file (string-append dir "/source.o1")))
      (if (file-exists? compiled-file)
          (delete-file compiled-file)))

    (let ((include-file (string-append dir "/include")))
      (if (file-exists? include-file)
          (let ((include-list (call-with-input-file include-file read)))
            (for-each require-include include-list))))

    (let ((source-file (string-append dir "/source.scm")))
      (compile-file source-file))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (load-lib dir)

  (let ((dir (resolve dir)))

    (let ((import-file (string-append dir "/import")))

      (if (file-exists? import-file)
        
          (let ((import-list (call-with-input-file import-file read)))

            (for-each require-lib import-list))))

    (load (string-append dir "/source"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (file-newer? a b)
  (> (time->seconds (file-info-last-modification-time (file-info a)))
     (time->seconds (file-info-last-modification-time (file-info b)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (freshen-lib lib)
  (let ((dir (resolve lib)))
    (let ((source-file   (string-append dir "/source.scm"))
          (compiled-file (string-append dir "/source.o1")))
      (if (or (not (file-exists? compiled-file))
              (not (file-newer? compiled-file source-file)))
          (compile-lib lib)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (require-lib dir)
  (cond ((not (member dir *loaded*))
         (print "Loading lib " dir "\n")
         (freshen-lib dir)
         (load-lib dir)
         (set! *loaded* (cons dir *loaded*)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "src/boot/boot.scm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define inexact exact->inexact)
(define exact   inexact->exact)

(define (mod a b)
  (modulo
   (exact (round a))
   (exact (round b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (current-time-in-nanoseconds)
  (exact (* (time->seconds (current-time))
            1000000000)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-syntax case-lambda
  (syntax-rules ()
    ((case-lambda 
      (?a1 ?e1 ...) 
      ?clause1 ...)
     (lambda args
       (let ((l (length args)))
         (case-lambda "CLAUSE" args l 
                      (?a1 ?e1 ...)
                      ?clause1 ...))))
    ((case-lambda "CLAUSE" ?args ?l 
                  ((?a1 ...) ?e1 ...) 
                  ?clause1 ...)
     (if (= ?l (length '(?a1 ...)))
         (apply (lambda (?a1 ...) ?e1 ...) ?args)
         (case-lambda "CLAUSE" ?args ?l 
                      ?clause1 ...)))
    ((case-lambda "CLAUSE" ?args ?l
                  ((?a1 . ?ar) ?e1 ...) 
                  ?clause1 ...)
     (case-lambda "IMPROPER" ?args ?l 1 (?a1 . ?ar) (?ar ?e1 ...) 
                  ?clause1 ...))
    ((case-lambda "CLAUSE" ?args ?l 
                  (?a1 ?e1 ...)
                  ?clause1 ...)
     (let ((?a1 ?args))
       ?e1 ...))
    ((case-lambda "CLAUSE" ?args ?l)
     (error "Wrong number of arguments to CASE-LAMBDA."))
    ((case-lambda "IMPROPER" ?args ?l ?k ?al ((?a1 . ?ar) ?e1 ...)
                  ?clause1 ...)
     (case-lambda "IMPROPER" ?args ?l (+ ?k 1) ?al (?ar ?e1 ...) 
                  ?clause1 ...))
    ((case-lambda "IMPROPER" ?args ?l ?k ?al (?ar ?e1 ...) 
                  ?clause1 ...)
     (if (>= ?l ?k)
         (apply (lambda ?al ?e1 ...) ?args)
         (case-lambda "CLAUSE" ?args ?l 
                      ?clause1 ...)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(print "Abstracting is loaded\n")