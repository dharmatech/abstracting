
(define scheme-implementation 'ikarus)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (print . elts)
  (for-each display elts))

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

(define null-list? null?)

(define (reduce f ridentity lis)
  (if (null-list? lis) ridentity
      (fold-left f (car lis) (cdr lis))))

(define (list-tabulate len proc)
  (do ((i (- len 1) (- i 1))
       (ans '() (cons (proc i) ans)))
      ((< i 0) ans)))

(define (circular-list val1 . vals)
  (let ((ans (cons val1 vals)))
    (set-cdr! (last-pair ans) ans)
    ans))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define (equal-hash x) 0)

;; (define (equal-hash x)
;;   (string-hash (with-output-to-string (lambda () (write x)))))

(define (equal-hash x)
  (abs
   (string-hash
    (with-output-to-string (lambda () (write x))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(print "Abstracting is loaded\n")