(prelude-require-packages '(use-package))
;; General packages
(use-package linum-relative
  :ensure t)
(use-package iedit
  :ensure t)
;; TODO: Set keymap for multiple-cursors
(use-package multiple-cursors
  :ensure t)
(use-package helm-swoop
  :ensure t
  :bind (("M-i" . helm-swoop)
         ("M-I" . helm-swoop-back-to-last-point)
         ("C-c M-i" . helm-multi-swoop)
         ("C-x M-i" . helm-multi-swoop-all)
         :map isearch-mode-map
         ("M-i" . helm-swoop-from-isearch)
         :map helm-swoop-map
         ("M-i" . helm-multi-swoop-all-from-helm-swoop)))
(use-package paradox
  :ensure t)
(paradox-enable)
(use-package rust-mode
  :ensure t)

;; Theming
(use-package leuven-theme
  :ensure t
  :defer t)
(use-package gruvbox-theme
  :ensure t
  :defer t)
(use-package org-bullets
  :ensure t)
(add-hook 'org-mode-hook
          (lambda () (org-bullets-mode 1)))
(setq org-src-fontify-natively t)
(setq helm-move-to-line-cycle-in-source nil)
(scroll-bar-mode -1)
(global-linum-mode)
(global-visual-line-mode)
(load-theme 'gruvbox t)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox-nightly")
;; (setq guru-warn-only nil)
(setq prelude-flyspell nil)
(setq prelude-whitespace nil)
(setq default-frame-alist '((font . "Meslo LG M DZ-10")))
