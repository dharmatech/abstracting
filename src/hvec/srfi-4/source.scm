
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (s32-vec-obj hv)

  (let ((len (lambda (     ) (s32vector-length hv      )))
        (ref (lambda (i    ) (s32vector-ref    hv i    )))
        (set (lambda (i val) (s32vector-set!   hv i val)))

        (raw (lambda () hv))

        (ffi (lambda () (s32vector-ffi hv))))

    (let ((message-handler

           (lambda (msg)

             (case msg

               ((len) len)
               ((ref) ref)
               ((set) set)
               ((raw) raw)
               ((ffi) ffi)))))

      (vector 's32-vec hv message-handler))))

(define (s32-vec-of-len n) (make-s32vector n 0.0))

(define (s32-vec . elts) (s32-vec-obj (apply s32vector elts)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (u32-vec-obj hv)

  (let ((len (lambda (     ) (u32vector-length hv      )))
        (ref (lambda (i    ) (u32vector-ref    hv i    )))
        (set (lambda (i val) (u32vector-set!   hv i val)))

        (raw (lambda () hv))

        (ffi (lambda () (u32vector-ffi hv))))

    (let ((message-handler

           (lambda (msg)

             (case msg

               ((len) len)
               ((ref) ref)
               ((set) set)
               ((raw) raw)
               ((ffi) ffi)))))

      (vector 'u32-vec hv message-handler))))

(define (u32-vec-of-len n) (make-u32vector n 0.0))

(define (u32-vec . elts) (u32-vec-obj (apply u32vector elts)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (f32-vec-obj hv)

  (let ((len (lambda (     ) (f32vector-length hv      )))
        (ref (lambda (i    ) (f32vector-ref    hv i    )))
        (set (lambda (i val) (f32vector-set!   hv i val)))

        (raw (lambda () hv))

        (ffi (lambda () (f32vector-ffi hv))))

    (let ((message-handler

           (lambda (msg)

             (case msg

               ((len) len)
               ((ref) ref)
               ((set) set)
               ((raw) raw)
               ((ffi) ffi)))))

      (vector 'f32-vec hv message-handler))))

(define (f32-vec-of-len n) (f32-vec-obj (make-f32vector n 0.0)))

(define (f32-vec . elts) (f32-vec-obj (apply f32vector elts)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (f64-vec-obj hv)

  (let ((len (lambda (     ) (f64vector-length hv      )))
        (ref (lambda (i    ) (f64vector-ref    hv i    )))
        (set (lambda (i val) (f64vector-set!   hv i val)))

        (raw (lambda () hv))

        (ffi (lambda () (f64vector-ffi hv))))

    (let ((message-handler

           (lambda (msg)

             (case msg

               ((len) len)
               ((ref) ref)
               ((set) set)
               ((raw) raw)
               ((ffi) ffi)))))

      (vector 'f64-vec hv message-handler))))

;; (define (f64-vec-of-len n) (make-f64vector n 0.0))

(define (f64-vec-of-len n) (f64-vec-obj (make-f64vector n 0.0)))

(define (f64-vec . elts) (f64-vec-obj (apply f64vector elts)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

