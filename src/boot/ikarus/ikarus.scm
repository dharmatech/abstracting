
(define scheme-implementation 'ikarus)

(load "src/boot/boot.scm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-syntax define-macro
   (lambda (x)
     (syntax-case x ()
       ((_ (name . args) . body)
        (syntax (define-macro name (lambda args . body))))
       ((_ name transformer)
        (syntax
         (define-syntax name
           (lambda (y)
             (syntax-case y ()
                ((_ . args)
                 (datum->syntax
                  (syntax _)
                  (apply transformer
                         (syntax->datum (syntax args)))))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

