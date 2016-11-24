;; -*- lexical-binding: t; -*-
(defun xml-match (rules nodes)
  "Find nodes in NODES that match RULE.

RULE should return the predicate to use at the next level.
It will be called with a node and itself, so it can return itself.
If it returns nil, the node is rejected.
If it returns t, the node is collected.
If it returns a function, the children are processed"
  (message "match %s" rules)
  (if rules
      (let (matches)
        (dolist (node nodes)
          (message "   %s" node)
          (pcase (xml-match-next-rule rules node)
            (:match (setq matches (cons node matches)))
            (:fail nil)
            (next-rules (setq matches
                              (nconc matches
                                     (xml-match next-rules (cddr node)))))

            ))
        matches)

    (copy-sequence nodes)) ;; with no rules, everything matches
  )

(defun xml-match-rule (rule node)
  (let ((result (pcase rule
                  (:* t)
                  (sym (and (listp node) (eq (car node) sym))))))
    ;; (message "      %s %s %s" result rule node)
    result))

(defun xml-match-next-rule (rules node)
  (if (xml-match-rule (car rules) node)
      (or (pcase (car rules)
            (:* (message "---->%s" (cadr rules))
                (if (xml-match-rule (cadr rules) node)
                    (cddr rules)
                  rules))
            (_ (cdr rules)))
          :match)
    :fail))
