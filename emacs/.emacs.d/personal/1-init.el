(prelude-require-packages '(use-package))
;; General packages
(use-package linum-relative
  :ensure t
  :config
  (global-linum-mode))
(use-package iedit
  :ensure t
  :defer t)
(use-package multiple-cursors
  :ensure t)
(use-package persp-mode
  :ensure t
  :config
  (persp-mode t))
(use-package pos-tip
  :ensure t)
(use-package company-quickhelp
  :ensure t
  :config
  (company-quickhelp-mode 1)
  (setq company-quickhelp-delay 0.3))
(use-package restclient
  :ensure t
  :defer t)
(use-package ruby-tools
  :ensure t
  :bind (:map ruby-tools-mode-map
         ("C-;" . iedit-mode)))
(use-package helm-swoop
  :ensure t
  :bind (("M-i" . helm-swoop)
         ("M-I" . helm-swoop-back-to-last-point)
         ("C-c M-i" . helm-multi-swoop)
         ("C-x M-i" . helm-multi-swoop-all)
         :map isearch-mode-map
         ("M-i" . helm-swoop-from-isearch)
         :map helm-swoop-map
         ("M-i" . helm-multi-swoop-all-from-helm-swoop))
  :config (progn
            (setq helm-swoop-split-with-multiple-windows t)
            (setq helm-swoop-split-direction 'split-window-vertically)))
(use-package paradox
  :ensure t
  :config
  (paradox-enable))
(use-package rust-mode
  :ensure t)
(use-package rvm
  :ensure t)
(rvm-use-default)
(use-package robe
  :ensure t
  :defer t)
(add-hook 'ruby-mode-hook 'robe-mode)
(eval-after-load 'company
  '(push 'company-robe company-backends))
(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby))
(use-package indent-guide
  :ensure t)

;; Theming
(use-package leuven-theme
  :ensure t
  :defer t)
(use-package gruvbox-theme
  :ensure t
  :defer t)
(load-theme 'gruvbox t)
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :defer t)
(use-package all-the-icons
  :ensure t
  :defer t)
(use-package neotree
  :ensure t
  :defer t
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))
(use-package org-bullets
  :ensure t)
(add-hook 'org-mode-hook
          (lambda () (org-bullets-mode 1)))
(setq org-src-fontify-natively t)

(add-hook 'before-save-hook
          (lambda () (delete-trailing-whitespace)))
(yas-global-mode 1)
;; Add yasnippet support for all company backends
;; https://github.com/syl20bnr/spacemacs/pull/179
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")
(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas)
          (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))
(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
(setq helm-move-to-line-cycle-in-source nil)
(global-visual-line-mode)
(indent-guide-global-mode)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox-nightly")
;; (setq guru-warn-only nil)
(setq prelude-flyspell nil)
(setq prelude-whitespace nil)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(add-to-list 'default-frame-alist '(font . "Meslo LG M DZ-10"))
