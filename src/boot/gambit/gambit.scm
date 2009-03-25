
(load "support/gambit/srfi-1/srfi-1")
(load "support/gambit/srfi-13/srfi-13")

(define scheme-implementation 'gambit)

(define gambit-scheme-load load)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; smart-load
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (sort-list l <?)

  (define (mergesort l)

    (define (merge l1 l2)
      (cond ((null? l1) l2)
            ((null? l2) l1)
            (else
             (let ((e1 (car l1)) (e2 (car l2)))
               (if (<? e1 e2)
                 (cons e1 (merge (cdr l1) l2))
                 (cons e2 (merge l1 (cdr l2))))))))

    (define (split l)
      (if (or (null? l) (null? (cdr l)))
        l
        (cons (car l) (split (cddr l)))))

    (if (or (null? l) (null? (cdr l)))
      l
      (let* ((l1 (mergesort (split l)))
             (l2 (mergesort (split (cdr l)))))
        (merge l1 l2))))

  (mergesort l))

(define (file-newer? a b)
  (> (time->seconds (file-info-last-modification-time (file-info a)))
     (time->seconds (file-info-last-modification-time (file-info b)))))

(define (current-object-file scheme-file)
  (let ((object-file?
         (let ((object-file-prefix
                (string-append (path-strip-directory
                                (path-strip-extension scheme-file))
                               ".o")))
           (lambda (file)
             (string-prefix? object-file-prefix file)))))
    (let ((object-files
           (sort-list
            (filter object-file? (directory-files (path-directory scheme-file)))
            string>)))
      (if (null? object-files)
          #f
          (string-append (path-directory scheme-file)
                         (first object-files))))))

(define (next-object-file scheme-file)
  (let ((file-sans-extension (path-strip-extension scheme-file)))
    (let loop ((i 1))
      (let ((object-file
             (string-append file-sans-extension ".o" (number->string i))))
        (if (file-exists? object-file)
            (loop (+ i 1))
            object-file)))))

(define *gambit-loaded-files* '())

(define (smart-load scheme-file)

  (let ((object-file (current-object-file scheme-file)))

    (cond ((and object-file
                (file-newer? object-file scheme-file)
                (not (member object-file *gambit-loaded-files*)))
           (set! *gambit-loaded-files*
                 (cons object-file *gambit-loaded-files*))
           (gambit-scheme-load object-file))

          ((and object-file
                (file-newer? object-file scheme-file))
           'already-loaded)
                
          (else
           (print "Compiling file: " scheme-file "\n")
           (compile-file scheme-file)
           (smart-load scheme-file)))))

(define scheme-load-source-file smart-load)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define load smart-load)

(load "src/boot/boot.scm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector-map proc . vectors)

  (let ((n (apply min (map vector-length vectors))))

    (let ((u (make-vector n)))

      (do ((i 0 (+ i 1)))
          ((= i n))

        (vector-set! u i
                     (apply proc
                            (map (lambda (v)
                                   (vector-ref v i))
                                 vectors))))

      u)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (vector-for-each proc . vectors)

  (let ((n (apply min (map vector-length vectors))))

    (do ((i 0 (+ i 1)))
        ((= i n))

      (apply proc (map (lambda (v) (vector-ref v i)) vectors)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define inexact exact->inexact)
(define exact   inexact->exact)

(define mod modulo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(include "macros/macros.scm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(print "Abstracting is loaded\n")