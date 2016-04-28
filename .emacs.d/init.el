;;; Package repos
(setq package-enable-at-startup nil)
(setq package-archives '(("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ("melpa-stable" . "http://stable.melpa.org/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))
(setq package-archive-priorities
      '(("melpa" . 30)
	("melpa-stable" . 20)
	("marmalade" . 10)
	("gnu" . 0)))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (go-eldoc go-mode projectile magit yaml-mode use-package ruby-tools ruby-mode ruby-end ruby-dev python-mode projectile-rails nginx-mode multi-term monokai-theme magit-find-file ido-sort-mtime ido-select-window go-projectile flx-ido))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; Install selected packages
(unless package-archive-contents
  (package-refresh-contents))
(dolist (pkg package-selected-packages)
  (unless (package-installed-p pkg)
    (package-install pkg)))

;;; windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings)
  (setq windmove-wrap-around t))
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)

;;; Delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; misc
(setq vc-follow-symlinks t)
(setq inhibit-splash-screen t)
(dolist (mode '(menu-bar-mode tool-bar-mode))
  (funcall mode -1))

(defalias 'yes-or-no-p 'y-or-n-p)

;;; themes
(load-theme 'monokai t)

;;; tabs
(setq indent-tabs-mode nil)
(setq tab-width 2)

;;; unix eol characters
(setq default-buffer-file-coding-system 'utf-8-unix)
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;;; temp files
(setq temporary-file-directory "~/.emacs.d/saves")
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(setq auto-save-list-file-prefix
      temporary-file-directory)

;;; ido-mode
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to `find-file' a recent file"
  (interactive)
  (unless (find-file (ido-completing-read "Find recent file: " recentf-list))
    (message "Aborting")))

;;; projectile/helm
(projectile-global-mode)
(global-set-key (kbd "C-x F") 'projectile-find-file)

;;; extra find-file shortcut
(global-set-key (kbd "C-x f") 'find-file)

;;; magit
(global-set-key (kbd "C-c s") 'magit-status)

;;; other window hotkey
(global-set-key (kbd "C-o") 'other-window)

;;; line numbers
;(global-linum-mode 1)
(setq linum-format "%4d\u2502 ")
(global-set-key (kbd "C-x n") 'global-linum-mode)

;;; hilight current line
;(global-hl-line-mode 1)

;;; enable mouse
;(unless window-system
;  (require 'mouse)
;  (xterm-mouse-mode t)
;  (defun track-mouse (e))
;  (setq mouse-sel-mode 0)
;  (global-set-key [mouse-4] '(lambda ()
;    (interactive)
;    (scroll-down 1)))
;  (global-set-key [mouse-5] '(lambda ()
;    (interactive)
;    (scroll-up 1))))

;;; show-paren-mode
(require 'paren)
(setq show-paren-delay 0)
(show-paren-mode 1)
(global-set-key (kbd "C-x |") 'split-window-right)
(global-set-key (kbd "C-x _") 'split-window-below)
(global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-<down>") 'shrink-window)
(global-set-key (kbd "C-S-<up>") 'enlarge-window)

;;; whitespace mode
(global-whitespace-mode 0) ; off by default
(global-set-key (kbd "C-x M-w") 'global-whitespace-mode)
(setq whitespace-style '(face spaces space-mark newline newline-mark tabs tab-mark))
(setq whitespace-display-mappings
      ;; all numbers are Unicode codepoint in decimal. try (insert-char 182 ) to see it
      '(
        (space-mark 32 [183] [46]) ; 32 SPACE, 183 MIDDLE DOT '·', 46 FULL STOP '.'
        (newline-mark 10 [9166 10]) ; 10 LINE FEED '⏎ '
        (tab-mark 9 [10230 9] [92 9]) ; 9 TAB, 10230 LONG RIGHTWARDS ARROW '⟶·'
      ))
(defun global-whitespace-toggle-newline () (interactive)
  (global-whitespace-toggle-options '(newline-mark newline)))
(global-set-key (kbd "C-x M-n") 'global-whitespace-toggle-newline)
(defun global-whitespace-toggle-spaces () (interactive)
  (global-whitespace-toggle-options '(space-mark spaces)))
(global-set-key (kbd "C-x M-s") 'global-whitespace-toggle-spaces)
;;; toggle whitespace mode doesn't work without reloading file
(defun revert-buffer-no-confirm ()
  (revert-buffer t t))
(add-hook 'global-whitespace-mode-hook 'revert-buffer-no-confirm)

;;; ansi-term
(add-hook 'shell-dynamic-complete-functions 'bash-completion-dynamic-complete)
(add-hook 'shell-command-complete-functions 'bash-completion-dynamic-complete)
(defvar term-raw-map)
(add-hook 'term-mode-hook (lambda ()
  (define-key term-raw-map (kbd "<tab>")
    (lookup-key term-raw-map (kbd "C-M-I")))
  (define-key term-raw-map (kbd "M-x") 'execute-extended-command))
  (setq-local term-scroll-to-bottom-on-output t))
;(global-set-key (kbd "C-x C-x") (lambda () (interactive) (ansi-term "/bin/bash")))
(autoload 'multi-term "multi-term" nil t)
(autoload 'multi-term "multi-term" nil t)
(setq multi-term-program "/bin/bash")
(global-set-key (kbd "C-x t") 'multi-term-next)
(global-set-key (kbd "C-x T") 'multi-term)

;;; better buffer names
(require 'uniquify)
(setq uniquify-min-dir-content 2)
(setq uniquify-buffer-name-style 'forward)
;; M-x uniquify-rationalize-file-buffer-names will rename open buffers
(global-set-key (kbd "C-x M-r") 'uniquify-rationalize-file-buffer-names)

;;; kill all buffers
(defun nuke-all-buffers ()
  (interactive)
  (mapcar 'kill-buffer (buffer-list))
  (delete-other-windows))
(global-set-key (kbd "C-x K") 'nuke-all-buffers)

;;; auto open init.el
(find-file "~/.emacs.d/init.el")

;;; f5 refresh
(global-set-key (kbd "<f5>") 'revert-buffer)

;;; go-eldoc
(use-package go-eldoc
  :ensure t)

;;; go-mode
(use-package go-mode
  :ensure t
  :bind (("C-c C-r" . go-remove-unused-imports)
         ("M-." . godef-jump))
  :init (progn
          (add-hook 'before-save-hook  #'gofmt-before-save)
          (add-hook 'go-mode-hook 'go-eldoc-setup)))

; handle tmux's xterm-keys
;; put the following line in your ~/.tmux.conf:
;;   setw -g xterm-keys on
(if (getenv "TMUX")
    (progn
      (let ((x 2) (tkey ""))
    (while (<= x 8)
      ;; shift
      (if (= x 2)
          (setq tkey "S-"))
      ;; alt
      (if (= x 3)
          (setq tkey "M-"))
      ;; alt + shift
      (if (= x 4)
          (setq tkey "M-S-"))
      ;; ctrl
      (if (= x 5)
          (setq tkey "C-"))
      ;; ctrl + shift
      (if (= x 6)
          (setq tkey "C-S-"))
      ;; ctrl + alt
      (if (= x 7)
          (setq tkey "C-M-"))
      ;; ctrl + alt + shift
      (if (= x 8)
          (setq tkey "C-M-S-"))

      ;; arrows
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d A" x)) (kbd (format "%s<up>" tkey)))
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d B" x)) (kbd (format "%s<down>" tkey)))
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d C" x)) (kbd (format "%s<right>" tkey)))
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d D" x)) (kbd (format "%s<left>" tkey)))
      ;; home
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d H" x)) (kbd (format "%s<home>" tkey)))
      ;; end
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d F" x)) (kbd (format "%s<end>" tkey)))
      ;; page up
      (define-key key-translation-map (kbd (format "M-[ 5 ; %d ~" x)) (kbd (format "%s<prior>" tkey)))
      ;; page down
      (define-key key-translation-map (kbd (format "M-[ 6 ; %d ~" x)) (kbd (format "%s<next>" tkey)))
      ;; insert
      (define-key key-translation-map (kbd (format "M-[ 2 ; %d ~" x)) (kbd (format "%s<delete>" tkey)))
      ;; delete
      (define-key key-translation-map (kbd (format "M-[ 3 ; %d ~" x)) (kbd (format "%s<delete>" tkey)))
      ;; f1
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d P" x)) (kbd (format "%s<f1>" tkey)))
      ;; f2
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d Q" x)) (kbd (format "%s<f2>" tkey)))
      ;; f3
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d R" x)) (kbd (format "%s<f3>" tkey)))
      ;; f4
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d S" x)) (kbd (format "%s<f4>" tkey)))
      ;; f5
      (define-key key-translation-map (kbd (format "M-[ 15 ; %d ~" x)) (kbd (format "%s<f5>" tkey)))
      ;; f6
      (define-key key-translation-map (kbd (format "M-[ 17 ; %d ~" x)) (kbd (format "%s<f6>" tkey)))
      ;; f7
      (define-key key-translation-map (kbd (format "M-[ 18 ; %d ~" x)) (kbd (format "%s<f7>" tkey)))
      ;; f8
      (define-key key-translation-map (kbd (format "M-[ 19 ; %d ~" x)) (kbd (format "%s<f8>" tkey)))
      ;; f9
      (define-key key-translation-map (kbd (format "M-[ 20 ; %d ~" x)) (kbd (format "%s<f9>" tkey)))
      ;; f10
      (define-key key-translation-map (kbd (format "M-[ 21 ; %d ~" x)) (kbd (format "%s<f10>" tkey)))
      ;; f11
      (define-key key-translation-map (kbd (format "M-[ 23 ; %d ~" x)) (kbd (format "%s<f11>" tkey)))
      ;; f12
      (define-key key-translation-map (kbd (format "M-[ 24 ; %d ~" x)) (kbd (format "%s<f12>" tkey)))
      ;; f13
      (define-key key-translation-map (kbd (format "M-[ 25 ; %d ~" x)) (kbd (format "%s<f13>" tkey)))
      ;; f14
      (define-key key-translation-map (kbd (format "M-[ 26 ; %d ~" x)) (kbd (format "%s<f14>" tkey)))
      ;; f15
      (define-key key-translation-map (kbd (format "M-[ 28 ; %d ~" x)) (kbd (format "%s<f15>" tkey)))
      ;; f16
      (define-key key-translation-map (kbd (format "M-[ 29 ; %d ~" x)) (kbd (format "%s<f16>" tkey)))
      ;; f17
      (define-key key-translation-map (kbd (format "M-[ 31 ; %d ~" x)) (kbd (format "%s<f17>" tkey)))
      ;; f18
      (define-key key-translation-map (kbd (format "M-[ 32 ; %d ~" x)) (kbd (format "%s<f18>" tkey)))
      ;; f19
      (define-key key-translation-map (kbd (format "M-[ 33 ; %d ~" x)) (kbd (format "%s<f19>" tkey)))
      ;; f20
      (define-key key-translation-map (kbd (format "M-[ 34 ; %d ~" x)) (kbd (format "%s<f20>" tkey)))

      (setq x (+ x 1))
      ))
    )
  )
