
(import (rnrs records syntactic))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (srfi-4-functor size _make unbox ref set)

  (define (tag-length hv)
    (/ (bytevector-length (unbox hv)) size))

  (define (tag-ref hv i)
    (ref (unbox hv) (* i size)))

  (define (tag-set! hv i val)
    (set (unbox hv) (* i size) val))

  (define (tag-map! proc hv)
    (let ((n (tag-length hv)))
      (do ((i 0 (+ i 1)))
          ((= i n))
        (tag-set! hv i (proc (tag-ref hv i)))))
    hv)

  (define (make-tag n . init)
    (let ((v (_make (make-bytevector (* n size)))))
      (if (not (null? init)) (tag-map! (lambda (x) (car init)) v))
      v))

  (define (tag . args)
    (let ((v (make-tag (length args))))
      (let loop ((i 0) (args args))
        (cond ((null? args) v)
              (else
               (tag-set! v i (car args))
               (loop (+ i 1) (cdr args)))))))

  (define (tag->list hv)
    (let ((n (tag-length hv)))
      (let loop ((i 0))
        (if (= i n)
            '()
            (cons (tag-ref hv i)
                  (loop (+ i 1)))))))

  (define (list->tag list)
    (apply tag list))

  (list tag-length
        tag-ref
        tag-set!
        tag-map!
        make-tag
        tag
        tag->list
        list->tag)
  
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-syntax define-multi
  (syntax-rules ()

    ((define-multi (var) vals)
     (define var (car vals)))

    ((define-multi (var rest ...) vals)
     (begin
       (define var (car vals))
       (define-multi (rest ...) (cdr vals))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-record-type (s32vector _make-s32vector s32vector?) (fields data))

(define-multi (s32vector-length
               s32vector-ref
               s32vector-set!
               s32vector-map!
               make-s32vector
               s32vector
               s32vector->list
               list->s32vector)
  
  (srfi-4-functor 8 _make-s32vector s32vector-data
                  bytevector-s32-native-ref
                  bytevector-s32-native-set!))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-record-type (u32vector _make-u32vector u32vector?) (fields data))

(define-multi (u32vector-length
               u32vector-ref
               u32vector-set!
               u32vector-map!
               make-u32vector
               u32vector
               u32vector->list
               list->u32vector)
  
  (srfi-4-functor 8 _make-u32vector u32vector-data
                  bytevector-u32-native-ref
                  bytevector-u32-native-set!))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-record-type (f32vector _make-f32vector f32vector?) (fields data))

(define-multi (f32vector-length
               f32vector-ref
               f32vector-set!
               f32vector-map!
               make-f32vector
               f32vector
               f32vector->list
               list->f32vector)
  
  (srfi-4-functor 4 _make-f32vector f32vector-data
                  bytevector-ieee-single-native-ref
                  bytevector-ieee-single-native-set!))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-record-type (f64vector _make-f64vector f64vector?) (fields data))

(define-multi (f64vector-length
               f64vector-ref
               f64vector-set!
               f64vector-map!
               make-f64vector
               f64vector
               f64vector->list
               list->f64vector)
  
  (srfi-4-functor 8 _make-f64vector f64vector-data
                  bytevector-ieee-double-native-ref
                  bytevector-ieee-double-native-set!))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sorta kludgy. R6RSers don't have support for SRFI-4 in their FFI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (s32vector-ffi hv) (s32vector-data hv))
(define (u32vector-ffi hv) (u32vector-data hv))
(define (f32vector-ffi hv) (f32vector-data hv))
(define (f64vector-ffi hv) (f64vector-data hv))
