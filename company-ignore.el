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
  ""
  (seq-find (lambda (ban) (string-equal input ban)) words))

(defun company-ignore-before-while-advice (words)
  ""
  (lambda (command &optional _arg &rest _args)
    (pcase command
      ('prefix (not (company-ignore-ignorep (company-grab-symbol) words)))
      (_ t))))

;;;###autoload
(defun company-ignore (backend-symbol words)
  ""
  (advice-add backend-symbol :before-while (company-ignore-before-while-advice words)))

(provide 'company-ignore)
;;; company-ignore.el ends here
