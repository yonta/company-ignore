;;; company-ignore.el --- Ignore certain words in certain company-backend.  -*- lexical-binding: t; -*-

;; Copyright (C) 2022 SAITOU Keita <keita44.f4@gmail.com>

;; Author: SAITOU Keita <keita44.f4@gmail.com>
;; Keywords: convenience, tools, lisp

;; This file is distributed under the terms of Apache License (version 2.0).
;; See also LICENSE file.

;;; Commentary:

;; Ignore certain words in certain company-backend.
;;
;; Sometimes, you want to not completing by `company-mode'.
;; For example, when you type short word like `do' in Ruby programing,
;; I want not to show any completion candidates like `down'.
;;
;; This package provide that ignore words list of `company-mode'.
;; You can stop the company backend by words black list.

;;; Code:

(require 'company)
(require 'nadvice)

(defun company-ignore-ignorep (input words)
  "Check that `INPUT' is in `WORDS.'

`INPUT' is string like \"do\".

  `WORDS' is words black list, which is string list like `'(\"do\" \"end\")"
  (seq-find (lambda (ban) (string-equal input ban)) words))

(defun company-ignore-before-while-advice (words)
  "Advice function of company backends to stop completion.

`WORDS' is words black list, which is string list like `'(\"do\" \"end\")"
  (lambda (command &optional _arg &rest _args)
    (pcase command
      ('prefix (not (company-ignore-ignorep (company-grab-symbol) words)))
      (_ t))))

;;;###autoload
(defun company-ignore (backend-symbol words)
  "Stop the completion by words black list.

`BACKEND-SYMBOL' specifies the company backend.

`WORDS' is words black list, which is string list like `'(\"do\" \"end\")"
  (advice-add backend-symbol :before-while (company-ignore-before-while-advice words)))

(provide 'company-ignore)
;;; company-ignore.el ends here
