
(case scheme-implementation

  ((ypsilon larceny) (: loader 'lib "srfi/4/r6rs"))

  ((chicken) (: loader 'lib "srfi/4/chicken")))