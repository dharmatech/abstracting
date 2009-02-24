
;; dependencies
;;
;; (current-directory [dir])
;;
;; (file-exists? path-string)

(current-directory "src")

(load "obj/obj.scm")
(load "vec/vec.scm")
(load "path/path.scm")
(load "loader/loader.scm")

(current-directory "..")

(define loader (make-loader))

((-> loader 'add-root) (string-append (current-directory) "/src"))
((-> loader 'add-root) (string-append (current-directory) "/examples"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Helper for the '--lib' command line option

(define-macro (loader-lib name)
  `((-> loader 'lib) (symbol->string ',name)))