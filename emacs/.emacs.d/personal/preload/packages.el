(require 'prelude-packages)
(prelude-require-package 'use-package)

;; General packages
(use-package linum-relative
  :ensure t)
(use-package rust-mode
  :ensure t)

;; Theming
(use-package leuven-theme
  :ensure t)
(use-package color-theme-sanityinc-tomorrow
  :ensure t)

(scroll-bar-mode -1)
(linum-mode 1)
(linum-relative-toggle)
(disable-theme 'zenburn)
(setq prelude-theme 'sanityinc-tomorrow-night)
(setq default-frame-alist '((font . "Meslo LG M DZ-10")))
