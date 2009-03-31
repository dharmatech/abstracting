
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-eq-hashtable) (make-hash-table eq?))

(define (make-hashtable hash-function equiv)

  (make-hash-table equiv hash-function))

(define hashtable-size hash-table-size)

(define hashtable-ref  hash-table-ref/default)

(define hashtable-set! hash-table-set!)

(define hashtable-delete! hash-table-delete!)

(define hashtable-contains? hash-table-exists?)

(define hashtable-copy hash-table-copy)

(define hashtable-keys hash-table-keys)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define equal-hash equal?-hash)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

