
(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "glut/ypsilon"))
  
  ((larceny) ((-> loader 'lib) "glut/larceny"))

  ((ikarus)  ((-> loader 'lib) "glut/ikarus"))

  ((chicken) ((-> loader 'lib) "glut/chicken"))

  ((gambit)
   (gambit-scheme-load
    (string-append abstracting-root-directory
                   "/support/gambit/glut/glut")))
  
  )

