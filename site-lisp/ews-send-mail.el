
(defun message-send-mail-with-ews ()
  (goto-char (point-min))
  (re-search-forward
   (concat "^" (regexp-quote mail-header-separator) "\n"))
  (replace-match "\n")
  (backward-char 1)
  (setq delimline (point-marker))
  (run-hooks 'message-send-mail-hook)
  (goto-char (1+ delimline))
  (let* ((default-directory "/")
         (message-text
          (buffer-substring-no-properties (point-min) (point-max)))
         )
    (ews-mail-send message-text)
    )
  )

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
    (message message-text)
    (insert (base64-encode-string message-text))
    (insert "</t:MimeContent>
        </t:Message>
      </m:Items>
    </m:CreateItem>
  </soap:Body>
</soap:Envelope>")
    ;; we now have the buffer content
    (let ((url-request-method "POST")
          (url-request-extra-headers '(("Content-Type" . "text/xml")))
          (url-request-data (buffer-string))
          )

      (pop-to-buffer (url-retrieve-synchronously
        "https://webmail.cse.org.uk/ews/exchange.asmx"
        )))
    ))


(setq message-send-mail-function 'message-send-mail-with-ews)
