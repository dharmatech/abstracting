
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import (core))

(import (srfi :1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (print . elts)
  (for-each display elts))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define scheme-implementation 'ypsilon)

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

(define (load-lib lib)
  
  (let ((dir (resolve lib)))

    (let ((import-file (string-append dir "/import")))

      (if (file-exists? import-file)
        
          (let ((import-list (call-with-input-file import-file read)))

            (for-each require-lib import-list))))

    (let ((include-file (string-append dir "/include")))

      (if (file-exists? include-file)
        
          (let ((include-list (call-with-input-file include-file read)))

            (for-each require-lib include-list))))

    (load (string-append dir "/source.scm"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (require-lib dir)
  (cond ((not (member dir *loaded*))
         (print "Loading lib " dir "\n")
         (load-lib dir)
         (set! *loaded* (cons dir *loaded*)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "src/boot/boot.scm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import (time))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(print "Abstracting is loaded\n")