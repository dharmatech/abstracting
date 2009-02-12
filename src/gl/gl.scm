
(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "gl/ypsilon"))

  ((larceny) ((-> loader 'lib) "gl/larceny"))

  ((chicken) ((-> loader 'lib) "gl/chicken"))

  )

