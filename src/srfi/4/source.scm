
(case scheme-implementation

  ((ypsilon larceny ikarus) (require-lib "srfi/4/r6rs"))

  ((chicken gambit)  (require-lib "srfi/4/chicken")))