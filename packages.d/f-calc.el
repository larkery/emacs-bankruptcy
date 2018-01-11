(with-eval-after-load 'calc
  (defalias 'calcFunc-uconv 'math-convert-units))

(req-package calc-repl
  :bind ("C-c *" . calc-repl))
