
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use srfi-1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define scheme-implementation 'chicken)

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

;; (define (compile-lib dir)

;;   (let ((dir (resolve dir)))

;;     (let ((include-file (string-append dir "/include")))

;;       (if (file-exists? include-file)

;;           (let ((include-list (call-with-input-file include-file read)))

;;             (for-each require-include include-list))))

;;     (let ((source-file   (string-append dir "/source"))
;;           (compiled-file (string-append dir "/compiled-gambit.o1")))

;;       (compile-file source-file output: compiled-file))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define (compile-lib dir)

;;   (let ((dir (resolve dir)))

;;     (let ((include-file (string-append dir "/include")))

;;       (if (file-exists? include-file)

;;           (let ((include-list (call-with-input-file include-file read)))

;;             (for-each require-include include-list))))

;;     (let ((source-file (string-append dir "/source.scm")))

;;       (compile-file source-file))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (compile-lib dir)

  (print "Compiling lib " dir)

  (let ((dir (resolve dir)))

    (let ((prologue

           (let ((include-file (string-append dir "/include")))

             (if (file-exists? include-file)

                 (let ((include-list (call-with-input-file include-file read)))

                   (apply string-append
                          (map (lambda (lib)
                                 (string-append "-prologue "
                                                (resolve lib)
                                                "/source.scm"
                                                ))
                               include-list)))

                 ""))))

      (let ((source-file (string-append dir "/source.scm")))
        
        (system (string-append "csc " source-file
                               " -R syntax-case "
                               " -dynamic "
                               prologue))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (load-lib dir)

  (let ((dir (resolve dir)))

    (let ((import-file (string-append dir "/import")))

      (if (file-exists? import-file)
        
          (let ((import-list (call-with-input-file import-file read)))

            (for-each require-lib import-list))))

    (load (string-append dir "/source"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use posix)

(define (file-newer? a b)
  (> (file-change-time a)
     (file-change-time b)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (freshen-lib lib)
  (let ((dir (resolve lib)))
    (let ((source-file   (string-append dir "/source.scm"))
          (compiled-file (string-append dir "/source.so")))
      (if (or (not (file-exists? compiled-file))
              (not (file-newer? compiled-file source-file)))
          (compile-lib lib)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (require-lib dir)
  (cond ((not (member dir *loaded*))
         (print "Loading lib " dir)
         (freshen-lib dir)
         (load-lib dir)
         (set! *loaded* (cons dir *loaded*)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use syntax-case)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "src/boot/boot.scm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define inexact exact->inexact)
(define exact   inexact->exact)

(define mod modulo)

;; (define fl+ fp+)
;; (define fl- fp-)
;; (define fl* fp*)
;; (define fl/ fp/)

(define fl+ +)
(define fl- -)
(define fl* *)
(define fl/ /)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use srfi-4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(print "Abstracting is loaded")