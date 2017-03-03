(general-define-key "C-c m" 'hydra-misc/body)
(defhydra hydra-misc (:hint nil :color blue :columns 4)
  "Misc Helper"
  ("m" emacs-toggle-size "Toggle frame size")
  ("M" emacs-max "Max frame")
  ("e" escreen-create-screen "Create new screen")
  ("z" hydra-zoom/body "Zoom")
  ("g" google-this "Google this")
  ("q" nil "Cancel"))

;; ------ packages
(use-package maxframe
  :commands (emacs-max
             emacs-toggle-size)
  :config
  (progn
    (defvar emacs-min-top 23)
    (defvar emacs-min-left 0)
    (defvar emacs-min-width 85)
    (defvar emacs-min-height 35)
    (defun emacs-min ()
      (interactive)
      (set-frame-parameter (selected-frame) 'fullscreen nil)
      (set-frame-parameter (selected-frame) 'vertical-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'horizontal-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'top emacs-min-top)
      (set-frame-parameter (selected-frame) 'left emacs-min-left)
      (set-frame-parameter (selected-frame) 'height emacs-min-height)
      (set-frame-parameter (selected-frame) 'width emacs-min-width))
    (defun emacs-max ()
      (interactive)
      (set-frame-parameter (selected-frame) 'fullscreen 'fullboth)
      (set-frame-parameter (selected-frame) 'vertical-scroll-bars nil)
      (set-frame-parameter (selected-frame) 'horizontal-scroll-bars nil))
    (defun emacs-toggle-size ()
      (interactive)
      (if (> (cdr (assq 'width (frame-parameters))) 100)
          (emacs-min)
        (maximize-frame)))))

(use-package escreen
  :commands (escreen-create-screen)
  :bind (:map escreen-map
              ("e" . escreen-goto-last-screen)
              ("m" . escreen-menu))
  :config (escreen-install))

(use-package zoom-frm
  :commands (zoom-frm-in
             zoom-frm-out
             zoom-frm-unzoom
             zoom-in
             zoom-out
             hydra-zoom/body)
  :config
  (setq zoom-frame/buffer 'buffer)

  (defhydra hydra-zoom (:hint nil)
    "
  ^BUFFER^   ^FRAME^    ^ACTION^
  _t_: +     _T_: +     _0_: reset
  _s_: -     _S_: -     _q_: quit
"
    ("t" zoom-in )
    ("s" zoom-out )
    ("T" zoom-frm-in )
    ("S" zoom-frm-out )
    ("0" zoom-frm-unzoom)
    ("q" nil :color blue)))

(use-package powerline
  :config (powerline-default-theme))

(use-package paradox :commands paradox-list-packages)

(use-package google-this
  :commands (google-this)
  ;; :init (setq google-this-keybind (kbd "C-c m g"))
  ;; :config (google-this-mode 1)
  )

;;; misc.el ends here