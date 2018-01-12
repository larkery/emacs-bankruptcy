(with-eval-after-load 'calc
  (defalias 'calcFunc-uconv 'math-convert-units))

(req-package calc-repl
  :ensure nil
  :bind ("C-c *" . calc-repl))
