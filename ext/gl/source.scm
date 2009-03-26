
(case scheme-implementation

  ((ypsilon) (require-lib "gl/ypsilon"))
  ((larceny) (require-lib "gl/larceny"))
  ((ikarus)  (require-lib "gl/ikarus"))

  ((chicken)
   (load (string-append abstracting-root-directory "/support/chicken/gl/gl.so")))

  ((gambit)
   (load (string-append abstracting-root-directory "/support/gambit/gl/gl"))))

