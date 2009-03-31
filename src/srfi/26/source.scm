
(define-syntax srfi-26-internal-cut
  (syntax-rules (<> <...>)

    ;; construct fixed- or variable-arity procedure:
    ;;   (begin proc) throws an error if proc is not an <expression>
    ((srfi-26-internal-cut (slot-name ...) (proc arg ...))
     (lambda (slot-name ...) ((begin proc) arg ...)))
    ((srfi-26-internal-cut (slot-name ...) (proc arg ...) <...>)
     (lambda (slot-name ... . rest-slot) (apply proc arg ... rest-slot)))

    ;; process one slot-or-expr
    ((srfi-26-internal-cut (slot-name ...)   (position ...)      <>  . se)
     (srfi-26-internal-cut (slot-name ... x) (position ... x)        . se))
    ((srfi-26-internal-cut (slot-name ...)   (position ...)      nse . se)
     (srfi-26-internal-cut (slot-name ...)   (position ... nse)      . se))))

; (srfi-26-internal-cute slot-names nse-bindings combination . se)
;   transformer used internally
;     slot-names     : the internal names of the slots
;     nse-bindings   : let-style bindings for the non-slot expressions.
;     combination    : procedure being specialized, followed by its arguments
;     se             : slots-or-exprs, the qualifiers of the macro

(define-syntax srfi-26-internal-cute
  (syntax-rules (<> <...>)

    ;; If there are no slot-or-exprs to process, then:
    ;; construct a fixed-arity procedure,
    ((srfi-26-internal-cute
      (slot-name ...) nse-bindings (proc arg ...))
     (let nse-bindings (lambda (slot-name ...) (proc arg ...))))
    ;; or a variable-arity procedure
    ((srfi-26-internal-cute
      (slot-name ...) nse-bindings (proc arg ...) <...>)
     (let nse-bindings (lambda (slot-name ... . x) (apply proc arg ... x))))

    ;; otherwise, process one slot:
    ((srfi-26-internal-cute
      (slot-name ...)         nse-bindings  (position ...)   <>  . se)
     (srfi-26-internal-cute
      (slot-name ... x)       nse-bindings  (position ... x)     . se))
    ;; or one non-slot expression
    ((srfi-26-internal-cute
      slot-names              nse-bindings  (position ...)   nse . se)
     (srfi-26-internal-cute
      slot-names ((x nse) . nse-bindings) (position ... x)       . se))))

; exported syntax

(define-syntax cut
  (syntax-rules ()
    ((cut . slots-or-exprs)
     (srfi-26-internal-cut () () . slots-or-exprs))))

(define-syntax cute
  (syntax-rules ()
    ((cute . slots-or-exprs)
     (srfi-26-internal-cute () () () . slots-or-exprs))))

