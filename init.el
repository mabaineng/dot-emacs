(defconst emacs-start-time (current-time))
(unless noninteractive
  (message "Loading %s..." load-file-name))

(setq message-log-max 16384)

;; ------ set load path
(eval-and-compile
  (mapc
   #'(lambda (path)
       (push (expand-file-name path user-emacs-directory) load-path))
   '("site-lisp" "site-lisp/el-get" "site-lisp/use-package" "lisp" "")))

;; ------ load custom settings
(load (expand-file-name "custom-settings" user-emacs-directory))

;; ------ core packages
(eval-and-compile
  (require 'cl))

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get-bundle gnus)

(el-get-bundle use-package)
(eval-and-compile
  (defvar use-package-verbose t)
  (require 'use-package))
(require 'bind-key)
(require 'diminish nil t)

;; ------ libraries
(el-get-bundle elpa:dash)
(el-get-bundle elpa:s)

;; ------ packages from elpa
(el-get-bundle elpa:exec-path-from-shell)
(el-get-bundle elpa:projectile)
(el-get-bundle elpa:helm)
(el-get-bundle elpa:helm-core)
(el-get-bundle elpa:helm-ls-git)
(el-get-bundle elpa:helm-projectile)
(el-get-bundle elpa:ido-hacks)
(el-get-bundle elpa:flx-ido)
(el-get-bundle elpa:magit)
(el-get-bundle elpa:color-theme)
(el-get-bundle elpa:powerline)
(el-get-bundle elpa:window-number)
(el-get-bundle elpa:auto-highlight-symbol)
(el-get-bundle elpa:dired+)
(el-get-bundle elpa:dired-toggle)
(el-get-bundle elpa:bookmark+)
(el-get-bundle elpa:dedicated)
(el-get-bundle elpa:ggtags)
(el-get-bundle elpa:etags-select)
(el-get-bundle elpa:etags-table)
(el-get-bundle elpa:session)
(el-get-bundle elpa:company)
(el-get-bundle elpa:backup-each-save)
(el-get-bundle elpa:escreen)
(el-get-bundle elpa:hl-line+)
(el-get-bundle elpa:git-messenger)

(el-get-bundle elpa:cmake-mode)
(el-get-bundle elpa:web-mode)
(el-get-bundle elpa:yaml-mode)
(el-get-bundle elpa:css-mode)
(el-get-bundle elpa:calfw)

;; ------ packages from others
(el-get-bundle ag)
(el-get-bundle helm-ag)
(el-get-bundle diminish)
(el-get-bundle initsplit)
(el-get-bundle yasnippet)
(el-get-bundle expand-region)
(el-get-bundle fold-this)
(el-get-bundle org)
(el-get-bundle org-magit)

;; ------ utility macros and functions
(defsubst hook-into-modes (func &rest modes)
  (dolist (mode-hook modes) (add-hook mode-hook func)))

(defun list-regex-match-p (string list)
  (catch 'matched_ (dolist (regex list)
                     (if (string-match regex string)
                         (throw 'matched_ t))) nil))

(defun my-split-window (number)
  (let* ((W1 (get-buffer-window))
         (windows (list (cons 1 W1)))
         i W2 W3 W4 W5 W6 W7 W8 W9 W10 W11 W12
         curr-window last-window)
    (when (> number 1)
      (setq W2 (split-window W1 nil 'below))
      (add-to-list 'windows (cons 2 W2) t))
    (loop for i from 3 upto number do
          (setq curr-window (intern (concat "W" (int-to-string i))))
          (setq last-window (symbol-value (intern (concat "W"
                                                          (int-to-string (- i 2)))) ))
          (set curr-window (split-window last-window nil 'right))
          (add-to-list 'windows (cons i (symbol-value curr-window)) t)
          (balance-windows) )
    windows))

;; ------ enable disabled commands
(put 'downcase-region  'disabled nil)   ; Let downcasing work
(put 'erase-buffer     'disabled nil)
(put 'eval-expression  'disabled nil)   ; Let ESC-ESC work
(put 'narrow-to-page   'disabled nil)   ; Let narrowing work
(put 'narrow-to-region 'disabled nil)   ; Let narrowing work
(put 'set-goal-column  'disabled nil)
(put 'upcase-region    'disabled nil)   ; Let upcasing work

;; ------ keybindings init
(load (expand-file-name "keybinding-init" user-emacs-directory))

;; ------ packages init
(load (expand-file-name "package-init" user-emacs-directory))

;; ------ time costing
(when window-system
  (let ((elapsed (float-time (time-subtract (current-time)
                                            emacs-start-time))))
    (message "Loading %s...done (%.3fs)" load-file-name elapsed))

  (add-hook 'after-init-hook
            `(lambda ()
               (let ((elapsed (float-time (time-subtract (current-time)
                                                         emacs-start-time))))
                 (message "Loading %s...done (%.3fs) [after-init]"
                          ,load-file-name elapsed)))
            t))

;; ====== init.el ends here
