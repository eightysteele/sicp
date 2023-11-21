; https://docs.racket-lang.org/sicp-manual/index.html
#lang scheme

; https://docs.racket-lang.org/rackunit/index.html
(require rackunit)

;;; Racket REPL context
;;; ,enter "/Users/ads/code/github/eightysteele/sicp/ch-1.rkt"

;;; Exercise 1.2 ===============================================================

(define prefix-form
  (/ (+ 5(+ 4 (- 2 (- 3 (+ 6 (/ 4 5))))))
     (* (- 6 2) (- 2 7))))

;;; Exercise 1.3 ===============================================================
;;; Define a procedure that takes three numbers as arguments and returns the sum
;;; of the squares of the two larger numbers.

(define (square x)
  "Return x times itself."
  (* x x))

(define (sum-of-squares x y)
  "Return sum of squares of x and y."
  (+ (square x) (square y)))

(define (sum-of-squares-larger x y z)
  "Return sum of squares of the two larger numbers."
   (if (>= x y)
       (if (>= y z)
           (sum-of-squares x y)
           (sum-of-squares x z))
       (if (>= x z)
           (sum-of-squares y x)
           (sum-of-squares y z))))

;;; Exercise 1.3 tests =========================================================

(test-case
 "square"
 (test-equal? "-1" 1 (square -1))
 (test-equal? "0" 0 (square 0))
 (test-equal? "1" 1(square 1))
 (test-equal? "2" 4 (square 2)))

(test-case
 "sum-of-squares"
 (test-equal? "0 0" 0 (sum-of-squares 0 0))
 (test-equal? "-1 0" 1 (sum-of-squares -1 0))
 (test-equal? "-1 -1" 2 (sum-of-squares -1 -1))
 (test-equal? "1 1" 2 (sum-of-squares 1 1))
 (test-equal? "2 2" 8 (sum-of-squares 2 2)))

(test-case
 "sum-of-squares-larger"
 (test-equal? "0 0 0" 0 (sum-of-squares-larger 0 0 0))
 (test-equal? "1 1 1" 2 (sum-of-squares-larger 1 1 1))
 (test-equal? "2 1 0" 5 (sum-of-squares-larger 2 1 0)) ; x >= y >= z
 (test-equal? "2 -1 0" 4 (sum-of-squares-larger 2 -1 0)) ; x >= y < z
 (test-equal? "-1 0 1" 1 (sum-of-squares-larger -1 0 1)) ; x < y < z
 (test-equal? "-1 1 1" 2 (sum-of-squares-larger -1 1 1)) ; x < y <= z
 (test-equal? "-1 0 -1" 1 (sum-of-squares-larger -1 0 -1)) ; x < y > z)
 (test-equal? "-1 1 1" 2 (sum-of-squares-larger -1 1 1))) ; x < y >= z)

;;; Exercise 1.4: Observe that our model of evaluation allows for combinations
;;; whose operators are compound expressions. Use this observation to describe
;;; the behavior of the following procedure:

(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

;;; Goal here is to add "a" to the absolute value of "b". How does normal-order
;;; evaluation help us get there wrt to operators that are compound expressions? 

;;; a - b = a + (-b)

;; Consider b positive
;;; a=1; b=2
;;; ((if (> 2 0) + -) 1 2)
;;; ((if t + -) 1 2)
;;; (+ 1 2)
;;; 3

;;; Consider b negative
;;; a=1; b=-2
;;; ((if (> -2 0) + -) 1 -2)
;;; ((if f + -) 1 -2)
;;; (- 1 -2)
;;; 3

;;; So the operator in this example is a compound expression, which evaluates
;;; to a primitive operator that is either "+" or "-" depending on the value
;;; of "b". If "b" is positive, we're good to go. Otherwise the operator
;;; evaluates to "-" which gives us: -(-b) = b -> the absolute value of "b".

;;; All to say, the behavior of the procedure totally depends on the value
;;; of "b" which dynamically determines the value of the operator, which is
;;; interesting.
