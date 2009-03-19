
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (circular-list-tabulate n procedure)
  (apply circular-list
         (list-tabulate n procedure)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (circular-list-each procedure cl)
  (procedure (car cl))
  (let ((start cl))
    (let loop ((cell (cdr cl)))
      (if (not (eq? cell start))
          (begin
            (procedure (car cell))
            (loop (cdr cell)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (circular-list-length cl)
  (let ((count 0))
    (circular-list-each (lambda (elt)
                              (set! count (+ count 1)))
                            cl)
    count))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (circular-list-each-index procedure cl)
  (let ((i 0))
    (circular-list-each (lambda (elt)
                              (procedure i elt)
                              (set! i (+ i 1)))
                            cl)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (circular-list-each-fraction procedure cl)

  (let ((fraction
         (let ((len (circular-list-length cl)))
           (lambda (i)
             (/ i len)))))

    (circular-list-each-index (lambda (i elt)
                                (procedure (fraction i) elt))
                              cl)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

