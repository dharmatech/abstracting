
(case scheme-implementation

  ((ypsilon) (require-lib "srfi/27/ypsilon"))

  ((larceny) (require-lib "srfi/27/larceny"))

  ((ikarus)  (require-lib "srfi/27/ikarus"))

  ((chicken) (require-lib "srfi/27/chicken"))

  )