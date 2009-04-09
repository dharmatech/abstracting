
(case scheme-implementation

  ((ypsilon ikarus larceny) (require-lib "glu/r6rs"))

  ((chicken)
   (load
    (string-append abstracting-root-directory "/support/chicken/glu/glu")))

  ((gambit)
   (load
    (string-append abstracting-root-directory "/support/gambit/glu/glu"))))

  

