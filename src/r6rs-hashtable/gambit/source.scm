
(define (make-eq-hashtable) (make-table test: eq?))

(define (make-hashtable hash-function equiv)
  (make-table hash: hash-function
              test: equiv))

(define hashtable-size table-length)

(define hashtable-ref  table-ref)

(define hashtable-set! table-set!)

(define (hashtable-delete! tbl key) (table-set! tbl key))

(define (hashtable-contains? tbl key)
  (not (eq? (table-ref tbl key 'not-found)
            'not-found)))
  
(define hashtable-copy table-copy)

(define (hashtable-clear! tbl)
  (table-for-each (lambda (key val)
                    (table-set! tbl key))
                  tbl))

(define (hashtable-keys tbl)
  (map car (table->list tbl)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define equal-hash equal?-hash)