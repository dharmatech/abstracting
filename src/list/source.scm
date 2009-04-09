
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (for-each-with-index proc lis)
  (let loop ((i 0) (lis lis))
    (if (not (null? lis))
        (begin
          (proc i (car lis))
          (loop (+ i 1) (cdr lis))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (for-each-with-fraction proc lis)
  (let ((n (length lis)))
    (for-each-with-index (lambda (i elt)
                           (proc (/ i n) elt))
                         lis)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (for-each-with-fraction* proc lis)
  (let ((n (length lis)))
    (for-each-with-index (lambda (i elt)
                           (proc (/ (+ i 1) n) elt))
                         lis)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (do-times n proc)
  (let loop ((i 0))
    (if (< i n)
        (begin
          (proc i)
          (loop (+ i 1))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

