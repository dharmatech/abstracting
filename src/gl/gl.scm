
(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "gl/ypsilon"))

  ((larceny) ((-> loader 'lib) "gl/larceny"))

  ((ikarus)  ((-> loader 'lib) "gl/ikarus"))

  ((chicken) ((-> loader 'lib) "gl/chicken"))

  )

