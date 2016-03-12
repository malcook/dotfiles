;;; init.el --- user init file      -*- no-byte-compile: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;           EMACS INTEGRATION WITH DESKTOP OS AND NETWORK
(server-start)				; do this early on in-case
					; anyone is calling
					; emacsclient right away

;; (use-package edit-server :ensure t
;;   ;; for editting fields in chrome
;;   :init (edit-server-start))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PACKAGES - a few ways of cataloging and requiring them: package,
;;; use-package, auto-install, el-get:

(require 'package)
;; no need(add-to-list 'package-archives '("org"   . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("elpy" . "http://jorgenschaefer.github.io/packages/") t) ; for use by elpy
(package-initialize)

(require 'cl)

(unless (require 'use-package nil t) ;; (fboundp 'use-package)
  (package-install 'use-package)
  (require 'use-package))
  ;; (defmacro* use-package (p  &rest ignore &key init ensure)
  ;;   `(and
  ;;     (require ',p nil t)
  ;;     ,init
  ;;     ))

(or (use-package toc-org :ensure t
		 :config (progn
			 (add-hook 'org-mode-hook 'toc-org-enable)))
  (warn "org-toc not found"))


(fset 'function-put 'put)

;; (use-package paradox :ensure t
;;   ;; a modern packages menu
;;   :init (progn
;; 	  (setq paradox-github-token '4347ac649c32dcae5730afbaeaabcead8ed23076)
;; 	  ))

(use-package smart-mode-line :ensure t)	; makes paradox cleaner

(use-package async :ensure t)		; allowing paradox to perform asynchronous package installation, inter alia

(use-package auto-install :ensure t
  :config (progn
	  (setq auto-install-save-confirm nil) ; just do it!
	  (auto-install-update-emacswiki-package-name t)
	  ;; Make auto-installed packages findable: 
	  (add-to-list 'load-path (expand-file-name auto-install-directory))
	  ))

;; (use-package el-get :ensure t
;;   :init (progn
;; 	      (el-get-emacswiki-refresh)
;; 	      ))

(defvar EmacsInitDir (file-name-directory 
		      (or load-file-name ; in case of loading during
					; init, when it is set.
			  (buffer-file-name) ; in case of eval from within edit buffer.
			  )))

;; (dolist (default-directory (mapcar (lambda(d) (expand-file-name d EmacsInitDir)) 
;; 				   (list "elisp" 
;; 					 "elpa"
;; 					 )))
;;   ;; where else to find required libraries.  strategy cobbled from
;;   ;; http://www.emacswiki.org/emacs/LoadPath -
;;   (setq load-path
;;         (append
;;          (let ((load-path (copy-sequence load-path))) ;; Shadow -
;; 	   ;; ensuring that the loaded paths are IN FRONT OF system
;; 	   ;; paths
;;            (append
;;             (copy-sequence (normal-top-level-add-to-load-path '(".")))
;;             (normal-top-level-add-subdirs-to-load-path)))
;;          load-path)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                          ELISP DEVELOPMENT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package auto-compile :ensure t
  :config (progn
	  (setq load-prefer-newer t)	     ; don't load .elc if .el file is newer
	  (auto-compile-on-save-mode)	     ; compile .el files when they are being saved.
	  ))


(use-package shell
  :init (progn
	  (setq explicit-shell-file-name "/bin/bash")
	  ))
(use-package epresent :ensure t)
(use-package tramp :ensure t
  :init (progn
	  (setq
	   tramp-default-method "ssh"
	   ;; allowing these to work too:
	   ;;/access.stowers.org:~/
	   ;;/mec@:~/
	   tramp-default-user "mec"
	   ;;tramp-default-host "access.stowers.org"
	   tramp-default-host "beta"
	   )
	  ;;/ssh:mec@access.stowers.org:~/
	  ;;/mec@access.stowers.org:~/
	  ;;
	  ;;not working - multihop syntax:
	  ;;/mec@access.stowers.org|mec@maple|mec@catalpa:~/

	  ;; works: c-x c-f 
	  ;; /ssh:mec@access.stowers.org|ssh:mec@maple|ssh:mec@catalpa:~/
	  ;; but not with ffap
	  ;;
	  ;;/mec@access.stowers.org:~/
;;;ssh -v -L38080:localhost:38080 mec@access.stowers.org  -t ssh -v -L38080:localhost:38080 mec@maple -t ssh -v -L38080:localhost:8080 mec@bioinfo
	  ))

;; ; ------------------------------------------------------------------
;; ; tramp - kudos: https://lists.gnu.org/archive/html/tramp-devel/2012-01/msg00012.html
;; ; ------------------------------------------------------------------
;; (require 'tramp) ; if not already
;; (require 'tramp-sh) ; temporary workaround: see
;; ; http://lists.gnu.org/archive/html/tramp-devel/2012-01/msg00011.html
;; ;;; from  http://www.saltycrane.com/blog/2008/11/creating-remote-server-nicknames-sshconfig/
;; (tramp-set-completion-function "ssh"
;;   '((tramp-parse-sconfig "/etc/ssh_config")
;;     (tramp-parse-sconfig "~/.ssh/config")))
;; ;;; per Michael Albinus @
;; ;;; http://lists.gnu.org/archive/html/tramp-devel/2012-01/msg00008.html
;; ;;; for problem starting R from tramp file buffer
;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;; (setq desktop-files-not-to-save nil
;;       ;; default value skips tramp/ftp buffers.
;;       )

;;(require 'ipython)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                        HOST SPECIFIC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq printer-name 'PB020502)  ;- The name of a local printer to which
                               ;;data is sent for printing.
(setq lpr-switches '("-PB020502"))

(use-package printing
  :config (progn
	  (pr-update-menus t); make sure we use localhost as cups server
	  (setenv "CUPS_SERVER" "localhost")
	  ;;(package-require 'cups)			; from marmlade
	  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                             LOOK & FEEL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package zenburn-theme :ensure t)

(global-font-lock-mode 1)         ; make pretty color fonts default

;; (use-package hc-zenburn-theme :ensure t
;;   :init (progn))

(define-key global-map [f2] 'accelerate-menu)
(define-key global-map [menux] 'accelerate-menu)
(define-key global-map [menu] 'accelerate-menu)

(use-package recentf
  ;;  keep track of recently opened files in the file open menu
  :init (recentf-mode 1))

;;; Removes gui elements ;;;;
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))  ; no gui scrollbars
;;(menu-bar-no-scroll-bar)
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))      ; no toolbar!
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode 0))     ; no menubar - use f10 and tmm
;;;  SELECTION / CLIPBOARD / THE MOUSE & X -  c.f. http://www.emacswiki.org/emacs/CopyAndPaste
(setq select-enable-primary t);  - default nil; set this to t if you want the Emacs commands C-w and C-y to use the primary selection.
(setq select-enable-clipboard t);- default t; set this to nil if you want the Emacs commands C-w and C-y to use the clipboard selection.
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(use-package mouse-copy)
(global-set-key [C-down-mouse-1] 'mouse-drag-secondary-pasting)
(global-set-key [C-S-down-mouse-1] 'mouse-drag-secondary-moving)

;;; WINDOW NAVIGATION
(setq split-height-threshold 0)
(setq split-width-threshold 0)
(define-key global-map (kbd "C-`") 'other-frame)
(windmove-default-keybindings 'shift) ; which binds SHIFT-up/down/left/rignt to
                               ; switch emacs windows

(setq scroll-conservatively 10)

(unless window-system
  (xterm-mouse-mode t)
  )

(setq frame-title-format
      (list (user-login-name) "@"  (shell-command-to-string "hostname -s")  "| %S@%S: %b"))
;; Controls the title of the window-system window of the selected
;; frame.  changed to include user-login-name and hostname (is there a
;; better way to get this?)

(blink-cursor-mode)

;;;                     MACINTOSH SPECIFIC settings
(setq mac-option-modifier 'meta)

;;;                       EMAIL
(setq user-mail-address "malcolm.cook@gmail.com")
(setq user-full-name "Malcolm Cook")
;; (setq smtpmail-smtp-server "your.smtp.server.jp")
;; (setq mail-user-agent 'message-user-agent)
;; (setq message-send-mail-function 'message-smtpmail-send-it)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MISC SETTINGS
(setq garbage-collection-messages t)    ; tell me when GC is happening

(transient-mark-mode 1)  ;; always highlight region between point and mark
                         ;; (when active)

;; Show column and row number in mode line
(column-number-mode t)
(line-number-mode t)

;; When point is on paranthesis, highlight the matching one
(show-paren-mode t)
(which-function-mode t)

(setq indicate-empty-lines t) ;; Indicate empty lines at the end of buffer
(setq require-final-newline t) ;; Always end a file with a newline
(setq-default show-trailing-whitespace t) ;; Show trailing whitespace (usually a mistake)

(use-package ffap
  :init (progn
	  (ffap-bindings)
	  ;;(setq ffap-machine-p-known 'accept)
	  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                  MISC KEYMAP BINDINGS
(define-key global-map [(f6)] 'prefix-region)
(define-key global-map [(meta space)] 'fixup-whitespace) ;;overriding just-one-space
(define-key global-map [(control x) (meta y)] 'bury-buffer)
(define-key global-map [(control x) (control F)] 'find-file-at-point)
(define-key global-map [(meta p)] 'fill-paragraph)
(define-key global-map [M-S-mouse-3] 'imenu)
(define-key global-map [menu] 'imenu)
(define-key global-map [(control c) (control c)] 'comment-region)
(define-key global-map [(control kp-1)] 'shell)
(define-key global-map [(control f11)] 'shell)
(define-key global-map [(control kp-2)] 'manual-entry)
(define-key global-map [(control f2)] 'manual-entry)
(define-key global-map [(control x) p] 'previous-multiframe-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                  LITERATE PROGRAMMING AND DOCUMENTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun rmarkdown-render ()
  "run rmarkdown::render() on the current file and display results in buffer *Shell Command Output*"
  (interactive)
  (let ((render-command (read-string "render command:" 
				     (format "render('%s',%s);"
					     (shell-quote-argument (buffer-file-name))
					     "'all'"
					     ))))
    (shell-command
     (message
      "Rscript -e \"withCallingHandlers({library(rmarkdown); %s}, error = function(e) {print(sys.calls())})\"" ;;print(sessionInfo())
      render-command
      )
     "*rmarkdown::render standard output*"
     ;;"*rmarkdown::render error output*"
     )
    ))

(use-package markdown-mode :ensure t
  ;;"Major mode for editing Markdown files"
;;; c.f. http://jblevins.org/projects/markdown-mode/
  :config (progn
	  ;; (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
	  ;; (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
	  ;; (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
	  ;; (add-to-list 'auto-mode-alist '("\\.Rmd\\'" . markdown-mode))
	  ;;(define-key markdown-mode-map [(control c) (control c) (r)] 'rmarkdown-render)
	  ;;(define-key polymode-mode-map [(meta n) (r)] 'rmarkdown-render)
	  (define-key markdown-mode-map  (kbd "C-c C-c r") 'rmarkdown-render)
	  ;;(define-key markdown-mode-map (kbd "C-c C-c r") 'rmarkdown-render)
	  ;;(define-key map "\C-c\C-al" 'markdown-insert-link)
	  ;;(setq markdown-css-path
	  ;;(setq markdown-mode-hook nil)
	  (add-hook 'markdown-mode-hook 'pandoc-mode)
	  (add-hook 'markdown-mode-hook 'turn-on-orgtbl)
	  ;;(add-hook 'markdown-mode-hook 'orgtbl-mode)
	  ;;(add-hook 'markdown-mode-hook 'orgstruct-mode)
	  ;;(add-hook 'markdown-mode-hook 'orgstruct++-mode)
	  ))

;; *.Rmd files invoke r-mode                    ; Temporary fix for R markdown files
;(add-to-list 'auto-mode-alist '("\\.Rmd$" . r-mode))
; commented while trying out:

;; (use-package polymode :ensure t
;;   :config (progn
;; 	  (use-package poly-R)
;; 	  (use-package poly-markdown)
;; 	  (use-package poly-noweb)
;; 	  ;;(use-package poly-org)
;; 	  (define-key polymode-mode-map [(meta n) (r)] 'rmarkdown-render)
;; 	  ;;(define-key polymode-mode-map [(r)] 'self-insert-command)
	  
;; 	  (if nil (use-package polymode-configuration)
;; 	    ;; else, choose suits your needs and place into your .emacs file.
;; ;;; MARKDOWN
;; 	    ;;  (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
;; ;;; ORG
;; ;;;    (add-to-list 'auto-mode-alist '("\\.org" . poly-org-mode))
;; ;;; R related modes
;; 	    (add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
;; 	    (add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
;; 	    (add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
;; 	    (add-to-list 'auto-mode-alist '("\\.rapport" . poly-rapport-mode))
;; 	    (add-to-list 'auto-mode-alist '("\\.Rhtml" . poly-html+r-mode))
;; 	    (add-to-list 'auto-mode-alist '("\\.Rbrew" . poly-brew+r-mode))
;; 	    (add-to-list 'auto-mode-alist '("\\.Rcpp" . poly-r+c++-mode))
;; 	    (add-to-list 'auto-mode-alist '("\\.cppR" . poly-c++r-mode))
;; 	    (provide 'polymode-configuration))
;; 	  ))

;; (use-package pander-mode :ensure t
;;   :config (progn
;; 	  (add-hook 'markdown-mode-hook 'pander-mode)
;; 	  (add-hook 'pandoc-mode-hook
;; 		    ;; checks if a default settings file exists for the file
;; 		    ;; being loaded and reads its settings if it finds one.
;; 		    'pandoc-load-default-settings)
;; 	  ))

(use-package polymode
  ;; can work with both .Rmd and .org files
  :ensure t
  :config (use-package poly-org
		 ;; flaky? experimental? switch between modes
		 ;; within .org file
		 ))

(use-package org :ensure t
  :config (progn 
	    (use-package ob-ruby)
	    ;; ctrl+space does not work in emacs?
	    ;; should get fixed.  For now:
	    ;; > ibus exit
	    ;; or > apt-get uninstall ibux-???
	    ;; or xmodkeymap something
	    ;; c.f. https://bugs.launchpad.net/ubuntu/+source/ibus/+bug/1278569
	    ;;(use-package org-compat)
	    (use-package ob-sh)
	    ;;(use-package ob-lua)
	    (use-package ob-sql)
	    ;;(use-package ob-R)
	    (use-package ob-python)
	    ;; (use-package ob-dot)
	    ;; (use-package ob-screen)
	    (use-package ob-perl)
	    ;;(use-package ox-md)
	    (setq  org-confirm-babel-evaluate nil ;don't require confirmation to
;;;eval code.
		   org-babel-no-eval-on-ctrl-c-ctrl-c t ; But C-c C-v e will still
					; do it (just don't make
					; it soooo easy)
		   org-use-speed-commands t
		   org-src-preserve-indentation t ; The nil default is especially irksome in ESS.
		   )
	    (setq org-return-follows-link t)
	    (setq org-tab-follows-link t)
	    (setq org-html-postamble nil ; 'auto
		  org-latex-postamble nil)

	    (setq org-link-abbrev-alist
		  '(("bugzilla" . "http://10.1.2.9/bugzilla/show_bug.cgi?id=")
		    ("google"    . "http://www.google.com/search?q=") ;; [[google:OrgMode]]
 
		    ("ads"    . "http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?author=%s&db_key=AST")
		    ))
;;;;;  
	    (setq  org-confirm-babel-evaluate nil ;don't require confirmation to
;;;eval code.
		   org-babel-no-eval-on-ctrl-c-ctrl-c t ; But C-c C-v e will still
					; do it (just don't make
					; it soooo easy)
		   org-use-speed-commands t
		   org-src-preserve-indentation t ; The nil default is especially irksome in ESS.
		   )
	    (setq org-return-follows-link t)
	    (setq org-tab-follows-link t)
	    (setq org-log-done 'note) ;; time stamp TODOs when done and prompt for closing 'note'

	    (setq org-todo-keywords
		  '((sequence "TODO(t)" "WAIT(w@/!)" "ONIT" "|" "DONE(d!)" "CANCELED(c@)" )))
	    (define-key org-mode-map "\C-c2" 'org-babel-demarcate-block)

	    (add-hook 'org-mode-hook #'flyspell-mode)
	    (use-package ox-reveal :ensure t
	      ;; export org into nice html presentation's 
	      :config (progn
			(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/2.5.0/")
			))
	    (use-package org-tree-slide :ensure t ; NB -
	      :config (progn 
			(global-set-key (kbd "<f8>") 'org-tree-slide-mode)
			(global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)
			(define-key org-tree-slide-mode-map  "left" 'org-tree-slide-move-previous-tree)
			(define-key org-tree-slide-mode-map  "right" 'org-tree-slide-move-next-tree)
			(org-tree-slide-presentation-profile)
;;(etq org-tree-slide-slide-in-effect
			;;(org-tree-slide-simple-profile)
;; 			;;(org-tree-slide-narrowing-control-profile)

			))

	    ))


;#https://github.com/kawabata/ox-pandoc
;; default options for all output formats
(setq org-pandoc-options '((standalone . t)))
;; cancel above settings only for 'docx' format
(setq org-pandoc-options-for-docx '((standalone . nil)))
;; special settings for beamer-pdf and latex-pdf exporters
(setq org-pandoc-options-for-beamer-pdf '((latex-engine . "xelatex")))
(setq org-pandoc-options-for-latex-pdf '((latex-engine . "xelatex")))

(when nil
  (requireInst 'org-table-comment nil 
	       ;;(auto-install-from-url "http://www.emacswiki.org/emacs/download/org-table-comment.el")
	       (auto-install-from-emacswiki "org-table-comment.el")
	       )
					;(use-package org-table-comment :ensure t "http://www.emacswiki.org/emacs/download/org-table-comment.el")
					;(auto-install-from-emacswiki "org-table-comment.el")
					;(paradox-require 'org-table-comment)
  (org-table-comment-mode)
  ;;(turn-on-orgtbl)
  ;; I like this but there are clashes - i.e. orgtbl ctrl-c ctrl-c
  ;; shadows markdown utility commands which I miss , esp those for
  ;; promotion and demotion out headers

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                      SOFTWARE ENGINEERING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package gist :ensure t)

(use-package magit :ensure t)		; improved git interaction over 

;; (use-package yasnippet :ensure t
;;   ;; COMPLETION: yasnippet should be loaded before auto complete so
;;   ;; that they can work together
;;   :config (progn
;; 	      (yas-global-mode 0)
;; seems to cause bug on opening any file!
;; 	      ))

(use-package auto-complete
  :config (progn
	    (use-package auto-complete-config)
	    (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
	    (ac-config-default)
	    ;; set the trigger key so that it can work together with yasnippet on tab key,
	    ;; if the word exists in yasnippet, pressing tab will cause yasnippet to
	    ;; activate, otherwise, auto-complete will
	    (ac-set-trigger-key "TAB")
	    (ac-set-trigger-key "<tab>")
	    ))

(use-package calendar
  ;; http://www.emacswiki.org/emacs/InsertingTodaysDate
  :config (progn
	    (calendar-set-date-style 'iso) ;i.e. 2011-04-22
	    (defun insdate-insert-current-date (&optional omit-day-of-week-p)
	      "Insert today's date using the current locale.
  With a prefix argument, the date is inserted without the day of
  the week."
	      (interactive "P*")
	      (insert (calendar-date-string (calendar-current-date) nil
					    omit-day-of-week-p)))
	    (global-set-key "\C-x\M-;" `insdate-insert-current-date)
	    (define-key global-map 
	      ;; [(control \;)] same binding as MS Excel.  Unfortunately since I
	      ;; am now (2012-09-12) using flyspell, it is also bound to
	      ;; flyspell-auto-correct-previous-word,
	      [(control meta \;)] 
	      'insdate-insert-current-date)
	    ))

(setq eldoc-idle-delay  0.0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                 LANGUAGE MODES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package inf-ruby :ensure t)
(use-package ruby-mode
  :mode "\\.rb\\'"
  :interpreter "ruby"
  :ensure t
  )

(use-package enh-ruby-mode :ensure t
  :config (progn
	    (add-hook 'enh-ruby-mode-hook 'robe-mode)
	    (add-hook 'enh-ruby-mode-hook 'yard-mode)
	    ))

(use-package cperl-mode
  :config (progn
	    ;; Tell Emacs that CPerlMode should be used instead of
	    ;; PerlMode. Whenever perl-mode would normally be used cperl-mode is
	    ;; used instead.
	    (defalias 'perl-mode 'cperl-mode)
	    ;;http://search-dev.develooper.com/~nwclark/perl-5.8.6/emacs/cperl-mode.el
	    (cperl-set-style 'CPerl)


	    (defun cperl-perldoc (word)
	      "Run `perldoc' on WORD."
	      ;;hacked by mec to add -t to Manual-switches
	      (interactive
	       (list (let* ((default-entry (cperl-word-at-point))
			    (input (read-string
				    (format "perldoc entry%s: "
					    (if (string= default-entry "")
						""
					      (format " (default %s)" default-entry))))))
		       (if (string= input "")
			   (if (string= default-entry "")
			       (error "No perldoc args given")
			     default-entry)
			 input))))
	      (use-package man)
	      (let* ((is-func (and
			       (string-match "^[a-z]+$" word)
			       (string-match (concat "^" word "\\>")
					     (documentation-property
					      'cperl-short-docs
					      'variable-documentation))))
		     (manual-program (if is-func "perldoc -f" "perldoc")))
		(cond
		 (nil ;;cperl-xemacs-p
		  (let ((Manual-program "perldoc")
			(Manual-switches (if is-func (list  "-t" "-f" ) (list   "-t"  ))))
		    ;;(setq Manual-switches (cons "-m" Manual-switches))
		    (manual-entry word)))
		 (t
		  (Man-getpage-in-background word)))))

					;(defun cperl-pod-to-manpage ()
					;  "Create a virtual manpage in Emacs from the Perl Online Documentation."
					;  (interactive)
					;  (use-package man)
					;  (asdf)
					;  (let* ((pod2man-args (concat buffer-file-name " | nroff c -man "))
					;        (bufname (concat "Man " buffer-file-name))
					;        (buffer (generate-new-buffer bufname)))
					;    (save-excursion
					;      (set-buffer buffer)
					;      (let ((process-environment (copy-sequence process-environment)))
					;        ;; Prevent any attempt to use display terminal fanciness.
;;;        (setenv "TERM" "dumb")
					;        (set-process-sentinel
					;         (start-process pod2man-program buffer "sh" "-c"
					;                        (format (cperl-pod2man-build-command) pod2man-args))
					;         'Man-bgproc-sentinel)))))

					;(defun cperl-perldoc (word)
					;  "Run `perldoc' on WORD."
					;  (interactive
					;   (list (let* ((default-entry (cperl-word-at-point))
					;                (input (read-string
					;                        (format "perldoc entry%s: "
					;                                (if (string= default-entry "")
					;                                    ""
					;                                  (format " (default %s)" default-entry))))))
					;           (if (string= input "")
					;               (if (string= default-entry "")
					;                   (error "No perldoc args given")
					;                 default-entry)
					;             input))))
					;  (use-package man)
					;  (let* ((is-func (and
					;                  (string-match "^[a-z]+$" word)
					;                  (string-match (concat "^" word "\\>")
					;                                (documentation-property
					;                                 'cperl-short-docs
					;                                 'variable-documentation))))
					;        (manual-program (if is-func "perldoc -f" "perldoc -t")))
					;    (cond
					;     (cperl-xemacs-p
					;      (let ((Manual-program "perldoc")
					;            (Manual-switches (if is-func (list "-f"))))
					;        (manual-entry word)))
					;     (t
					;      (Man-getpage-in-background word)))))

	    (setq cperl-hairy t)
	    ;;(define-key cperl-mode-map [delete] 'delete-char)
	    ;;(define-key cperl-mode-map [(control x) p] 'cperl-fill-paragraph)
	    (define-key cperl-mode-map [(meta p)] 'cperl-fill-paragraph)
	    (define-key cperl-mode-map [(control c) (control c)] 'cperl-comment-region)

;;;(define-key cperl-mode-map [(control c) (control h) f] 'cperl-perldoc) ;override info system which we don't have files for
	    (define-key global-map [(control shift kp-2)] 'cperl-perldoc)
	    (define-key global-map [(control  f8)] 'cperl-perldoc)
					;(define-key global-map [(control shift 8)] 'cperl-perldoc)
					;(define-key global-map [(control shift 8)] 'cperl-perldoc)
	    (define-key global-map [(control kp-8)] 'cperl-perldoc)
	    (define-key global-map [(control h) d] 'cperl-perldoc)
	    (define-key global-map [(control shift f2)] 'cperl-perldoc)

	    (define-key cperl-mode-map "\C-cy" 'cperl-check-syntax)

	    (setq fill-column 78)
					;(setq auto-fill-mode t)

	    ;;when you want to look at the documentation:
	    ;;perldoc  AnotherModule (e.g. perldoc Bio::Seq)
	    ;;when you want to see the actual code in the module:
	    ;;perldoc -m AnotherModule
	    ;;when you want to know where the file is:
	    ;;perldoc -l AnotherModule

					;(defun my-cperl-ffap-locate(name)
					;  "Return cperl module for ffap"
					;  (let* ((r (replace-regexp-in-string ":" "/" (file-name-sans-extension name)))
					;        (e (replace-regexp-in-string "//" "/" r))
					;        (x (ffap-locate-file e '(".pm" ".pl" ".xs")
					;                             (append (ffap-all-subdirs-loop "/usr/lib/perl5/site_perl/5.8.5/" -1)
					;                                     (ffap-all-subdirs-loop "/usr/local/lib/perl5/site_perl/5.8.5/" -1)))))
					;    x
					;    )
					;  )

					;(add-to-list 'ffap-alist  '(cperl-mode . my-cperl-ffap-locate))

	    (defun my-cperl-eldoc-documentation-function ()
	      "Return meaningful doc string for `eldoc-mode'."
	      (car
	       (let ((cperl-message-on-help-error t))
		 (cperl-get-help))))

	    (add-hook
	     'cperl-mode-hook
	     (lambda ()
	       (set (make-local-variable 'eldoc-documentation-function)
		    'my-cperl-eldoc-documentation-function)))
	    ))


(defmacro mark-active ()
  "Xemacs/emacs compatibility macro"
  ;;From Perl Hacks: #7
  (if (boundp 'mark-active)
      'mark-active
    '(mark)))

(defun perltidy ()
  "Run perltidy on tyhe current region or buffer."
  (interactive)
                                        ; Inexpplicably, save-excurtion doesn['t work here
  (let ((orig-point (point)))
    (unless (mark-active) (mark-defun))
    (shell-command-on-region (point) (mark) "perltidy -q" nil t)
    (goto-char orig-point)))
(global-set-key "\C-ct" 'perltidy)

(eval-after-load "cperl-mode"
  ;;From Perl Hacks: #10 Run Tests from within emacs
  '(add-hook 'cperl-mode-hook (lambda () (local-set-key "\C-cp" 'cperl-prove))))
(defun cperl-prove ()
  "Run the current test."
  (interactive)
  (shell-command (concat "prove -v " (shell-quote-argument (buffer-file-name)))))


(defadvice cperl-indent-command
    (around cperl-indent-command)
  ;;From Perl Hacks: #5 Autocomplete Perl Identifiers - however cperl-indent-or-complete
  "Changes \\[cpers-indent-command] so it autocompletes when at the end of a word."
  (if (looking-at "\\>") (dabbrev-expand nil) ad-do-it)
  (eval-after-load "cperl-mode" '(progn (use-package dabbrev) (ad-activate 'cperl-indent-command))))


(defun perl-eval (beg end)
  "Run selected region as Perl code"
  ;;From Perl Hacks: 11 Run Perl from emacs
  (interactive "r")
  (shell-command-on-region beg end "perl \"-\"") ;note- this is NOT the hack in the book!
                                        ; feeds the regino to perl on STDIN
  )
(global-set-key "\M-\C-p" 'perl-eval)



;;;(use-package PerlySense) ;from my local xemacs/lisp - c.r. http://search.cpan.org/~johanl/Devel-PerlySense-0.0147/lib/Devel/PerlySense.pm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                     SQL MODE CONFIGURATION

(use-package sql
  :config (progn
	    (add-to-list 'auto-mode-alist  '("\\.\\(sql\\)" . sql-mode))
	    (setq  sql-mysql-program "mysql"
		   sql-mysql-options ""	;hmmm...

		   sql-ms-program "sqsh"
		   sql-sybase-program "sqsh"

                                        ;sql-user "mec"                 ;what is default
                                        ;sql-password ""                ;relying upon ~/.my.cnf
		   sql-database "" ; "mysql"               ;fair default
		   sql-server "" ; "mysql-dev"          ;could be localhost

                                        ;   sql-mode-postgres-font-lock-keywords - Postgres SQL keywords used by font-lock.
                                        ; * sql-postgres-options           (quote "-u") - List of additional options for `sql-postgres-program'.
                                        ;   sql-postgres-program           - Command to start psql by Postgres.


		   )

	    (setq	   sql-user ""	;what is default
			   sql-password "" ;relying upon ~/.my.cnf
			   sql-database "" ;fair default
			   sql-server ""   ;could be localhost
			   ;;sql-user "mec"                     ;what is default
			   ;;sql-password ""            ;relying upon ~/.my.cnf
			   ;;   sql-database "mysql"            ;fair default
			   ;;   sql-server "devel01"            ;could be localhost
			   )

	    (defun do-sql-mysql ()
	      (interactive)		; "D")
	      (sql-mysql)
	      ;;(sqli-rename-buffer)
	      (sql-set-sqli-buffer)
	      )

	    (defun do-sql-sybase ()
	      (interactive)		; "D")
	      (setq
	       ;;sql-user "SIMR01\\mec"                     ;what is default
	       sql-user "sa"		;what is default
	       ;;sql-password ""            ;relying upon network authentication?
	       ;;sql-database "SILO"                        ;fair default
	       sql-database "aquatics"	;fair default
	       sql-server "SQLDEV01" ;could be localhost or SQLKC01 or SQLDEV01
	       )
	      (sql-sybase))

	    (defun do-sql-postgres ()
	      (interactive)		; "D")
	      (setq   sql-user "flybase"            
		      sql-password ""	     ;relying upon ~/.my.cnf
		      sql-database "flybase" ;blastgres? mec?
		      sql-server "flybase.org" ;postgresql-dev
		      )

	      (setq   sql-user "astoria"            
		      sql-password "astoria" ;relying upon ~/.my.cnf
		      sql-database "astoria" ;blastgres? mec?
		      sql-server "postgresqlkc01" ;       ;postgresql-dev
		      )

	      (sql-postgres)
	      ;;  (rename-buffer "flybase@flybase.org")
	      )


	    (define-key global-map [(control kp-4)] 'do-sql-mysql)
	    (define-key global-map [(control f4)] 'do-sql-mysql)
                                        ;(define-key global-map [C-f4] 'do-sql-mysql)
	    (define-key global-map [(control kp-5)] 'do-sql-sybase)
	    (define-key global-map [(control kp-6)] 'do-sql-postgres)
	    (define-key global-map [(control f6)] 'do-sql-postgres)

	    (defun prefix-region-tab ()
	      ""
	      (interactive) 
	      (prefix-region "\t"))
	    (define-key global-map [(control meta tab)] ' prefix-region-tab)

	    (define-key global-map [(control c) (control d) ] 'sql-send-delimiter)
	    (defun sql-send-delimiter ()
	      "really of use only to mysql when we need to send the extra delimiter which I have set to '//'"
	      (interactive)
	      (comint-send-string sql-buffer "//\n")
	      )

                                        ; sql-set-sqli-buffer.
                                        ;  C-c C-b                      sql-send-buffer
                                        ;  C-c C-c                      sql-send-paragraph
                                        ;  C-c C-r                      sql-send-region

                                        ;#If you want to make SQL buffers limited in length, add the function
                                        ;#`comint-truncate-buffer' to `comint-output-filter-functions'.
                                        ;#Here is an example for your .emacs file.  It keeps the SQLi buffer a
                                        ;#certain length.

	    (setq sql-interactive-mode-hook nil)

                                        ;(add-hook 'sql-interactive-mode-hook
                                        ;    (function (lambda ()
                                        ;        (setq comint-output-filter-functions
                                        ;             '(
                                        ;               comint-truncate-buffer ;;keeps the SQLi buffer a certain length.
                                        ;               (function (lambda (STR) (comint-show-output)))
                                        ;               ;; point back to the statement you entered, right
                                        ;               ;; above the output it created.
                                        ;               )))))

;;; following from http://www.emacswiki.org/cgi-bin/wiki?SqlMode

;;; Want to save you history between sessions? Consider adding this hook to
;;; your .emacs. It saves the history in a separate file for each SQL
;;; product. Youll need to run `M-x make-directory RET ~/.emacs.d/sql/ RET

	    (defun my-sql-save-history-hook ()
	      (let ((lval 'sql-input-ring-file-name)
		    (rval 'sql-product))
		(if (symbol-value rval)
		    (let ((filename
			   (concat (expand-file-name "sql/" EmacsInitDir)
				   (symbol-name (symbol-value rval))
				   "-history.sql")))
		      (set (make-local-variable lval) filename))
		  (error
		   (format "SQL history will not be saved because %s is nil"
			   (symbol-name rval))))))
	    (add-hook 'sql-interactive-mode-hook 'my-sql-save-history-hook)


	    ;; (defun sql-send-paragraph ()
	    ;;   "Send the current paragraph to the SQL process."
	    ;;   ;; mec simplified version that does not extend the PP befor
	    ;;    (interactive)

	    ;;    (setq paragraph-start "\s*$") ;blank lines demarcate 'paragraphs'
	    ;;                               ;(code blcoks).  this should be made
	    ;;                               ;buffer local !?!?

	    ;;    ;(forward-paragraph)
	    ;;    ;(push-mark nil t t)
	    ;;    ;(backward-paragraph)

	    ;;   (deactivate-mark)
	    ;;   (mark-paragraph nil -1)
	    ;;   (sql-send-region (point) (mark))
	    ;;   (exchange-point-and-mark)
	    ;;   )
	    ;;
	    ;; (defun sql-send-delimited-region ()
	    ;;  "Send the current delimited region to the SQL process."
	    ;;  ;; mec simplified version that does not extend the PP befor
	    ;;    (interactive)
	    ;;    (save-excursion
	    ;;      (sql-mark-delimited-region)
	    ;;      (sql-send-region (point) (mark))))


	    ;; (defun sql-mark-delimited-region ()
	    ;;  "Send the current delimited region to the SQL process."
	    ;;  ;; mec simplified version that does not extend the PP befor
	    ;;    (interactive)
	    ;;    (setq paragraph-start "\/\/$") ;blank lines demarcate 'paragraphs'
	    ;;                               ;(code blcoks).  this should be made
	    ;;                               ;buffer local !?!?

	    ;;    ;(forward-paragraph)
	    ;;    ;(push-mark nil t t)
	    ;;    ;(backward-paragraph)

	    ;;   (deactivate-mark)
	    ;;   (mark-paragraph nil -1)
	    ;;   (sql-send-region (point) (mark))
	    ;;   (exchange-point-and-mark)
	    ;;   )

	    ))

(use-package n3-mode :ensure t)
;(load-library "n3-mode") ;; it does not provide itself!?!

(use-package yaml-mode :ensure t
  :config (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
  )

(use-package lua-mode
;(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
  :config (progn
	  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
	  (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
	  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   ;;kudos:  http://www.emacswiki.org/emacs/TrampMode#toc14 
;; (defun find-alternative-file-with-sudo ()
;;   (interactive)
;;   (let ((fname (or buffer-file-name
;; 		   dired-directory)))
;;     (when fname
;;       (if (string-match "^/sudo:root@localhost:" fname)
;; 	  (setq fname (replace-regexp-in-string
;; 		       "^/sudo:root@localhost:" ""
;; 		       fname))
;; 	(setq fname (concat "/sudo:root@localhost:" fname)))
;;       (find-alternate-file fname))))
;; (define-key global-map [(control meta shift R)] 'find-alternative-file-with-sudo)

(defun sudo-edit-current-file ()
  (interactive)
  (defun prepare-tramp-sudo-string (tempfile)
    (if (file-remote-p tempfile)
	(let ((vec (tramp-dissect-file-name tempfile)))

	  (tramp-make-tramp-file-name
	   "sudo"
	   (tramp-file-name-user nil)
	   (tramp-file-name-host vec)
	   (tramp-file-name-localname vec)
	   (format "ssh:%s@%s|"
		   (tramp-file-name-user vec)
		   (tramp-file-name-host vec))))
      (concat "/sudo:root@localhost:" tempfile)))  (let ((my-file-name) ; fill this with the file to open
      (position))	   ; if the file is already open save position
    (if (equal major-mode 'dired-mode) ; test if we are in dired-mode 
        (progn
          (setq my-file-name (dired-get-file-for-visit))
          (find-alternate-file (prepare-tramp-sudo-string my-file-name)))
      (setq my-file-name (buffer-file-name) ; hopefully anything else is an already opened file
            position (point))
      (find-alternate-file (prepare-tramp-sudo-string my-file-name))
      (goto-char position))))

(define-key dired-mode-map [(shift return)] 'sudo-edit-current-file)
(define-key global-map [(control meta shift R)] 'sudo-edit-current-file)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (geiser ox-gfm ox-pandoc constants zenburn-theme yaml-mode use-package sx smart-mode-line projectile polymode paradox pandoc-mode ox-reveal org-tree-slide org-screenshot org-pdfview org-pandoc org-bullets org-ac n3-mode magit inf-ruby htmlize hc-zenburn-theme gist epresent enh-ruby-mode elpy ein-mumamo edit-server cask bbyac auto-install auto-compile async)))
 '(safe-local-variable-values
   (quote
    ((bug-reference-bug-regexp . "<https?://\\(debbugs\\|bugs\\)\\.gnu\\.org/\\([0-9]+\\)>")))))

(put 'downcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package projectile :ensure t
  :config (projectile-global-mode))

(use-package cask :ensure t)

(use-package elpy :ensure t
  ;; python: http://elpy.readthedocs.org/en/latest/index.html
  ;; https://github.com/jorgenschaefer/elpy http://elpy.readthedocs.org/en/latest/index.html
  :config (elpy-enable))

(use-package python
  ;; The package is "python" but the mode is "python-mode":
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package sx :ensure t
  ;; stack-exchange client in emacs
  )



(require 'ess-site)

(pdf-tools-install)

(eval-after-load 'org '(require 'org-pdfview))
(add-to-list 'org-file-apps '("\\.pdf\\'" . org-pdfview-open))
(add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . org-pdfview-open))



(setq ess-default-style 'DEFAULT)

;; (defvar EmacsInitDir (file-name-directory 
;; 		    (or load-file-name ; in case of loading during
;; 				       ; init, when it is set.
;; 			(buffer-file-name) ; in case of eval from within edit buffer.
;; 			)))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; where else to find required libraries...
;; ;;; strategy cobbled from http://www.emacswiki.org/emacs/LoadPath - 
;; (dolist (default-directory (mapcar (lambda(d) (expand-file-name d EmacsInitDir)) 
;; 				   (list "auto-install"
;; 					 "elpa" ;;"elisp"
;; 					 )))
;;   (setq load-path
;;         (append
;;          (let ((load-path (copy-sequence load-path))) ;; Shadow -
;; 						      ;; ensuring that
;; 						      ;; the loaded
;; 						      ;; paths are IN
;; 						      ;; FRONT OF
;; 						      ;; system paths
;;            (append 
;;             (copy-sequence (normal-top-level-add-to-load-path '(".")))
;;             (normal-top-level-add-subdirs-to-load-path)))
;;          load-path)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq load-prefer-newer t)	     ; don't load .elc if .el file is newer
;; ;;(paradox-require 'auto-compile)
;; (require 'auto-compile)
;; (auto-compile-on-save-mode)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'package)
;; (add-to-list 'package-archives '("org"   . "http://orgmode.org/elpa/") t)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;; (when (< emacs-major-version 24)
;;   ;; For important compatibility libraries like cl-lib
;;   (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
;; (package-initialize)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'paradox)			; a modern packages menu
;; (setq paradox-github-token '4347ac649c32dcae5730afbaeaabcead8ed23076)
;; (paradox-require 'smart-mode-line)
;; (paradox-require 'async)		; allowing asynchronous package installation, interalia
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (paradox-require 'auto-install)
;; (setq auto-install-save-confirm nil)	; just do it!
;; (auto-install-update-emacswiki-package-name t)
;; ;; Make auto-installed packages findable: 
;; (add-to-list 'load-path (expand-file-name auto-install-directory))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defmacro requireInst (feature &optional filename &rest installer)
;;   "require feature after intalling if not present, by default using package-install"
;;   (setq installer (or installer `((package-install ,feature))))
;;   `(unless (require ,feature ,filename t)
;;      ,@installer
;;      (require ,feature ,filename nil)
;;      ))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defun package-require (package)
;;   "Install a PACKAGE unless it is already installed 
;; or a feature with the same name is already active.

;; Usage: (package-require 'package)"
;;   ; try to activate the package with at least version 0.
;;   (package-activate package '(0))
;;   ; try to just require the package. Maybe the user has it in his local config
;;   (condition-case nil
;;       (require package)
;;     ; if we cannot require it, it does not exist, yet. So install it.
;;     (error (package-install package))))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (paradox-require 'gist)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (paradox-require 'tramp)
;; (setq
;;  tramp-default-method "ssh"
;;  ;; allowing these to work too:
;;  ;;/access.stowers.org:~/
;;  ;;/mec@:~/
;;  tramp-default-user "mec"
;;  ;;tramp-default-host "access.stowers.org"
;;  tramp-default-host "beta"
;;  )
;; ;;/ssh:mec@access.stowers.org:~/
;; ;;/mec@access.stowers.org:~/
;; ;;/mec@beta:~/
;; ;;
;; ;;not working - multihop syntax:
;; ;;/mec@access.stowers.org|mec@maple|mec@catalpa:~/

;; ;; works: c-x c-f 
;; ;; /ssh:mec@access.stowers.org|ssh:mec@maple|ssh:mec@catalpa:~/
;; ;; but not with ffap
;; ;;
;; ;;/mec@access.stowers.org:~/
;; ;;;ssh -v -L38080:localhost:38080 mec@access.stowers.org  -t ssh -v -L38080:localhost:38080 mec@maple -t ssh -v -L38080:localhost:8080 mec@bioinfo
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;(unless (server-running-p)
;; (server-start)
;; ;;)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'edit-server)		; for editting fields in chrome
;; (edit-server-start)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (paradox-require 'org)
;; (require 'ob-ruby)
;; ;;; ctrl+space does not work in emacs?
;; ;;; should get fixed.  For now:
;; ;;; > ibus exit
;; ;;; or > apt-get uninstall ibux-???
;; ;;; or xmodkeymap something
;; ;;; c.f. https://bugs.launchpad.net/ubuntu/+source/ibus/+bug/1278569
;; ;;(require 'org-compat)
;; (require 'ob-sh)
;; ;;(require 'ob-lua)
;; (require 'ob-sql)
;; (require 'ob-R)
;; (require 'ob-python)
;; ;; (require 'ob-dot)
;; ;; (require 'ob-screen)
;; (require 'ob-perl)
;; ;;(require 'ox-md)
;; (setq  org-confirm-babel-evaluate nil   ;don't require confirmation to
;;  ;;;eval code.
;;        org-babel-no-eval-on-ctrl-c-ctrl-c t ; But C-c C-v e will still
;;                                              ; do it (just don't make
;;                                              ; it soooo easy)
;;         org-use-speed-commands t
;;         org-src-preserve-indentation t ; The nil default is especially irksome in ESS.
;;         )
;; (setq org-return-follows-link t)
;; (setq org-tab-follows-link t)
;; (setq org-html-postamble nil ; 'auto
;;       org-latex-postamble nil)

;; (setq org-link-abbrev-alist
;;        '(("bugzilla" . "http://10.1.2.9/bugzilla/show_bug.cgi?id=")
;;          ("google"    . "http://www.google.com/search?q=") ;; [[google:OrgMode]]
 
;;          ("ads"    . "http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?author=%s&db_key=AST")
;;          ))
;; ;;;;;  
;; (setq  org-confirm-babel-evaluate nil   ;don't require confirmation to
;;  ;;;eval code.
;;        org-babel-no-eval-on-ctrl-c-ctrl-c t ; But C-c C-v e will still
;;                                              ; do it (just don't make
;;                                              ; it soooo easy)
;;         org-use-speed-commands t
;;         org-src-preserve-indentation t ; The nil default is especially irksome in ESS.
;;         )
;; (setq org-return-follows-link t)
;; (setq org-tab-follows-link t)
;; (setq org-log-done 'note) ;; time stamp TODOs when done and prompt for closing 'note'

;; (setq org-todo-keywords
;;       '((sequence "TODO(t)" "WAIT(w@/!)" "ONIT" "|" "DONE(d!)" "CANCELED(c@)" )))
;; (requireInst 'org-table-comment nil 
;; 	     ;;(auto-install-from-url "http://www.emacswiki.org/emacs/download/org-table-comment.el")
;; 	     (auto-install-from-emacswiki "org-table-comment.el")
;; )
;; ;;;(org-table-comment-mode)

;; (define-key org-mode-map "\C-c2" 'org-babel-demarcate-block)

;; (add-hook 'org-mode-hook #'flyspell-mode)
;; (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/2.5.0/");
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (paradox-require 'markdown-mode)
;; ;;wget -m http://www.emacswiki.org/emacs/download/org-table-comment.el
;; (paradox-require 'org-table-comment "http://www.emacswiki.org/emacs/download/org-table-comment.el")
;; (paradox-require 'polymode)		;; can work with both .Rmd and .org files
;; (require 'poly-org) ;; flaky? experimental? switch between modes
;; 		    ;; within .org file
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (paradox-require 'org-tree-slide)
;; (global-set-key (kbd "<f8>") 'org-tree-slide-mode)
;; (global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)

;; (auto-install-from-emacswiki "org-table-comment.el")


;; (paradox-require 'org-table-comment-mode)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (paradox-require 'ox-reveal)			; export org into nice html presentation's 
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (paradox-require 'ess-site)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; LOOK & FEEL
;; (define-key global-map [f2] 'accelerate-menu)
;; (define-key global-map [menux] 'accelerate-menu)
;; (define-key global-map [menu] 'accelerate-menu)

;; ;;; Removes gui elements ;;;;
;; (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))  ; no gui scrollbars
;; ;;(menu-bar-no-scroll-bar)
;; (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))      ; no toolbar!
;; ;;(if (fboundp 'menu-bar-mode) (menu-bar-mode 0))     ; no menubar - use f10 and tmm
;; ;;; SELECTION
;; (setq select-enable-primary t);  - default nil; set this to t if you want the Emacs commands C-w and C-y to use the primary selection.
;; (setq select-enable-clipboard t);- default t; set this to nil if you want the Emacs commands C-w and C-y to use the clipboard selection.
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; ARGH - delaing with the clipboard and X
;; ;; c.f. http://www.emacswiki.org/emacs/CopyAndPaste
;; ;;(setq x-select-enable-clipboard t)
;; (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;; (require 'mouse-copy)
;; (global-set-key [C-down-mouse-1] 'mouse-drag-secondary-pasting)
;; (global-set-key [C-S-down-mouse-1] 'mouse-drag-secondary-moving)
;; ;;; WINDOW NAVIGATION
;; (windmove-default-keybindings 'shift) ; which binds SHIFT-up/down/left/rignt to
;;                                ; switch emacs windows

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; MACINTOSH settings
;; (setq mac-option-modifier 'meta)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; provide Keep track of recently opened files
;; (require 'recentf)                      
;; (recentf-mode 1)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; MISC SETTINGS
;; (setq garbage-collection-messages t)    ; tell me when GC is happening

;; (setq frame-title-format
;;       (list (user-login-name) "@"  (shell-command-to-string "hostname -s")  "| %S@%S: %b"))
;; ;; Controls the title of the window-system window of the selected
;; ;; frame.  changed to include user-login-name and hostname (is there a
;; ;; better way to get this?)

;; (transient-mark-mode 1)  ;; always highlight region between point and mark
;;                          ;; (when active)

;; ;; Show column and row number in mode line
;; (column-number-mode t)
;; (line-number-mode t)

;; ;; When point is on paranthesis, highlight the matching one
;; (show-paren-mode t)

;; (setq indicate-empty-lines t) ;; Indicate empty lines at the end of buffer
;; (setq require-final-newline t) ;; Always end a file with a newline
;; (setq-default show-trailing-whitespace t) ;; Show trailing whitespace (usually a mistake)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;                  MISC KEYMAP BINDINGS
;; (define-key global-map [(f6)] 'prefix-region)
;; (define-key global-map [(meta space)] 'fixup-whitespace) ;;overriding just-one-space
;; (define-key global-map [(control x) (meta y)] 'bury-buffer)
;; (define-key global-map [(control x) (control F)] 'find-file-at-point)
;; (define-key global-map [(meta p)] 'fill-paragraph)
;; (define-key global-map [M-S-mouse-3] 'imenu)
;; (define-key global-map [menu] 'imenu)
;; (define-key global-map [(control c) (control c)] 'comment-region)
;; (define-key global-map [(control kp-1)] 'shell)
;; (define-key global-map [(control f11)] 'shell)
;; (define-key global-map [(control kp-2)] 'manual-entry)
;; (define-key global-map [(control f2)] 'manual-entry)
;; (define-key global-map [(control x) p] 'previous-multiframe-window)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; http://www.emacswiki.org/emacs/InsertingTodaysDate
;; (require 'calendar)
;; (calendar-set-date-style 'iso)          ;i.e. 2011-04-22
;; (defun insdate-insert-current-date (&optional omit-day-of-week-p)
;;   "Insert today's date using the current locale.
;;   With a prefix argument, the date is inserted without the day of
;;   the week."
;;   (interactive "P*")
;;   (insert (calendar-date-string (calendar-current-date) nil
;;                                 omit-day-of-week-p)))
;; (global-set-key "\C-x\M-;" `insdate-insert-current-date)
;; (define-key global-map 
;;   ;; [(control \;)] same binding as MS Excel.  Unfortunately since I
;;   ;; am now (2012-09-12) using flyspell, it is also bound to
;;   ;; flyspell-auto-correct-previous-word,
;;   [(control meta \;)] 
;;   'insdate-insert-current-date)

;; (setq explicit-shell-file-name "/bin/bash") ; from shell.el
;; (setq scroll-conservatively 10)

;; (unless window-system
;;   (xterm-mouse-mode t)
;;   )

;; ;;(paradox-require 'zenburn-theme)
;; (paradox-require 'hc-zenburn-theme)
;; (blink-cursor-mode)
;; ;;; COMPLETION
;; ;(paradox-require 'bbyac)		; looks cool - VERY flexy completion
;; ;(bbyac-global-mode 0)
;; ;;; yasnippet should be loaded before auto complete so that they can
;; ;;; work together
;; (paradox-require 'yasnippet)
;; (yas-global-mode 1)
;; ;; yas-snippet-dirs
;; ;; yas-installed-snippets-dir
;; ;; ~/.emacs.d/elpa/yasnippet-20150212.240/snippets/
;; ;;;
;; (require 'auto-complete-config)
;; (require 'auto-complete)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;; (ac-config-default)
;; ;;; set the trigger key so that it can work together with yasnippet on tab key,
;; ;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;; ;;; activate, otherwise, auto-complete will
;; (ac-set-trigger-key "TAB")
;; (ac-set-trigger-key "<tab>")
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; host specific
;; (setq printer-name 'PB020502)  ;- The name of a local printer to which
;;                                ;;data is sent for printing.
;; (setq lpr-switches '("-PB020502"))

;; ;;(setq lpr-switches '(???))

;; (require 'printing)
;; (pr-update-menus t); make sure we use localhost as cups server
;; (setenv "CUPS_SERVER" "localhost")
;; ;;(package-require 'cups)			; from marmlade
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; key bindings
;; (define-key global-map (kbd "C-`") 'other-frame)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (setq desktop-files-not-to-save nil
;;       ;; default value skips tramp/ftp buffers.
;;       )
;; (setq split-height-threshold 0)
;; (setq split-width-threshold 0)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Show which function the cursor is in.
;; (which-function-mode t)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (paradox-require 'enh-ruby-mode)
;; (add-hook 'enh-ruby-mode-hook 'robe-mode)
;; (add-hook 'enh-ruby-mode-hook 'yard-mode)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq user-mail-address "malcolm.cook@gmail.com")
;; (setq user-full-name "Malcolm Cook")
;; ;; (setq smtpmail-smtp-server "your.smtp.server.jp")
;; ;; (setq mail-user-agent 'message-user-agent)
;; ;; (setq message-send-mail-function 'message-smtpmail-send-it)








;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;                             cperl-mode
;; ; Tell Emacs that CPerlMode should be used instead of
;; ; PerlMode. Whenever perl-mode would normally be used cperl-mode is
;; ; used instead.
;; (defalias 'perl-mode 'cperl-mode)       
;; ;;http://search-dev.develooper.com/~nwclark/perl-5.8.6/emacs/cperl-mode.el
;; (require 'cperl-mode)
;; (cperl-set-style 'CPerl)

;; ;;hacked by mec to add -t to Manual-switches
;; (defun cperl-perldoc (word)
;;   "Run `perldoc' on WORD."
;;   (interactive
;;    (list (let* ((default-entry (cperl-word-at-point))
;;                 (input (read-string
;;                         (format "perldoc entry%s: "
;;                                 (if (string= default-entry "")
;;                                     ""
;;                                   (format " (default %s)" default-entry))))))
;;            (if (string= input "")
;;                (if (string= default-entry "")
;;                    (error "No perldoc args given")
;;                  default-entry)
;;              input))))
;;   (require 'man)
;;   (let* ((is-func (and
;;                    (string-match "^[a-z]+$" word)
;;                    (string-match (concat "^" word "\\>")
;;                                  (documentation-property
;;                                   'cperl-short-docs
;;                                   'variable-documentation))))
;;          (manual-program (if is-func "perldoc -f" "perldoc")))
;;     (cond
;;      (nil ;;cperl-xemacs-p
;;       (let ((Manual-program "perldoc")
;;             (Manual-switches (if is-func (list  "-t" "-f" ) (list   "-t"  ))))
;;         ;;(setq Manual-switches (cons "-m" Manual-switches))
;;         (manual-entry word)))
;;      (t
;;       (Man-getpage-in-background word)))))



;; ;(defun cperl-pod-to-manpage ()
;; ;  "Create a virtual manpage in Emacs from the Perl Online Documentation."
;; ;  (interactive)
;; ;  (require 'man)
;; ;  (asdf)
;; ;  (let* ((pod2man-args (concat buffer-file-name " | nroff c -man "))
;; ;        (bufname (concat "Man " buffer-file-name))
;; ;        (buffer (generate-new-buffer bufname)))
;; ;    (save-excursion
;; ;      (set-buffer buffer)
;; ;      (let ((process-environment (copy-sequence process-environment)))
;; ;        ;; Prevent any attempt to use display terminal fanciness.
;; ;;;        (setenv "TERM" "dumb")
;; ;        (set-process-sentinel
;; ;         (start-process pod2man-program buffer "sh" "-c"
;; ;                        (format (cperl-pod2man-build-command) pod2man-args))
;; ;         'Man-bgproc-sentinel)))))

;; ;(defun cperl-perldoc (word)
;; ;  "Run `perldoc' on WORD."
;; ;  (interactive
;; ;   (list (let* ((default-entry (cperl-word-at-point))
;; ;                (input (read-string
;; ;                        (format "perldoc entry%s: "
;; ;                                (if (string= default-entry "")
;; ;                                    ""
;; ;                                  (format " (default %s)" default-entry))))))
;; ;           (if (string= input "")
;; ;               (if (string= default-entry "")
;; ;                   (error "No perldoc args given")
;; ;                 default-entry)
;; ;             input))))
;; ;  (require 'man)
;; ;  (let* ((is-func (and
;; ;                  (string-match "^[a-z]+$" word)
;; ;                  (string-match (concat "^" word "\\>")
;; ;                                (documentation-property
;; ;                                 'cperl-short-docs
;; ;                                 'variable-documentation))))
;; ;        (manual-program (if is-func "perldoc -f" "perldoc -t")))
;; ;    (cond
;; ;     (cperl-xemacs-p
;; ;      (let ((Manual-program "perldoc")
;; ;            (Manual-switches (if is-func (list "-f"))))
;; ;        (manual-entry word)))
;; ;     (t
;; ;      (Man-getpage-in-background word)))))

;; (setq cperl-hairy t)
;; ;;(define-key cperl-mode-map [delete] 'delete-char)
;; ;;(define-key cperl-mode-map [(control x) p] 'cperl-fill-paragraph)
;; (define-key cperl-mode-map [(meta p)] 'cperl-fill-paragraph)
;; (define-key cperl-mode-map [(control c) (control c)] 'cperl-comment-region)

;; ;;;(define-key cperl-mode-map [(control c) (control h) f] 'cperl-perldoc) ;override info system which we don't have files for
;; (define-key global-map [(control shift kp-2)] 'cperl-perldoc)
;; (define-key global-map [(control  f8)] 'cperl-perldoc)
;; ;(define-key global-map [(control shift 8)] 'cperl-perldoc)
;; ;(define-key global-map [(control shift 8)] 'cperl-perldoc)
;; (define-key global-map [(control kp-8)] 'cperl-perldoc)
;; (define-key global-map [(control h) d] 'cperl-perldoc)
;; (define-key global-map [(control shift f2)] 'cperl-perldoc)

;; (define-key cperl-mode-map "\C-cy" 'cperl-check-syntax)

;; (setq fill-column 78)
;; ;(setq auto-fill-mode t)

;; ;;;when you want to look at the documentation:
;; ;;;perldoc  AnotherModule (e.g. perldoc Bio::Seq)
;; ;;;when you want to see the actual code in the module:
;; ;;;perldoc -m AnotherModule
;; ;;;when you want to know where the file is:
;; ;;;perldoc -l AnotherModule

;; ;(defun my-cperl-ffap-locate(name)
;; ;  "Return cperl module for ffap"
;; ;  (let* ((r (replace-regexp-in-string ":" "/" (file-name-sans-extension name)))
;; ;        (e (replace-regexp-in-string "//" "/" r))
;; ;        (x (ffap-locate-file e '(".pm" ".pl" ".xs")
;; ;                             (append (ffap-all-subdirs-loop "/usr/lib/perl5/site_perl/5.8.5/" -1)
;; ;                                     (ffap-all-subdirs-loop "/usr/local/lib/perl5/site_perl/5.8.5/" -1)))))
;; ;    x
;; ;    )
;; ;  )

;; ;(add-to-list 'ffap-alist  '(cperl-mode . my-cperl-ffap-locate))

;; ;;;;;;;;
;; ;;; ffap
;; ;(setq ffap-machine-p-known 'accept)
;; ;(ffap-bindings)

;; ;;;;;;;;;;;;;;

;; (defun my-cperl-eldoc-documentation-function ()
;;   "Return meaningful doc string for `eldoc-mode'."
;;   (car
;;    (let ((cperl-message-on-help-error t))
;;      (cperl-get-help))))

;; (add-hook
;;  'cperl-mode-hook
;;  (lambda ()
;;    (set (make-local-variable 'eldoc-documentation-function)
;;         'my-cperl-eldoc-documentation-function)))

;; (setq eldoc-idle-delay  0.0)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;From Perl Hacks: #7
;; (defmacro mark-active ()
;;   "Xemacs/emacs compatibility macro"
;;   (if (boundp 'mark-active)
;;       'mark-active
;;     '(mark)))

;; (defun perltidy ()
;;   "Run perltidy on tyhe current region or buffer."
;;   (interactive)
;;                                         ; Inexpplicably, save-excurtion doesn['t work here
;;   (let ((orig-point (point)))
;;     (unless (mark-active) (mark-defun))
;;     (shell-command-on-region (point) (mark) "perltidy -q" nil t)
;;     (goto-char orig-point)))
;; (global-set-key "\C-ct" 'perltidy)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;From Perl Hacks: #10 Run Tests from within emacs
;; (eval-after-load "cperl-mode"
;;   '(add-hook 'cperl-mode-hook (lambda () (local-set-key "\C-cp" 'cperl-prove))))
;; (defun cperl-prove ()
;;   "Run the current test."
;;   (interactive)
;;   (shell-command (concat "prove -v " (shell-quote-argument (buffer-file-name)))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;From Perl Hacks: #5 Autocomplete Perl Identifiers - however cperl-indent-or-complete
;; (defadvice cperl-indent-command
;;   (around cperl-indent-command)
;;   "Changes \\[cpers-indent-command] so it autocompletes when at the end of a word."
;;   (if (looking-at "\\>") (dabbrev-expand nil) ad-do-it)
;;   (eval-after-load "cperl-mode" '(progn (require 'dabbrev) (ad-activate 'cperl-indent-command))))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;From Perl Hacks: 11 Run Perl from emacs
;; (defun perl-eval (beg end)
;;   "Run selected region as Perl code"
;;   (interactive "r")
;;   (shell-command-on-region beg end "perl \"-\"") ;note- this is NOT the hack in the book!
;;                                         ; feeds the regino to perl on STDIN
;;   )
;; (global-set-key "\M-\C-p" 'perl-eval)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (global-font-lock-mode 1)         ; make pretty color fonts default

;; ;;;(turn-on-font-lock)


;; ;;;(require 'PerlySense) ;from my local xemacs/lisp - c.r. http://search.cpan.org/~johanl/Devel-PerlySense-0.0147/lib/Devel/PerlySense.pm

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;                     SQL MODE CONFIGURATION

;; (require 'sql)
;; (add-to-list 'auto-mode-alist  '("\\.\\(sql\\)" . sql-mode))

;; (setq

;;  sql-mysql-program "mysql"
;;  sql-mysql-options ""                   ;hmmm...

;;  sql-ms-program "sqsh"
;;  sql-sybase-program "sqsh"

;;                                         ;sql-user "mec"                 ;what is default
;;                                         ;sql-password ""                ;relying upon ~/.my.cnf
;;  sql-database ""                        ; "mysql"               ;fair default
;;  sql-server ""                   ; "mysql-dev"          ;could be localhost

;;                                         ;   sql-mode-postgres-font-lock-keywords - Postgres SQL keywords used by font-lock.
;;                                         ; * sql-postgres-options           (quote "-u") - List of additional options for `sql-postgres-program'.
;;                                         ;   sql-postgres-program           - Command to start psql by Postgres.


;;  )

;; (setq

;;    sql-user ""                          ;what is default
;;    sql-password ""                      ;relying upon ~/.my.cnf
;;    sql-database ""                      ;fair default
;;    sql-server ""                        ;could be localhost
;;    ;;sql-user "mec"                     ;what is default
;;    ;;sql-password ""            ;relying upon ~/.my.cnf
;;    ;;   sql-database "mysql"            ;fair default
;;    ;;   sql-server "devel01"            ;could be localhost
;;    )

;; (defun do-sql-mysql ()
;;   (interactive)                         ; "D")

;;   (sql-mysql)
;;   ;;(sqli-rename-buffer)
;;   (sql-set-sqli-buffer)
;;   )

;; (defun do-sql-sybase ()
;;   (interactive)                         ; "D")
;;   (setq
;;    ;;sql-user "SIMR01\\mec"                     ;what is default
;;    sql-user "sa"                        ;what is default
;;    ;;sql-password ""            ;relying upon network authentication?
;;    ;;sql-database "SILO"                        ;fair default
;;    sql-database "aquatics"                      ;fair default
;;    sql-server "SQLDEV01"                ;could be localhost or SQLKC01 or SQLDEV01
;;    )
;;   (sql-sybase))

;; (defun do-sql-postgres ()
;;   (interactive)                         ; "D")
;;   (setq   sql-user "flybase"            
;;           sql-password ""               ;relying upon ~/.my.cnf
;;           sql-database "flybase"        ;blastgres? mec?
;;           sql-server "flybase.org"      ;postgresql-dev
;;           )

;;   (setq   sql-user "astoria"            
;;           sql-password "astoria"                ;relying upon ~/.my.cnf
;;           sql-database "astoria"        ;blastgres? mec?
;;           sql-server "postgresqlkc01"   ;       ;postgresql-dev
;;           )

;;   (sql-postgres)
;;   ;;  (rename-buffer "flybase@flybase.org")
;;   )


;; (define-key global-map [(control kp-4)] 'do-sql-mysql)
;; (define-key global-map [(control f4)] 'do-sql-mysql)
;;                                         ;(define-key global-map [C-f4] 'do-sql-mysql)
;; (define-key global-map [(control kp-5)] 'do-sql-sybase)
;; (define-key global-map [(control kp-6)] 'do-sql-postgres)
;; (define-key global-map [(control f6)] 'do-sql-postgres)

;; (defun prefix-region-tab ()
;;   ""
;;   (interactive) 
;;   (prefix-region "\t"))
;; (define-key global-map [(control meta tab)] ' prefix-region-tab)

;; (define-key global-map [(control c) (control d) ] 'sql-send-delimiter)
;; (defun sql-send-delimiter ()
;;   "really of use only to mysql when we need to send the extra delimiter which I have set to '//'"
;;   (interactive)
;;   (comint-send-string sql-buffer "//\n")
;;   )

;;                                         ; sql-set-sqli-buffer.
;;                                         ;  C-c C-b                      sql-send-buffer
;;                                         ;  C-c C-c                      sql-send-paragraph
;;                                         ;  C-c C-r                      sql-send-region

;;                                         ;#If you want to make SQL buffers limited in length, add the function
;;                                         ;#`comint-truncate-buffer' to `comint-output-filter-functions'.
;;                                         ;#Here is an example for your .emacs file.  It keeps the SQLi buffer a
;;                                         ;#certain length.

;; (setq sql-interactive-mode-hook nil)

;;                                         ;(add-hook 'sql-interactive-mode-hook
;;                                         ;    (function (lambda ()
;;                                         ;        (setq comint-output-filter-functions
;;                                         ;             '(
;;                                         ;               comint-truncate-buffer ;;keeps the SQLi buffer a certain length.
;;                                         ;               (function (lambda (STR) (comint-show-output)))
;;                                         ;               ;; point back to the statement you entered, right
;;                                         ;               ;; above the output it created.
;;                                         ;               )))))

;; ;;; following from http://www.emacswiki.org/cgi-bin/wiki?SqlMode

;; ;;; Want to save you history between sessions? Consider adding this hook to
;; ;;; your .emacs. It saves the history in a separate file for each SQL
;; ;;; product. Youll need to run `M-x make-directory RET ~/.emacs.d/sql/ RET

;; (defun my-sql-save-history-hook ()
;;   (let ((lval 'sql-input-ring-file-name)
;;         (rval 'sql-product))
;;     (if (symbol-value rval)
;;         (let ((filename
;;                (concat (expand-file-name "sql/" EmacsInitDir)
;;                        (symbol-name (symbol-value rval))
;;                        "-history.sql")))
;;           (set (make-local-variable lval) filename))
;;       (error
;;        (format "SQL history will not be saved because %s is nil"
;;                (symbol-name rval))))))
;; (add-hook 'sql-interactive-mode-hook 'my-sql-save-history-hook)


;; ;; (defun sql-send-paragraph ()
;; ;;   "Send the current paragraph to the SQL process."
;; ;;   ;; mec simplified version that does not extend the PP befor
;; ;;    (interactive)

;; ;;    (setq paragraph-start "\s*$") ;blank lines demarcate 'paragraphs'
;; ;;                               ;(code blcoks).  this should be made
;; ;;                               ;buffer local !?!?

;; ;;    ;(forward-paragraph)
;; ;;    ;(push-mark nil t t)
;; ;;    ;(backward-paragraph)

;; ;;   (deactivate-mark)
;; ;;   (mark-paragraph nil -1)
;; ;;   (sql-send-region (point) (mark))
;; ;;   (exchange-point-and-mark)
;; ;;   )
;; ;;
;; ;; (defun sql-send-delimited-region ()
;; ;;  "Send the current delimited region to the SQL process."
;; ;;  ;; mec simplified version that does not extend the PP befor
;; ;;    (interactive)
;; ;;    (save-excursion
;; ;;      (sql-mark-delimited-region)
;; ;;      (sql-send-region (point) (mark))))


;; ;; (defun sql-mark-delimited-region ()
;; ;;  "Send the current delimited region to the SQL process."
;; ;;  ;; mec simplified version that does not extend the PP befor
;; ;;    (interactive)
;; ;;    (setq paragraph-start "\/\/$") ;blank lines demarcate 'paragraphs'
;; ;;                               ;(code blcoks).  this should be made
;; ;;                               ;buffer local !?!?

;; ;;    ;(forward-paragraph)
;; ;;    ;(push-mark nil t t)
;; ;;    ;(backward-paragraph)

;; ;;   (deactivate-mark)
;; ;;   (mark-paragraph nil -1)
;; ;;   (sql-send-region (point) (mark))
;; ;;   (exchange-point-and-mark)
;; ;;   )




;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; MARKDOWN MODE
;; ;;; c.f. http://jblevins.org/projects/markdown-mode/
;; ;;; wget http://jblevins.org/git/markdown-mode.git/plain/markdown-mode.el
;; ;; (requireInst 
;; ;;  'markdown-mode nil 
;; ;;  (auto-install-from-url "http://jblevins.org/git/markdown-mode.git/plain/markdown-mode.el")
;; ;; )


;; ;; moving to polymode?
;; ;; (requireInst 
;; ;;  'markdown-mode nil 
;; ;;  (auto-install-from-url "http://jblevins.org/git/markdown-mode.git/plain/markdown-mode.el"))
;; (autoload 'markdown-mode "markdown-mode"
;;   "Major mode for editing Markdown files" t)
;; ;; (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
;; ;; (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
;; ;; (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;; ;; (add-to-list 'auto-mode-alist '("\\.Rmd\\'" . markdown-mode))

;; ;;(define-key polymode-mode-map [(meta n) (r)] 'rmarkdown-render)
;; ;;(define-key markdown-mode-map [(control c) (control c) (r)] 'rmarkdown-render)

;; (require 'markdown-mode)		; so I can add keymap entrys.
;; (define-key markdown-mode-map  (kbd "C-c C-c r") 'rmarkdown-render)
;; ;;(define-key markdown-mode-map (kbd "C-c C-c r") 'rmarkdown-render)
;; ;;(define-key map "\C-c\C-al" 'markdown-insert-link)

;; ;;(setq markdown-css-path

;; ;; *.Rmd files invoke r-mode                    ; Temporary fix for R markdown files
;; ;(add-to-list 'auto-mode-alist '("\\.Rmd$" . r-mode))
;; ; commented while trying out:

;; (require 'polymode)
;; (require 'poly-R)
;; (require 'poly-markdown)
;; (require 'poly-noweb)
;; ;;(require 'poly-org)


;; (define-key polymode-mode-map [(meta n) (r)] 'rmarkdown-render)
;; ;;(define-key polymode-mode-map [(r)] 'self-insert-command)

;; (defun rmarkdown-render ()
;;   "run rmarkdown::render() on the current file and display results in buffer *Shell Command Output*"
;;   (interactive)
;;   (let ((render-command (read-string "render command:" 
;; 									 (format "render('%s',%s);"
;; 											 (shell-quote-argument (buffer-file-name))
;; 											 "'all'"
;; 											 ))))
;;     (shell-command
;;      (message
;; 	  "Rscript -e \"withCallingHandlers({library(rmarkdown); library(pander); %s}, error = function(e) {print(sys.calls())})\"" ;;print(sessionInfo())
;; 										;"Rscript -e \"withCallingHandlers({library(rmarkdown); library(pander); %s}, error = function(e) print(sys.calls()))\""
;;       render-command
;;       )
;; 	 "*rmarkdown::render standard output*"
;; 	 ;;"*rmarkdown::render error output*"
;; )
;;     ))

;; (if nil (require 'polymode-configuration)
;;   ;; else, choose suits your needs and place into your .emacs file.
;; ;;; MARKDOWN
;; ;;  (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
;; ;;; ORG
;; ;;;    (add-to-list 'auto-mode-alist '("\\.org" . poly-org-mode))
;; ;;; R related modes
;;   (add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
;;   (add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
;;   (add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
;;   (add-to-list 'auto-mode-alist '("\\.rapport" . poly-rapport-mode))
;;   (add-to-list 'auto-mode-alist '("\\.Rhtml" . poly-html+r-mode))
;;   (add-to-list 'auto-mode-alist '("\\.Rbrew" . poly-brew+r-mode))
;;   (add-to-list 'auto-mode-alist '("\\.Rcpp" . poly-r+c++-mode))
;;   (add-to-list 'auto-mode-alist '("\\.cppR" . poly-c++r-mode))
;;   (provide 'polymode-configuration))


;;   ;;; c.f. http://sjp.co.nz/posts/emacs-ess-knitr/ " Note: The latest version of ESS now includes support for knitr. This script is no longer necessary.

;; ;;(ess-swv-knit)
;; 					;(add-to-list 'load-path 
;; 					;	     "/n/local/stage/r/R-3.0.2/install/lib64/R/library/pander"
;; 					;	     ;; system.file('pander.el', package='pander'
;; 					;)
;; 					;(require 'pander)
;; 					;(add-hook 'markdown-mode-hook 'pander-mode)

;; ;n  )

;; ;;(setq markdown-mode-hook nil)
;; (add-hook 'markdown-mode-hook 'pandoc-mode)

;; (add-hook 'markdown-mode-hook 'turn-on-orgtbl)
;; ;;(add-hook 'markdown-mode-hook 'orgtbl-mode)

;; ;;(turn-on-orgtbl)

;; ;; I like this but there are clashes - i.e. orgtbl ctrl-c ctrl-c
;; ;; shadows markdown utility commands which I miss , esp those for
;; ;; promotion and demotion out headers


;; ;;(add-hook 'markdown-mode-hook 'orgstruct-mode)
;; ;;(add-hook 'markdown-mode-hook 'orgstruct++-mode)

;; (add-hook 'pandoc-mode-hook
;; 	  ;; checks if a default settings file exists for the file
;; 	  ;; being loaded and reads its settings if it finds one.
;; 	  'pandoc-load-default-settings)

;; (setq ess-default-style 'DEFAULT)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (load-library "n3-mode") ;; it does not provide itself!?!
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (paradox-require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
;; (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
;; (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;   ;;kudos:  http://www.emacswiki.org/emacs/TrampMode#toc14 
;; ;; (defun find-alternative-file-with-sudo ()
;; ;;   (interactive)
;; ;;   (let ((fname (or buffer-file-name
;; ;; 		   dired-directory)))
;; ;;     (when fname
;; ;;       (if (string-match "^/sudo:root@localhost:" fname)
;; ;; 	  (setq fname (replace-regexp-in-string
;; ;; 		       "^/sudo:root@localhost:" ""
;; ;; 		       fname))
;; ;; 	(setq fname (concat "/sudo:root@localhost:" fname)))
;; ;;       (find-alternate-file fname))))
;; ;; (define-key global-map [(control meta shift R)] 'find-alternative-file-with-sudo)

;; (defun sudo-edit-current-file ()
;;   (interactive)
;;   (defun prepare-tramp-sudo-string (tempfile)
;;     (if (file-remote-p tempfile)
;; 	(let ((vec (tramp-dissect-file-name tempfile)))

;; 	  (tramp-make-tramp-file-name
;; 	   "sudo"
;; 	   (tramp-file-name-user nil)
;; 	   (tramp-file-name-host vec)
;; 	   (tramp-file-name-localname vec)
;; 	   (format "ssh:%s@%s|"
;; 		   (tramp-file-name-user vec)
;; 		   (tramp-file-name-host vec))))
;;       (concat "/sudo:root@localhost:" tempfile)))  (let ((my-file-name) ; fill this with the file to open
;;       (position))	   ; if the file is already open save position
;;     (if (equal major-mode 'dired-mode) ; test if we are in dired-mode 
;;         (progn
;;           (setq my-file-name (dired-get-file-for-visit))
;;           (find-alternate-file (prepare-tramp-sudo-string my-file-name)))
;;       (setq my-file-name (buffer-file-name) ; hopefully anything else is an already opened file
;;             position (point))
;;       (find-alternate-file (prepare-tramp-sudo-string my-file-name))
;;       (goto-char position))))

;; (define-key dired-mode-map [(shift return)] 'sudo-edit-current-file)
;; (define-key global-map [(control meta shift R)] 'sudo-edit-current-file)





;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(package-selected-packages
;;    (quote
;;     (org-table-comment-mode zenburn-theme yasnippet yaml-mode smart-mode-line polymode paradox ox-reveal org-tree-slide org-screenshot org-pdfview org-pandoc org-bullets org-ac markdown-mode inf-ruby htmlize hc-zenburn-theme gist epresent enh-ruby-mode edit-server bbyac auto-install auto-compile async))))

;; (put 'downcase-region 'disabled nil)
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )







