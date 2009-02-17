
(case scheme-implementation

  ((ypsilon) ((-> loader 'lib) "srfi/27/ypsilon"))

  ((larceny) ((-> loader 'lib) "srfi/27/larceny"))

  )