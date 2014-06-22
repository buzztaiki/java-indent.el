;;; java-indent.el --- Fix up java indentation

;; Copyright (C) 2014  Taiki Sugawara

;; Author: Taiki Sugawara <buzz.taiki@gmail.com>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Usage:
;; 
;; Put following to your .emacs:
;;
;;      (require 'java-indent)
;;      (add-hook 'java-hook 'java-indent:setup)


;;; Code:

(require 'cc-mode)

(defun java-indent:lineup-as-next-indent (langelem)
  "Line up the current line on the next indnet of the LANGELEM line.

e.g.:

    foobar(barbaz(x,
        y));
    <--> c-basic-offset
"
  (save-excursion
    (goto-char (c-langelem-pos langelem))
    (back-to-indentation)
    (vector (+ (current-column) c-basic-offset))))

(defun java-indent:lineup-as-same-indent (langelem)
  "Line up the current line on the same indnet of the LANGELEM line.

e.g.:

    foobar(barbaz(x,
        y
    ));
"
  (save-excursion
    (goto-char (c-langelem-pos langelem))
    (back-to-indentation)
    (vector (current-column))))
  
(defun java-indent:block-stmt-2-key ()
  ;; add `try' keyword to block-stmt-2-key for try-with-resource
  (c-make-keywords-re t (cons "try" (c-lang-const c-block-stmt-2-kwds))))

;;;###autoload
(defun java-indent:setup ()
  "Setup `javap-indent' on current `java-mode' buffer."
  (interactive)
  (setq c-block-stmt-2-key (java-indent:block-stmt-2-key))
  (c-set-style "java-indent"))

(c-add-style
 "java-indent"
 '("java"
   (c-offsets-alist
    (arglist-intro . java-indent:lineup-as-next-indent)
    (arglist-cont-nonempty . java-indent:lineup-as-next-indent)
    (arglist-close . java-indent:lineup-as-same-indent)
    
    (block-close . 0)
    (class-close . 0)
    (inexpr-class . 0)
    (annotation-top-cont . 0)
    (annotation-var-cont . 0)
    )
   (c-recognize-<>-arglists . t)))


;; Local Variables:
;; lexical-binding: t
;; indent-tabs-mode: nil
;; End:

(provide 'java-indent)
;;; java-indent.el ends here
