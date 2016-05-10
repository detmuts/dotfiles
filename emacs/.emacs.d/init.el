(require 'package)
(package-initialize)
(require 'org)
(setq user-emacs-directory "~/.emacs.d")
(org-babel-load-file (
 expand-file-name "settings.org"
                  user-emacs-directory))
