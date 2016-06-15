(defun my-adv-tramp-send-command (orig VEC COMMAND &optional NEVEROPEN NOOUTPUT)
  "Fix bug in tramp where /dev/null is clobbered.
This will be fixed upstream quite soon."
  (let* ((bad-part
         (if (> (length COMMAND) 35)
             (substring COMMAND 0 34)
           ""))

         (COMMAND
          (if (string=
               "exec env ENV='' HISTFILE=/dev/null"
               bad-part)
              (concat "exec env ENV='' HISTFILE='' HISTFILESIZE=0 HISTSIZE=0"
                     (substring COMMAND 34))
            COMMAND)))
    (funcall orig VEC COMMAND NEVEROPEN NOOUTPUT)))

(advice-add 'tramp-send-command :around #'my-adv-tramp-send-command)
;; (advice-remove 'tramp-send-command #'my-adv-tramp-send-command)
