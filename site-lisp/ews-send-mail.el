
(defvar message-send-mail-rexp-alist
  '(("@cse\\.org\\.uk$" . message-send-mail-with-ews)
    (".*" . message-send-mail-with-sendmail)))

(defun message-send-mail-with-rexp ()
  (let* ((from-address (message-sendmail-envelope-from))
         (fn (cl-loop for rexp in message-send-mail-rexp-alist
                      when (string-match-p (car rexp) from-address)
                      return (cdr rexp))))
    (message "sending with %s" fn)
    (funcall fn)))

(setq message-send-mail-function 'message-send-mail-with-rexp)

(defun message-send-mail-with-ews ()
  (goto-char (point-min))
  (re-search-forward
   (concat "^" (regexp-quote mail-header-separator) "\n"))
  (replace-match "\n")
  (backward-char 1)
  (setq delimline (point-marker))
  (run-hooks 'message-send-mail-hook)
  (ews-mail-send (buffer-substring-no-properties (point-min) (point-max))))

(defun ews-mail-send (message-text)
  (with-temp-buffer
    (insert "<?xml version='1.0' encoding='utf-8'?>
<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
               xmlns:m='http://schemas.microsoft.com/exchange/services/2006/messages'
               xmlns:t='http://schemas.microsoft.com/exchange/services/2006/types'
               xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
  <soap:Header>
    <t:RequestServerVersion Version='Exchange2007_SP1' />
  </soap:Header>
  <soap:Body>
    <m:CreateItem MessageDisposition='SendAndSaveCopy'>
      <m:SavedItemFolderId>
        <t:DistinguishedFolderId Id='sentitems' />
      </m:SavedItemFolderId>
      <m:Items>
        <t:Message>
          <t:MimeContent CharacterSet='UTF-8'>")
    (insert (base64-encode-string message-text))
    (insert "</t:MimeContent>
        </t:Message>
      </m:Items>
    </m:CreateItem>
  </soap:Body>
</soap:Envelope>")
    ;; process the result to see if it worked OK.
    ;; not sure what to do if it didn't - could queue the results somewhere
    (let ((url-request-method "POST")
          (url-request-extra-headers '(("Content-Type" . "text/xml")))
          (url-request-data (buffer-string))
          result-node)

      (with-current-buffer
          (url-retrieve-synchronously "https://webmail.cse.org.uk/ews/exchange.asmx")
        ;; skip headers
        (goto-char (point-min))
        (re-search-forward "\r?\n\r?\n")
        (setq result-node (xml-parse-region (point) (point-max)))
        (kill-buffer))

      (let* ((response (xml-match '(:* m:CreateItemResponseMessage) result-node)))
        (and (= 1 (length response))
             (string=
              "Success"
              (alist-get 'ResponseClass (nth 1 (nth 0 response)))))
        ))))





;; (setq message-send-mail-function 'message-send-mail-with-ews)
