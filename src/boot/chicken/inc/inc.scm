
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (string-index-from-end-start-at string char i)
  
  (cond

   ((< i 0) #f)

   ((equal? (string-ref string i) char) i)

   (else
    (string-index-from-end-start-at string char (- i 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (string-index-from-end string char)
  (string-index-from-end-start-at string char (- (string-length string) 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (relative-lib-file name)
  (let ((lib-base-name
         (let ((i (string-index-from-end name #\/)))
           (if i
               (substring name (+ i 1) (string-length name))
               name))))
    (string-append name "/" lib-base-name ".scm")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (inc name)

  (let ((source-file (relative-lib-file name)))

    `(include ,source-file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

