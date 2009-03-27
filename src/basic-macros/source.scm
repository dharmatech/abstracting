
;; (define-macro (when test . body)
;;   `(if ,test (begin ,@body)))

;; (define-macro (push! list elt)
;;   `(set! ,list (cons ,elt ,list)))

(define-syntax when
  (syntax-rules ()
    ((when test expr ...)
     (if test
         (begin
           expr
           ...)))))

(define-syntax push!
  (syntax-rules ()
    ((push! list elt)
     (set! list (cons elt list)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-syntax list-push!
  (syntax-rules ()
    ((list-push! list elt)
     (set! list (cons elt list)))))

(define-syntax list-pop!
  (syntax-rules ()
    ((list-pop! list)
     (let ((elt (car list)))
       (set! list (cdr list))
       elt))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


