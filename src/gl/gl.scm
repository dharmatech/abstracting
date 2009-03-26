
(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "gl/ypsilon"))

  ((larceny) ((-> loader 'lib) "gl/larceny"))

  ((ikarus)  ((-> loader 'lib) "gl/ikarus"))

  ;; ((chicken) ((-> loader 'lib) "gl/chicken"))

  ((chicken)
   (chicken-scheme-load
    (string-append abstracting-root-directory "/support/chicken/gl/gl.so")))

  ((gambit)
   (gambit-scheme-load
    (string-append abstracting-root-directory "/support/gambit/gl/gl"))))

