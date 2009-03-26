;; -*-scheme-*-

(define (object-message-handler obj)
  (vector-ref obj 2))

(define (-> obj msg) ((object-message-handler obj) msg))

(define (: obj msg . args) (apply (-> obj msg) args))

(define (obj? obj)
  (and (vector? obj)
       (= 3 (vector-length obj))
       (symbol? (vector-ref obj 0))
       (procedure? (vector-ref obj 2))))
