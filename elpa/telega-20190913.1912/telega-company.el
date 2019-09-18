;;; telega-company.el --- Completions with company for telega  -*- lexical-binding:t -*-

;; Copyright (C) 2019 by Zajcev Evgeny.

;; Author: Zajcev Evgeny <zevlg@yandex.ru>
;; Created: Fri Feb  8 01:37:44 2019
;; Keywords:

;; telega is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; telega is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with telega.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; company-mode backends to be used in telega:
;;  `telega-company-emoji' to complete emojis
;;  `telega-company-username' to complete usernames

;;; Code:
(require 'telega-core)
(require 'telega-util)
(require 'telega-user)

(defvar company-minimum-prefix-length)
(declare-function company-begin-backend "company" (backend &optional callback))
(declare-function company-grab "company" (regexp &optional expression limit))
(declare-function company-grab-line "company" (regexp &optional expression))

(declare-function telega-chat--info "telega-chat" (chat))
(declare-function telega-chat--type "telega-chat" (chat &optional no-interpret))
(declare-function telega-chatbuf-attach-inline-bot-query "telega-chat" (&optional no-empty-search))
(declare-function telega--full-info "telega-info" (tlobj))

(defun telega-company-grab-single-char (char)
  "Grab string starting with single CHAR.
Matches only if CHAR does not apper in the middle of the word."
  (let ((p (point)))
    (save-excursion
      (when (looking-at "\\>")
        (skip-syntax-backward "w"))
      (when (= (char-before) char)
        (let ((char-str (char-to-string char)))
          (skip-chars-backward char-str)
          (unless (looking-at "\\>")
            (cons (buffer-substring p (point))
                  company-minimum-prefix-length)))))))


;;; Emoji completion
(defun telega-company-grab-emoji ()
  (let ((cg (company-grab ":[^: _]+" nil
                          (- (point) telega-emoji-max-length))))
    (when cg (cons cg company-minimum-prefix-length))))

;;;###autoload
(defun telega-company-emoji (command &optional arg &rest ignored)
  "Backend for `company' to complete emojis."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'telega-company-emoji))
    (init (telega-emoji-init))
    (require-match 'never)
    (sorted t)
    ;; Always match if having `:'
    (prefix (telega-company-grab-emoji))
    ;; No caching for fuzzy matching, otherwise it won't work
    (no-cache telega-emoji-fuzzy-match)
    (candidates
     (cl-remove-if-not
      (lambda (en)
        (or (string-prefix-p arg en)
            (and telega-emoji-fuzzy-match
                 (string-match-p
                  (regexp-quote (concat "-" (substring arg 1))) en))))
      telega-emoji-candidates))
    (annotation
     ;; NOTE: if `telega-emoji-use-images' is used, use "EE" as
     ;; corresponding string for better formatting
     ;; :flag-XX: has `1' width, though occupies 2 chars
     (let* ((emoji (cdr (assoc arg telega-emoji-alist)))
            (flag-p (string-prefix-p ":flag-" arg)))
       (concat "  "
               (if telega-emoji-use-images
                   (propertize "EE" 'display
                               (telega-emoji-create-svg
                                emoji 1 (if flag-p 1 nil)))
                 emoji))))
    (post-completion
     (delete-region (- (point) (length arg)) (point))
     (let ((emoji (cdr (assoc arg telega-emoji-alist))))
       (when telega-emoji-use-images
         (telega-symbol-emojify emoji))
       (insert emoji)))
    ))


;;; Username completion for chat buffer
(defun telega-company-grab-username ()
  "Grab string starting with `@'."
  (telega-company-grab-single-char ?\@))

;;;###autoload
(defun telega-company-username (command &optional arg &rest ignored)
  "Backend for `company' to complete usernames."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'telega-company-username))
    (init (unless (eq major-mode 'telega-chat-mode)
            (error "`telega-company-username' can be used only in chat buffer")))
    (sorted t)
    (prefix (telega-company-grab-username))
    (require-match 'never)
    (candidates
     (cl-assert (> (length arg) 0))
     (let ((members (telega--searchChatMembers
                     telega-chatbuf--chat (substring arg 1))))
       (nconc (delq nil
                    (mapcar (lambda (member)
                              (let ((username (telega-tl-str member :username)))
                                (unless (string-empty-p username)
                                  (propertize (concat "@" username)
                                              'telega-member member))))
                            members))
               (cl-remove-if-not (lambda (botname)
                                   (string-prefix-p arg botname))
                                 telega-known-inline-bots))))
    (annotation
     ;; Use non-nil `company-tooltip-align-annotations' to align
     (let ((member (get-text-property 0 'telega-member arg)))
       (when member
         (concat "  " (telega-user--name member 'name)))))
    (post-completion
     (let ((known-bot-p (member (telega-chatbuf-input-string)
                                telega-known-inline-bots)))
       (insert " ")
       (when known-bot-p
         (telega-chatbuf-attach-inline-bot-query 'no-search))))
    ))


;;; Hashtags completion for chatbuffer
(defun telega-company-grab-hashtag ()
  "Grab string starting with `#'."
  (telega-company-grab-single-char ?\#))

;;;###autoload
(defun telega-company-hashtag (command &optional arg &rest ignored)
  "Backend for `company' to complete recent hashtags."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'telega-company-hashtag))
    (init (unless (eq major-mode 'telega-chat-mode)
            (error "`telega-company-hashtag' can be used only in chat buffer")))
    (sorted t)
    (prefix (telega-company-grab-hashtag))
    (require-match 'never)
    (candidates
     (cl-assert (> (length arg) 0))
     (mapcar (lambda (ht) (concat "#" ht))
             (telega--searchHashtags (substring arg 1))))
    (post-completion
     (insert " "))
    ))


;;; Bot commands completion
(defun telega-company-grab-botcmd ()
  "Return non-nil if chatbuf input starts bot command."
  (let ((cg (company-grab-line "/[^ ]*")))
    (when (and cg (= telega-chatbuf--input-marker (match-beginning 0)))
      (cons cg company-minimum-prefix-length))))

(defun telega-company--bot-commands-alist ()
  (cl-assert telega-chatbuf--chat)
  (when (eq (telega-chat--type telega-chatbuf--chat) 'bot)
    (let* ((info (telega-chat--info telega-chatbuf--chat))
           (full-info (telega--full-info info))
           (bot-info (plist-get full-info :bot_info)))
      (mapcar (lambda (bot-cmd)
                (cons (concat "/" (plist-get bot-cmd :command))
                      (plist-get bot-cmd :description)))
              (plist-get bot-info :commands)))))

;;;###autoload
(defun telega-company-botcmd (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'telega-company-botcmd))
    (require-match 'never)
    (sorted t)
    ;; Always match if having `/'
    (prefix (telega-company-grab-botcmd))
    (candidates
     (let ((cmd-alist (telega-company--bot-commands-alist)))
       (all-completions arg cmd-alist)))
    (annotation
     (let ((cmd-alist (telega-company--bot-commands-alist)))
       (concat "  " (cdr (assoc arg cmd-alist)))))
    ))

(provide 'telega-company)

;;; telega-company.el ends here