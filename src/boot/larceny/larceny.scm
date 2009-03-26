
(import (srfi :1))
(import (srfi :13))

(import (primitives compile-file))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import

 (for (rnrs base) run expand)

 (for (rnrs syntax-case) run expand)

 (for (rnrs bytevectors) run expand)

 (for (rnrs control) run expand)

 (rnrs io simple)
 (err5rs records syntactic)
 (err5rs load)
 (primitives current-directory file-exists? time)
 
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (define-syntax define-macro
;;    (lambda (x)
;;      (syntax-case x ()
;;        ((_ (name . args) . body)
;;         (syntax (define-macro name (lambda args . body))))
;;        ((_ name transformer)
;;         (syntax
;;          (define-syntax name
;;            (lambda (y)
;;              (syntax-case y ()
;;                 ((_ . args)
;;                  (datum->syntax
;;                   (syntax _)
;;                   (apply transformer
;;                          (syntax->datum (syntax args)))))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-syntax define-macro
   (lambda (x)
     (syntax-case x ()
       ((define-macro (name . args) . body)
        (syntax (define-macro name (lambda args . body))))
       ((define-macro name transformer)
        (syntax
         (define-syntax name
           (lambda (y)
             (syntax-case y ()
                ((define-macro . args)
                 (datum->syntax
                  (syntax define-macro)
                  (apply transformer
                         (syntax->datum (syntax args)))))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define exact->inexact inexact)

(define inexact->exact exact)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define scheme-implementation 'larceny)

(import (primitives load))

(define scheme-load-source-file load)

(define scheme-compile-file compile-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (import (err5rs load))

(load "src/boot/boot.scm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(import (primitives r5rs:require run-with-profiling

                    reset-profiler!
                    start-profiler!
                    stop-profiler!
                    report-profiler!

                    ))

(r5rs:require 'profile)

(define (run-with-profiling* thunk)
  (define val #f)
  (if (not (procedure? thunk))
      (assertion-violation 'run-with-profiling
                           "argument should be thunk"
                           thunk))
  (reset-profiler!)
  (start-profiler!)
  (set! val (thunk))
  (stop-profiler!)
  (report-profiler!)

  val)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (profile expr)
  `(run-with-profiling* (lambda () ,expr)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (inc name)
  ((-> loader 'lib) name))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import (rnrs hashtables)
        (rnrs arithmetic bitwise))

(import (primitives eval interaction-environment system))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(print "Abstracting is loaded\n")