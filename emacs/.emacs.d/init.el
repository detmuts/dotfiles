(require 'package)
(package-initialize)
(require 'org)
(setq user-emacs-directory "~/.emacs.d")
(org-babel-load-file (
        expand-file-name "settings.org"
                        user-emacs-directory))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (doom-one)))
 '(package-selected-packages
   (quote
    (company-ghc company-ghci haskell-mode use-package tablist super-save solarized-theme smartparens smart-mode-line scss-mode rubocop org-plus-contrib neotree magit linum-relative inf-ruby hydra helm-swoop helm-projectile helm-ls-git helm-gtags helm-firefox helm-descbinds helm-ag function-args flycheck evil-surround evil-nerd-commenter emmet-mode elpy company-web company-tern company-quickhelp company-jedi company-c-headers ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
