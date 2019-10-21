;;; init.el --- user init file      -*- no-byte-compile: t -*-
 
;;; TODO: consider move to https://github.com/raxod502/straight.el -
;;; straight.el: next-generation, purely functional package manager
;;; for the Emacs hacker.

(setq debug-on-error t) ;;
(setq stack-trace-on-error t);; '(buffer-read-only))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PACKAGE SYTEM INIT
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/")) ; which includes ox-pandoc use-package and ess inter-alia
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/")) ; (formerly?) for org-plus-contrib
;;;(add-to-list ' package-archives '("gnu" . "https://elpa.gnu.org/packages/")) ;; this is the default
;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;;(require 'package)
(package-initialize)
(eval-when-compile
  (unless (package-installed-p 'use-package)
    ;; Bootstrap `use-package'
    (package-refresh-contents)
    (package-install 'use-package))
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  ;;(add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))
;;(require 'use-package)o

(use-package quelpa)
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://framagit.org/steckerhalter/quelpa-use-package.git"))

(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://framagit.org/steckerhalter/quelpa-use-package.git"))

(require 'quelpa-use-package)

(setq use-package-always-ensure
      ;; t ;; maybe/seems to get in way of  :ensure org-plus-contrib
      'quelpa)

(if t
    (use-package auto-package-update
      ;; per advice: https://emacs.stackexchange.com/questions/31872/how-to-update-packages-installed-with-use-package/31904#31904
      :ensure t
      :config
      (setq auto-package-update-delete-old-versions t
            auto-package-update-interval 1)
      (auto-package-update-maybe))
  )



;; (use-package company
;;   ;; used for emacs completeion in ESS 
;;   :ensure t)
;; (use-package ido
;;   ;; used for emacs completeion in ESS 
;;   :ensure t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ess
  :ensure t
  :config (progn (require 'ess-site)
		 ;; add whatever else you like here to run after ess
		 ;; mode is loaded:
		 (setq ess-default-style 'DEFAULT) ; which I prefer over RRR settings
		 (setq ess-eval-visibly t)
		 ))

;; ;; start auto-complete with emacs
;; (use-package auto-complete)
;; ;; do default config for auto-complete
;; (require 'auto-complete-config)
;; (ac-config-default)
;; (setq ac-delay 0.1)       
;; (setq ac-auto-show-menu 0.2)
;; (setq ac-quick-help-delay 0.2)
;; (setq ac-quick-help-height 10)
;; (setq ac-candidate-limit 100)

(use-package  org ;org-plus-contrib			; instead of org-mode
  ;;org
  :ensure org-plus-contrib ; following http://emacs.stackexchange.com/questions/7890/org-plus-contrib-and-org-with-require-or-use-package
					;  :bind (("C-c l" . org-store-link))
  :config  (progn
	     (setq org-element-use-cache nil)
	     ;;"the cache can become corrupted upon modifying outline structure
	     ;;of a document. Unfortunately, I couldn't come with a small
	     ;;enough recipe to reproduce the exact problem. You could try to
	     ;;set `org-element-use-cache' to nil and see if the hangs
	     ;;disappear.

;;; PUT YOUR OTHER ORG MODE CUSTOMIZATIONS HERE.  THEY MAY BE DIFFERENT FROM MINE!
	     (setq org-default-notes-file "~/NOTES.org") ; instead of "~/notes" (which lacks an .org extension)
	     (define-key global-map "\C-cc" 'org-capture) ; TODO? use bind:

	     (setq  org-confirm-babel-evaluate nil ;don't require confirmation to
;;;eval code.
		    org-babel-no-eval-on-ctrl-c-ctrl-c t ; But C-c C-v e will still
					; do it (just don't make
					; it soooo easy)
		    org-use-speed-commands t
		    ;;;;org-edit-src-content-indentation 0 ; don't indent org source blocks
		    ;;;;org-src-preserve-indentation t ; The nil default is especially irksome in ESS.
		    )
	     (setq org-return-follows-link t)
	     (setq org-tab-follows-link t)
	     (setq org-html-postamble nil ; 'auto
		   org-latex-postamble nil)
	     (use-package org-pdfview
	       :ensure t
	       :config (progn 
			 (add-to-list 'org-file-apps '("\\.pdf\\'" . (lambda(file link) (org-pdfview-open link))))
			 (add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . (lambda(file link) (org-pdfview-open link))))))
	     ;;(use-package org-screenshot)
	     (use-package org-attach-screenshot :bind (("<C-print>" .  org-attach-screenshot)))
	     (setq org-html-allow-name-attribute-in-anchors t)
	     
	     (setq org-html-doctype "html5")
	     ;;(use-package ox-ruby )
	     ;;;;(use-package ox-twbs )	; twitter-bootstrap compat
	     (use-package ox-pandoc
	       :config  (progn
			  (setq org-pandoc-options '((standalone . t)))
			  ;; cancel above settings only for 'docx' format
			  (setq org-pandoc-options-for-docx '((standalone . nil)))
			  ;; special settings for beamer-pdf and latex-pdf exporters
			  (setq org-pandoc-options-for-beamer-pdf '((pdf-engine . "xelatex")))
			  (setq org-pandoc-options-for-latex-pdf '((pdf-engine . "xelatex")))
			  ))
	     ;; ctrl+space does not work in emacs?
	     ;; should get fixed.  For now:
	     ;; > ibus exit
	     ;; or > apt-get uninstall ibux-???
	     ;; or xmodkeymap something
	     ;; c.f. https://bugs.launchpad.net/ubuntu/+source/ibus/+bug/1278569
	     ;;(use-package org-compat)
	     (require 'ob-shell)
	     ;;(require 'ob-ditaa)
	     ;;(use-package ob-sh )
	     ;;(use-package ob-lua)
	     (use-package   lorem-ipsum :ensure t)
	     (require 'ob-R)
	     ;;;;(require 'ob-ruby)
					;(require 'org-ruby)
	     ;;(require 'inf-ruby)
	     ;;(use-package ob-python )
	     ;; (use-package ob-dot)
	     ;; (use-package ob-screen)
	     (require 'ob-perl)
	     (require 'ob-org)

	     (add-to-list 'org-latex-packages-alist '("" "minted"))
	     ;; Tell the latex export to use the minted package for source
	     ;; code coloration.
	     (setq org-latex-listings 'minted)
	     ;; Let the exporter use the -shell-escape option to let latex
	     ;; execute external programs.
	     ;; This obviously and can be dangerous to activate!
	     (setq org-latex-pdf-process
	     	   '(
		     ;;"latex -interaction nonstopmode -output-directory %o %f" "%latex -interaction nonstopmode -output-directory %o %f" "%latex -interaction nonstopmode -output-directory %o %f"
		     "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
		     )
		   )
	     (setq org-link-abbrev-alist
		   '(("bugzilla" . "http://10.1.2.9/bugzilla/show_bug.cgi?id=")
		     ("google"    . "http://www.google.com/search?q=") ;; [[google:OrgMode]]
		     ("ads"    . "http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?author=%s&db_key=AST")
		     ("servicenow"    . "https://stowers.service-now.com/task.do?sys_id=%s")
		     ("bioinfo" . "http://bioinfo%s")
		     ))


	     (setq org-log-done nil) ;; 'note => stamp TODOs when done and prompt for closing 'note'
	     
	     (setq org-todo-keywords
		   ;;'((sequence "IDEA" "TODO(t)" "WAIT(w@/!)" "ONIT" "|" "DONE(d!)" "DROP(c@)" ))
		   ;;'((sequence "TODO(t)" "WAIT(w@/)" "ONIT" "|" "DONE(d)" "DROP(c@)" ))
		   ;;
		   ;; DON'T USE TIMESTAMPS OR NOTES AT ALL and use (4
		   ;; letter) VOID instead of DROP.  Also
		   ;; considered: scrap, recant, drop, cancel...
		   '((sequence "IDEA(i)" "TODO(t)" "WAIT(w)" "ONIT(o)" "EVAL(e)" "|" "DONE(d)" "DROP(r)" ))
		   )
	     (define-key org-mode-map "\C-c2" 'org-babel-demarcate-block)
	     (define-key global-map "\C-c2" 'org-babel-demarcate-block)

	     ;; (add-hook 'org-mode-hook #'flyspell-mode) ;; slows things?
	     ;; (use-package ox-reveal
	     ;;  error in emacs 24!?!?
	     ;;   ;; export org into nice html presentation's 
	     ;;   :config (progn
	     ;; 		(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/2.5.0/")
	     ;; 		))
	     (use-package org-tree-slide ; NB -
	       :config (progn 
			 (global-set-key (kbd "<f8>") 'org-tree-slide-mode)
			 (global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)
			 (define-key org-tree-slide-mode-map  "left" 'org-tree-slide-move-previous-tree)
			 (define-key org-tree-slide-mode-map  "right" 'org-tree-slide-move-next-tree)
			 ;;(org-tree-slide-presentation-profile)
			 (org-tree-slide-simple-profile)
			 ;;(etq org-tree-slide-slide-in-effect
			 ;;(org-tree-slide-simple-profile)
			 ;; 			;;(org-tree-slide-narrowing-control-profile)

			 ))

	     (require 'ox-confluence) 
	     (require 'ox-ascii)
	     ;;(use-package ox-ravel)	;allowing export from org to Rmd
	     ;;(use-package orgmode-accessories)	;allowing export from org to Rmd
	     (require 'ox-beamer)
	     ;;(use-package ox-qmd)
	     (require 'ox-md)

	     (defun org-confluence-src-block (src-block contents info)
	       ;; mec: till then, replace hard-wired theme from emacs to Default
	       ;; FIXME: provide a user-controlled variable for theme
	       (let* ((lang (org-element-property :language src-block))
		      (language (if (or (string= lang "sh") (string= lang "shell")) "bash" ;; FIXME: provide a mapping of some sort
				  lang))
		      (content (org-export-format-code-default src-block info)))
		 (org-confluence--block language "Default" content)))

	     (use-package org-download)
	     ;;(use-package org-preview-html)  (org-preview-html-mode)g
	     (use-package orglink) ;; use Org Mode links in other modes
	     ;;(use-package ox-clip)
	     (use-package ox-clip :bind
	       (("s-w" .  ox-clip-formatted-copy
		 ;; NB: requires version of xclip supporting -t.
		 ;; CentOS7 is too old.  this works:
		 ;; https://houtianze.github.io/xclip/xsel/centos/redhat/yum/2017/03/08/xclip-xsel-on-yum-centos-redhat.html
		 )))


	     ;; (use-package ox-gfm
	     ;; somehow seems to remove ox-md
	     ;;   :init
	     ;;   ;;(when (boundp 'org-export-backends)
	     ;;   (customize-set-variable '
	     ;;    org-export-backends
	     ;;    (cons 'gfm org-export-backends))
	     ;;   ;;)
	     ;;   )
	     ;;)
	     ;;[[https://github.com/jkitchin/org-ref/issues/428][You probably need these libraries loaded to export]] the org refcard
	     (require 'org-id)
	     (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id
		   org-id-method 'org)
	     ;; Based on org-expiry-insinuate
	     (add-hook 'org-insert-heading-hook 'org-id-get-create)
	     (add-hook 'org-after-todo-state-change-hook 'org-id-get-create)
	     (add-hook 'org-after-tags-change-hook 'org-id-get-create)
	     (defun my/org-update-ids ()
	       ;; kudos: https://emacs.stackexchange.com/questions/614/creating-permalinks-for-sections-in-html-exported-from-org-mode
	       (interactive)
	       (let* ((tree (org-element-parse-buffer 'headline))
		      (map (org-element-map tree 'headline
			     (lambda (hl)
			       (org-element-property :begin hl)))))
		 (save-excursion
		   (cl-loop for point in map do
			    (goto-char point)
			    (org-id-get-create nil ;; consider t to replace all - or condition on numeric-prefix
					       )))))

	     ;;(use-package org-ref)
	     ;;(require 'org-ref-wos)
	     ;; (require 'org-ref-scopus)
	     ;; (require 'org-ref-pubmed)

	     (use-package org-present)
	     ;;(require 'org)

	     (defun org-cycle-hide-drawers (state)
	       ;; kudos https://stackoverflow.com/questions/17478260/completely-hide-the-properties-drawer-in-org-mode
	       "Re-hide all drawers after a visibility state change."
	       (when (and (derived-mode-p 'org-mode)
			  (not (memq state '(overview folded contents))))
		 (save-excursion
		   (let* ((globalp (memq state '(contents all)))
			  (beg (if globalp
				   (point-min)
				 (point)))
			  (end (if globalp
				   (point-max)
				 (if (eq state 'children)
				     (save-excursion
				       (outline-next-heading)
				       (point))
				   (org-end-of-subtree t)))))
		     (goto-char beg)
		     (while (re-search-forward org-drawer-regexp end t)
		       (save-excursion
			 (beginning-of-line 1)
			 (when (looking-at org-drawer-regexp)
			   (let* ((start (1- (match-beginning 0)))
				  (limit
				   (save-excursion
				     (outline-next-heading)
				     (point)))
				  (msg (format
					(concat
					 "org-cycle-hide-drawers:  "
					 "`:END:`"
					 " line missing at position %s")
					(1+ start))))
			     (if (re-search-forward "^[ \t]*:END:" limit t)
				 (outline-flag-region start (point-at-eol) t)
			       (user-error msg))))))))))
	     (use-package hide-mode-line)
	     ;;(add-to-list 'load-path "~/path/to/org-present")
	     (autoload 'org-present "org-present" nil t)
	     (setq org-present-mode-hook nil
		   org-present-mode-quit-hook nil)
	     (eval-after-load "org-present"
	       '(progn
		  (add-hook ' org-present-mode-hook
			    (lambda ()
			      (org-cycle-hide-drawers 'all)
			      (hide-mode-line-mode)
			      (org-present-big)
			      (org-display-inline-images)
			      (org-present-hide-cursor)
			      (org-present-read-only)))
		  (add-hook 'org-present-mode-quit-hook
			    (lambda ()
			      (hide-mode-line-mode)
			      (org-present-small)
			      (org-remove-inline-images)
			      (org-present-show-cursor)
			      (org-present-read-write)))))
	     (add-to-list ' org-structure-template-alist '("r" . "src R"))
	     ;;(use-package org-temp)	; so "<r" expands in addition to C-c C-,

	     ;;(use-package ob-sql :ensure t)
	     (use-package ob-sql-mode :ensure t)

	     )



  ;; (defun org-html-export-img-without-p-tag (s backend info)
  ;;   ;; to be used as an org-export-filter-final-output-functions
  ;;   ;; kudos: https://emacs.stackexchange.com/a/27705/9140
  ;;   (when (org-export-derived-backend-p backend 'html)
  ;;     (replace-regexp-in-string "<p>\\(?1:<img[^<]+\\)</p>"
  ;; 				"\\1" s)))
  ;; (add-to-list 'org-export-filter-final-output-functions
  ;;            'org-html-export-img-without-p-tag)

  )

;;(unload-feature 'outshine)

;; * zxcv
;; [[https://github.com/alphapapa/outshine][Outshine]] 
;; ** zxcv
;; ** asdf

(defvar outline-minor-mode-prefix "\M-#") ; default is C-c @
(use-package outshine
  ;; c.f. https://github.com/alphapapa/outshine
  :quelpa (outshine :fetcher github :repo "alphapapa/outshine")
  )
(add-hook 'outline-minor-mode-hook 'outshine-hook-function)
(add-hook 'emacs-lisp-mode-hook 'outshine-mode)

(add-hook 'emacs-lisp-mode-hook 'org-link-minor-mode)

(use-package  org-link-minor-mode :ensure t)
;;(require 'org-link-minor-mode)
;; try to enable org-link-minor-mode whenever outshine-mode is on
;; we really only want it in commends - have not figured out how to control this yet
(add-hook 'outshine-hook-function 'org-link-minor-mode)

;;(use-package writeroom-mode :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package org-publish)
;; (setq org-publish-project-alist
;;       '(
;; 	("sciproj"
;; 	 :base-directory "~/???/"
;; 	 :base-extension "org"
;; 	 :publishing-directory "~/???/"
;; 	 :recursive t
;; 	 :publishing-function org-publish-org-to-html
;; 	 :headline-levels 4             ; Just the default for this project.
;; 	 :auto-preamble t
;; 	 )
;; 	))

;; (setq auto-mode-alist nil)

(use-package polymode
  :config (progn
  	    ;;(push (car (directory-files "~/.dotfiles/emacs/.emacs.d/elpa/" t "polymode-*")) load-path)
	    (use-package poly-R :ensure t)
	    (use-package poly-markdown :ensure t)
	    ;;(require 'poly-noweb)
	    (use-package poly-org :ensure t)
	    (defun polymode-end-of-chunk (&optional ignore)
	      "Go to end of current chunk.
"
	      (interactive "p")
	      (pm-goto-span-of-type '(tail) 0)
	      (pm-switch-to-buffer))
	    (define-key polymode-mode-map [(meta n) (e)] ' polymode-end-of-chunk)
	    ;; (defun polymode-start-of-chunk (&optional ignore)
	    ;; 	      "Go to start of current chunk.
	    ;; "
	    ;; 	      (interactive "p")
	    ;; 	      (pm-goto-span-of-type '(head) 0)
	    ;; 	      ;; ;; If head/tail end before eol we move to the next line
	    ;; 	      ;; (when (looking-at "\\s *$")
	    ;; 	      ;; 	(forward-line 1))
	    ;; 	      (pm-switch-to-buffer))
	    ;; 	    	    (define-key polymode-mode-map [(meta n) (s)] ' polymode-start-of-chunk)

	    ;; flaky? experimental? autoswitch between modes
	    ;; within .org file
	    ;;(define-key polymode-mode-map [(meta n) (r)] 'rmarkdown-render)
	    ;;(define-key polymode-mode-map [(r)] 'self-insert-command)
	    ;;   (if nil (use-package polymode-configuration)
	    ;; 	      ;; 
	    ;; 	      ;; else, choose suits your needs and place into your .emacs file.
	    ;; ;;; MARKDOWN
	    ;; 	      (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
	    ;; ;;; ORG
	    ;; ;;; it seems to disrupt auto format/highligh buffer
	    ;; ;;;	      (add-to-list ' auto-mode-alist '("\\.org" . poly-org-mode))
	    ;; (delete '("\\.org$" . poly-org-mode)
	    ;; 	      ;; workaround for bug: https://github.com/polymode/polymode/issues/177
	    ;; 	      auto-mode-alist)
	    ;; ;;	      (alist-get  "\\.org$"  auto-mode-alist) nil)

	    ;; ;;; R related modes
	    ;; 	      (add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
	    ;; 	      (add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
	    ;;	    (add-to-list 'auto-mode-alist '("\\.Rmd\\" . poly-markdown+R-mode))
	    (add-to-list 'auto-mode-alist '("\\.Rmd$" . poly-markdown+r-mode))
	    ;;(setq auto-mode-alist nil)
	    ;; 	      ;; (add-to-list 'auto-mode-alist '("\\.rapport" . poly-rapport-mode))
	    ;; 	      ;; (add-to-list 'auto-mode-alist '("\\.Rhtml" . poly-html+r-mode))
	    ;; 	      ;; (add-to-list 'auto-mode-alist '("\\.Rbrew" . poly-brew+r-mode))
	    ;; 	      ;; (add-to-list 'auto-mode-alist '("\\.Rcpp" . poly-r+c++-mode))
	    ;; 	      ;; (add-to-list 'auto-mode-alist '("\\.cppR" . poly-c++r-mode))
	    ;;(provide 'polymode-configuration);; old way of indicating it is configured?
	    
 	    (setq polymode-exporter-output-file-format "%s") ;; instead of default "%s[exported]"1
	    (setq poly-lock-mode t) ; else getting errors on fontification - drat
	    ))



;; (unless nil; (package-installed-p 'polymode)
;;   (package-install 'polymode))
;; (unless nil ; (package-installed-p 'poly-markdown)
;;   (package-install 'poly-markdown))
;; (unless nil ; (package-installed-p 'poly-noweb)
;;   (package-install 'poly-noweb))
;; (unless nil ; (package-installed-p 'markdown-mode)
;;   (package-install 'markdown-mode))
;; (unless nil ; (package-installed-p 'python-mode)
;;   (package-install 'python-mode))



(use-package pdf-tools
 :ensure t
  ;;will not build on centos 6.5 cf:
  ;; https://github.com/politza/pdf-tools NB - to update this package
  ;; - delete it and run this again.  It must be run by a sudoer and
  ;; installs packages in the system
  ;; :config (progn
  ;; 	    (pdf-tools-install)
  ;; 	    (eval-after-load 'org '(require 'org-pdfview))
  ;; 	    (add-to-list 'org-file-apps '("\\.pdf\\'" . (lambda(file link) (org-pdfview-open link))))
  ;; 	    (add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . (lambda(file link) (org-pdfview-open link))))
  ;; 	    )
  )

;; overwrite definition from
;; ~/.dotfiles/emacs/.emacs.d/elpa/org-plus-contrib-20181008/ob.R.el -
;; use fwrite instead of write-table to allow for column values to be
;; lists
;; (setq org-babel-R-write-object-command "{
;;     function(object,transfer.file) {
;;         library(data.table)
;;         object
;;         invisible(
;;             if (
;;                 inherits(
;;                     try(
;;                         {
;;                             tfile<-tempfile()
;;                             fwrite(object, file=tfile, sep=\"\\t\",
;;                                         na=\"NA\",row.names=%s,col.names=%s,
;;                                         quote=\"auto\",
;;                                         sep2=c(\"\",\";\",\"\")
;;                                   )
;;                             file.rename(tfile,transfer.file)
;;                         },
;;                         silent=TRUE),
;;                     \"try-error\"))
;;                 {
;;                     if(!file.exists(transfer.file))
;;                         file.create(transfer.file)
;;                 }
;;             )
;;     }
;; }(object=%s,transfer.file=\"%s\")")


(progn
  ;; following discussion in see:
  ;; https://emacs.stackexchange.com/questions/614/creating-permalinks-for-sections-in-html-exported-from-org-mode/615
  ;; : (a) redfine functions from org-id to work with "CUSTOM_ID"
  ;; instead of "ID" (b) implement a new org-id-method 'heading which
  ;; might create problems since the values it generates are not
  ;; actually guaranteed to be unique and also are only minimally
  ;; santitized for use as target in ULR but see
  ;; [[https://emacs.stackexchange.com/questions/2186/have-org-modes-exported-html-use-custom-id-when-linking-to-sub-sections-in-toc][Have
  ;; org-mode's exported HTML use CUSTOM_ID when linking to
  ;; sub-sections in TOC]] for possible improvement / similar
  ;; approach?
  (defun org-id-get-create (&optional force)
    "Create an ID for the current entry and return it.
If the entry already has an ID, just return it.
With optional argument FORCE, force the creation of a new ID."
    (interactive "P")
    (when force
      (org-entry-put (point) "CUSTOM_ID" nil))
    (org-id-get (point) 'create))

  (defun org-id-get (&optional pom create prefix)
    "Get the ID property of the entry at point-or-marker POM.
If POM is nil, refer to the entry at point.
If the entry does not have an ID, the function returns nil.
However, when CREATE is non nil, create an ID if none is present already.
PREFIX will be passed through to `org-id-new'.
In any case, the ID of the entry is returned."
    (org-with-point-at pom
      (let ((id (org-entry-get nil "CUSTOM_ID")))
	(cond
	 ((and id (stringp id) (string-match "\\S-" id))
	  id)
	 (create
	  (setq id (org-id-new prefix))
	  (org-entry-put pom "CUSTOM_ID" id)
	  (org-id-add-location id (buffer-file-name (buffer-base-buffer)))
	  id)))))

  (defun org-id-get (&optional pom create prefix)
    "Get the ID property of the entry at point-or-marker POM.
If POM is nil, refer to the entry at point.
If the entry does not have an ID, the function returns nil.
However, when CREATE is non nil, create an ID if none is present already.
PREFIX will be passed through to `org-id-new'.
In any case, the ID of the entry is returned."
    (org-with-point-at pom
      (let ((id (org-entry-get nil "CUSTOM_ID")))
	(cond
	 ((and id (stringp id) (string-match "\\S-" id))
	  id)
	 (create
	  (setq id (org-id-new prefix))	
	  (org-entry-put pom "CUSTOM_ID" id)
	  (org-id-add-location id (buffer-file-name (buffer-base-buffer)))
	  id)))))

  (setq  org-id-method 'heading)
  (defun org-id-new (&optional prefix)
    "Create a new globally unique ID.

An ID consists of two parts separated by a colon:
- a prefix
- a unique part that will be created according to `org-id-method'.

PREFIX can specify the prefix, the default is given by the variable
`org-id-prefix'.  However, if PREFIX is the symbol `none', don't use any
prefix even if `org-id-prefix' specifies one.

So a typical ID could look like \"Org:4nd91V40HI\"."
    (let* ((prefix (if (eq prefix 'none)
		       ""
		     (concat (or prefix org-id-prefix) ":")))
	   unique)
      (if (equal prefix ":") (setq prefix ""))
      (cond
       ((memq org-id-method '(heading))
	;;(setq unique (url-encode-url (replace-regexp-in-string " " "." (downcase (org-get-heading t t t t)))))
	(setq unique (url-encode-urlustom-id
		      org-id-method 'org))
	;; Based on org-expiry-insinuate
	))))
  (add-hook 'org-insert-heading-hook 'org-id-get-create)
  (add-hook 'org-after-todo-state-change-hook 'org-id-get-create)
  (add-hook 'org-after-tags-change-hook 'org-id-get-create)
  (defun my/org-update-ids ()
    ;; kudos: https://emacs.stackexchange.com/questions/614/creating-permalinks-for-sections-in-html-exported-from-org-mode
    (interactive)
    (let* ((tree (org-element-parse-buffer 'headline))
	   (map (org-element-map tree 'headline
		  (lambda (hl)
		    (org-element-property :begin hl)))))
      (save-excursion
	(cl-loop for point in map do
		 (goto-char point)
		 (org-id-get-create))))))

;; (use-package org-ref)
;; (require 'org-ref-wos)
;; (require 'org-ref-scopus)
;; (require 'org-ref-pubmed)

;(require 'org)

(defun org-cycle-hide-drawers (state)
  ;; kudos https://stackoverflow.com/questions/17478260/completely-hide-the-properties-drawer-in-org-mode
  "Re-hide all drawers after a visibility state change."
  (when (and (derived-mode-p 'org-mode)
	     (not (memq state '(overview folded contents))))
    (save-excursion
      (let* ((globalp (memq state '(contents all)))
	     (beg (if globalp
		      (point-min)
		    (point)))
	     (end (if globalp
		      (point-max)
		    (if (eq state 'children)
			(save-excursion
			  (outline-next-heading)
			  (point))
		      (org-end-of-subtree t)))))
	(goto-char beg)
	(while (re-search-forward org-drawer-regexp end t)
	  (save-excursion
	    (beginning-of-line 1)
	    (when (looking-at org-drawer-regexp)
	      (let* ((start (1- (match-beginning 0)))
		     (limit
		      (save-excursion
			(outline-next-heading)
			(point)))
		     (msg (format
			   (concat
			    "org-cycle-hide-drawers:  "
			    "`:END:`"
			    " line missing at position %s")
			   (1+ start))))
		(if (re-search-forward "^[ \t]*:END:" limit t)
		    (outline-flag-region start (point-at-eol) t)
		  (user-error msg))))))))))
(use-package hide-mode-line)

;;(use-package org-present)
    ;;(add-to-list 'load-path "~/path/to/org-present")
(autoload 'org-present "org-present" nil t)
(setq org-present-mode-hook nil
      org-present-mode-quit-hook nil)
(eval-after-load "org-present"
  '(progn
     (add-hook ' org-present-mode-hook
		 (lambda ()
		   (org-cycle-hide-drawers 'all)
		   (hide-mode-line-mode)
		   (org-present-big)
		   (org-display-inline-images)
		   (org-present-hide-cursor)
		   (org-present-read-only)))
     (add-hook 'org-present-mode-quit-hook
	       (lambda ()
		 (hide-mode-line-mode)
		 (org-present-small)
		 (org-remove-inline-images)
		 (org-present-show-cursor)
		 (org-present-read-write)))))
    

;; overwrite definition from
;; ~/.dotfiles/emacs/.emacs.d/elpa/org-plus-contrib-20181008/ob.R.el -
;; use fwrite instead of write-table to allow for column values to be
;; lists
;; (setq org-babel-R-write-object-command "{
;;     function(object,transfer.file) {
;;         library(data.table)
;;         object
;;         invisible(
;;             if (
;;                 inherits(
;;                     try(
;;                         {
;;                             tfile<-tempfile()
;;                             fwrite(object, file=tfile, sep=\"\\t\",
;;                                         na=\"NA\",row.names=%s,col.names=%s,
;;                                         quote=\"auto\",
;;                                         sep2=c(\"\",\";\",\"\")
;;                                   )
;;                             file.rename(tfile,transfer.file)
;;                         },
;;                         silent=TRUE),
;;                     \"try-error\"))
;;                 {
;;                     if(!file.exists(transfer.file))
;;                         file.create(transfer.file)
;;                 }
;;             )
;;     }
;; }(object=%s,transfer.file=\"%s\")")


(progn
  ;; following discussion in see:
  ;; https://emacs.stackexchange.com/questions/614/creating-permalinks-for-sections-in-html-exported-from-org-mode/615
  ;; : (a) redfine functions from org-id to work with "CUSTOM_ID"
  ;; instead of "ID" (b) implement a new org-id-method 'heading which
  ;; might create problems since the values it generates are not
  ;; actually guaranteed to be unique and also are only minimally
  ;; santitized for use as target in ULR but see
  ;; [[https://emacs.stackexchange.com/questions/2186/have-org-modes-exported-html-use-custom-id-when-linking-to-sub-sections-in-toc][Have
  ;; org-mode's exported HTML use CUSTOM_ID when linking to
  ;; sub-sections in TOC]] for possible improvement / similar
  ;; approach?
  (defun org-id-get-create (&optional force)
    "Create an ID for the current entry and return it.
If the entry already has an ID, just return it.
With optional argument FORCE, force the creation of a new ID."
    (interactive "P")
    (when force
      (org-entry-put (point) "CUSTOM_ID" nil))
    (org-id-get (point) 'create))

  (defun org-id-get (&optional pom create prefix)
    "Get the ID property of the entry at point-or-marker POM.
If POM is nil, refer to the entry at point.
If the entry does not have an ID, the function returns nil.
However, when CREATE is non nil, create an ID if none is present already.
PREFIX will be passed through to `org-id-new'.
In any case, the ID of the entry is returned."
    (org-with-point-at pom
      (let ((id (org-entry-get nil "CUSTOM_ID")))
	(cond
	 ((and id (stringp id) (string-match "\\S-" id))
	  id)
	 (create
	  (setq id (org-id-new prefix))
	  (org-entry-put pom "CUSTOM_ID" id)
	  (org-id-add-location id (buffer-file-name (buffer-base-buffer)))
	  id)))))

  (defun org-id-get (&optional pom create prefix)
    "Get the ID property of the entry at point-or-marker POM.
If POM is nil, refer to the entry at point.
If the entry does not have an ID, the function returns nil.
However, when CREATE is non nil, create an ID if none is present already.
PREFIX will be passed through to `org-id-new'.
In any case, the ID of the entry is returned."
    (org-with-point-at pom
      (let ((id (org-entry-get nil "CUSTOM_ID")))
	(cond
	 ((and id (stringp id) (string-match "\\S-" id))
	  id)
	 (create
	  (setq id (org-id-new prefix))	
	  (org-entry-put pom "CUSTOM_ID" id)
	  (org-id-add-location id (buffer-file-name (buffer-base-buffer)))
	  id)))))

  (setq  org-id-method 'heading)
  (defun org-id-new (&optional prefix)
    "Create a new globally unique ID.

An ID consists of two parts separated by a colon:
- a prefix
- a unique part that will be created according to `org-id-method'.

PREFIX can specify the prefix, the default is given by the variable
`org-id-prefix'.  However, if PREFIX is the symbol `none', don't use any
prefix even if `org-id-prefix' specifies one.

So a typical ID could look like \"Org:4nd91V40HI\"."
    (let* ((prefix (if (eq prefix 'none)
		       ""
		     (concat (or prefix org-id-prefix) ":")))
	   unique)
      (if (equal prefix ":") (setq prefix ""))
      (cond
       ((memq org-id-method '(heading))
	;;(setq unique (url-encode-url (replace-regexp-in-string " " "." (downcase (org-get-heading t t t t)))))
	(setq unique (url-encode-url
		      (replace-regexp-in-string "^\_+" ""
						(replace-regexp-in-string "\_+$" ""
									  (replace-regexp-in-string "[^a-z]+" "_" (downcase (org-get-heading t t t t)))))))
	)
       ((memq org-id-method '(uuidgen uuid))
	(setq unique (org-trim (shell-command-to-string org-id-uuid-program)))
	(unless (org-uuidgen-p unique)
	  (setq unique (org-id-uuid))))
       ((eq org-id-method 'org)
	(let* ((etime (org-reverse-string (org-id-time-to-b36)))
	       (postfix (if org-id-include-domain
			    (progn
			      (require 'message)
			      (concat "@" (message-make-fqdn))))))
	  (setq unique (concat etime postfix))))
       (t (error "Invalid `org-id-method'")))
      (concat prefix unique)))
  )
;;Rscript --vanilla -e 'library(rmarkdown); rmarkdown::render(commandArgs(trailingOnly=TRUE)[1])<'

;;(add-to-list 'load-path "~/elisp/org-mode/contrib/lisp/")

(defun org-table-import-xlsx-to-csv-org () 
  (interactive)
  (let* ((source-file  (file-name-sans-extension (buffer-file-name (current-buffer))))
         (xlsx-file (concat source-file ".xlsx"))
         (csv-file (concat source-file ".csv")))
    (org-odt-convert xlsx-file "csv")
    (org-table-import csv-file  nil)))


(defun org-table-import-xlsx-file-to-csv-org (file) 
  (interactive "f")
  (let* ((source-file  (file-name-sans-extension (buffer-file-name (current-buffer))))
         (xlsx-file (concat source-file ".xlsx"))
         (csv-file (concat source-file ".csv")))
    (org-odt-convert file "csv")
    (org-table-import csv-file  nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Error (use-package): Cannot load matlab-mode
;; (use-package matlab-mode ;; kudos https://github.com/abo-abo/matlab-mode
;;   :config (progn
;; 	    (setq default-fill-column fill-column) ; without which some bug loading the mode
;; 	    (setq matlab-indent-function t) ; if you want function bodies indented
;; 	    (setq matlab-verify-on-save-flag nil) ; turn off auto-verify on save
;; 	    ;;(defun my-matlab-mode-hook ()
;; 	    ;;     (setq fill-column 76))		; where auto-fill should wrap
;; 	    ;;   (add-hook 'matlab-mode-hook 'my-matlab-mode-hook)
;; 	    ;;   (defun my-matlab-shell-mode-hook ()
;; 	    ;;	'())
;; 	    ;;   (add-hook 'matlab-shell-mode-hook 'my-matlab-shell-mode-hook)
;; 	    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FILE ME BELOW

(autoload 'comint-dynamic-complete-filename "comint" nil t)
(global-set-key "\M-]" 'comint-dynamic-complete-filename)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(server-start)				; do this early on in-case
					; anyone is calling
					; emacsclient right away

(setq load-prefer-newer t)	     ; don't load .elc if .el file is newer

(setq write-region-inhibit-fsync t)	; I find that the stowers file
					; system writes more slowly
					; than my fingers move
					; sometimes.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PACKAGES - a few ways of cataloging and requiring them: package,
;;; use-package, auto-install, el-get:

(use-package edit-server
  ;; for editting fields in chrome
  :if window-system
  :init
  (add-hook 'after-init-hook 'server-start t)
  (add-hook 'after-init-hook 'edit-server-start t)
  ;;:config (edit-server-start)
  )

;;(use-package eval-in-repl) ;; TODO: works for shell?


;; (or (use-package toc-org
;;       :config (progn
;; 		(add-hook 'org-mode-hook 'toc-org-enable)))
;;     (warn "org-toc not found"))


(fset 'function-put 'put)

;; (use-package paradox
;;   ;; a modern packages menu
;;   :config (progn
;; 	  (setq paradox-github-token '4347ac649c32dcae5730afbaeaabcead8ed23076)
;; 	  ))

(use-package smart-mode-line)	; makes paradox cleaner

(use-package async)		; allowing paradox to perform asynchronous package installation, inter alia

;; (use-package auto-install
;;   :config (progn
;; 	  (setq auto-install-save-confirm nil) ; just do it!
;; 	  (auto-install-update-emacswiki-package-name t)
;; 	  ;; Make auto-installed packages findable: 
;; 	  (add-to-list 'load-path (expand-file-name auto-install-directory))
;; 	  ))

;; (use-package el-get
;;   :config (progn
;; 	      (el-get-emacswiki-refresh)
;; 	      ))

(defvar EmacsInitDir (file-name-directory 
		      (or load-file-name ; in case of loading during
					; init, when it is set.
			  (buffer-file-name) ; in case of eval from within edit buffer.
			  )))
(setq EmacsInitDir "/home/mec/.dotfiles/emacs/.emacs.d/")
(dolist (default-directory (mapcar (lambda(d) (expand-file-name d EmacsInitDir)) 
				   (list
				    ;; "elisp" 
				    ;; "elpa"
				    "add-to-load-path"
					 )))
  ;; where else to find required libraries.  strategy cobbled from
  ;; http://www.emacswiki.org/emacs/LoadPath -
  (setq load-path
        (append
         (let ((load-path (copy-sequence load-path))) ;; Shadow -
	   ;; ensuring that the loaded paths are IN FRONT OF system
	   ;; paths
           (append
            (copy-sequence (normal-top-level-add-to-load-path '(".")))
            (normal-top-level-add-subdirs-to-load-path)))
         load-path)))

;; (let ((default-directory  "~/.emacs.d/add-to-load-path/"))
;;   (normal-top-level-add-to-load-path '("."))
;;   (normal-top-level-add-subdirs-to-load-path))

;;(add-to-list 'load-path "~mec/elisp/org-mode/contrib/lisp/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                          ELISP DEVELOPMENT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package auto-compile
  :config (progn
	  (setq load-prefer-newer t)	     ; don't load .elc if .el file is newer
	  (auto-compile-on-save-mode)	     ; compile .el files when they are being saved.
	  ))


(use-package shell
  :config (progn
	  (setq explicit-shell-file-name "/bin/bash")
	  ))
;;(use-package epresent) ;; an Emacs minor mode for giving presentations. breaks with emacs 24
(use-package tramp
;;  (require 'tramp)
  :config (progn
	  (setq
	   tramp-default-method "ssh"
	   ;; allowing these to work too:
	   ;;/access.stowers.org:~/
	   ;;/mec@:~/
	   tramp-default-user "mec"
	   ;;tramp-default-host "access.stowers.org"
	   tramp-default-host "mango"
	   )
	  ;;/ssh:mec@access.stowers.org:~/
	  ;;/mec@access.stowers.org:~/
	  ;;
	  ;;not working - multihop syntax:
	  ;;/mec@access.stowers.org|mec@maple|mec@catalpa:~/

	  ;; /ssh:mec@mango:/n/core/Genomics/Analysis/Si/younshim_park/yop2/mec/yop2.mec.org
	  ;; works: c-x c-f 
	  ;; /ssh:mec@access.stowers.org|ssh:mec@maple|ssh:mec@catalpa:~/
	  ;; but not with ffap
	  ;;
	  ;;/mec@access.stowers.org:~/
;;;ssh -v -L38080:localhost:38080 mec@access.stowers.org  -t ssh -v -L38080:localhost:38080 mec@maple -t ssh -v -L38080:localhost:8080 mec@bioinfo

	  (tramp-set-completion-function "ssh"
					 '((tramp-parse-sconfig "/etc/ssh_config")
					   (tramp-parse-sconfig "~/.ssh/config")))

	  ;; per Michael Albinus @
	  ;; http://lists.gnu.org/archive/html/tramp-devel/2012-01/msg00008.html
	  ;; for problem starting R from tramp file buffer
	  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
	  (setq desktop-files-not-to-save nil
		;; default value skips tramp/ftp buffers.
		)
	  ))



;;(require 'ipython)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                        HOST SPECIFIC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq printer-name 'PB020502)  ;- The name of a local printer to which
                               ;;data is sent for printing.
(setq lpr-switches '("-PB020502"))

;; (use-package printing
;;   :config (progn
;; 	  (pr-update-menus t); make sure we use localhost as cups server
;; 	  (setenv "CUPS_SERVER" "localhost")
;; 	  ;;(package-require 'cups)			; from marmlade
;; 	  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                             LOOK & FEEL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package zenburn-theme :ensure t)
;;(zenburn-theme)
;;(use-package solarized-theme)
;; (use-package color-theme)
;; (color-theme-initialize)
;; (color-theme-resolve)
;;(use-package tango-plus-theme)
;;(use-package solarized-theme)
;;(solarized-theme)
;;(use-package org-beautify-theme)	; not sure I like this yet - 

(global-font-lock-mode t)         ; make pretty color fonts default

;; (use-package hc-zenburn-theme   :config (progn)) ;; scimax c

(define-key global-map [f2] 'accelerate-menu)
;; (define-key global-map [menux] 'accelerate-menu)
;; (define-key global-map [menu] 'accelerate-menu)

(use-package recentf
  ;;  keep track of recently opened files in the file open menu
  :config (recentf-mode 1))

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
(unless window-system
  (xterm-mouse-mode t)
  (use-package xclip
    :config (progn
	      (xclip-mode 1) ;; if not xwindows I guess - http://www.lingotrek.com/2010/12/integrating-emacs-with-x11-clipboard-in.html
	      ))
  )

;;; WINDOW NAVIGATION
(setq split-height-threshold 0)
(setq split-width-threshold 0)
(define-key global-map (kbd "C-`") 'other-frame)
(windmove-default-keybindings 'shift) ; which binds SHIFT-up/down/left/rignt to
                               ; switch emacs windows

(setq scroll-conservatively 10)


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

;;;                    NEWS READING
(setq gnus-select-method
	     '(nntp "news.gmane.org"
		     (nntp-open-connection-function nntp-open-tls-stream)
		     (nntp-port-number 563)
		     (nnir-search-engine gmane)
		     ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MISC SETTINGS
(setq garbage-collection-messages t)    ; tell me when GC is happening
(setq gc-cons-threshold (* 8192 8192)) ; c.f. https://lists.gnu.org/archive/html/emacs-devel/2002-07/msg00814.html

(transient-mark-mode 1)  ;; always highlight region between point and mark
                         ;; (when active)

;; Show column and row number in mode line
(column-number-mode t)
(line-number-mode t)

;; When point is on paranthesis, highlight the matching one
(show-paren-mode nil)
(which-function-mode t)

(setq indicate-empty-lines t) ;; Indicate empty lines at the end of buffer
(setq require-final-newline t) ;; Always end a file with a newline
(setq-default show-trailing-whitespace t) ;; Show trailing whitespace (usually a mistake)

(use-package ffap
  :config (progn
	  (ffap-bindings)
	  ;;(setq ffap-machine-p-known 'accept)
	  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                  MISC KEYMAP BINDINGS
(define-key global-map [(f6)] 'prefix-region)
(define-key global-map [(meta space)] 'fixup-whitespace) ;;overriding just-one-space
(define-key global-map [(control x) (meta y)] 'bury-buffer
  ;; NOTE: polymode's non-standard use of buffers makes this less
  ;; usefull in polymode buffers - presumably now fixed?
  ) 
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                  LITERATE PROGRAMMING AND DOCUMENTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun rmarkdown-render (buffer-file-name) ;;(begin-region end-region buf)
  ;;
  "run rmarkdown::render() on the current file and display results in buffer *Shell Command Output*"
  (interactive)
  (let ((render-command (read-string "render command:" 
				     (format "render('%s',%s);"
					     (shell-quote-argument buf)
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

;(use-package pandoc-mode :ensure t)
;(require 'pandoc-mode)

;;(use-package impatient-mode)

(use-package markdown-mode
  ;;"Major mode for editing Markdown files"
;;; c.f. http://jblevins.org/projects/markdown-mode/
  ;;:ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  :config (progn
	  ;; (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
	  ;; (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
	  ;; (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
	    (add-to-list 'auto-mode-alist '("\\.Rmd" . markdown-mode))
	  ;;(define-key markdown-mode-map [(control c) (control c) (r)] 'rmarkdown-render)
	  (define-key markdown-mode-map  (kbd "C-c C-r r") 'rmarkdown-render)
	  ;;(define-key markdown-mode-map (kbd "C-c C-c r") 'rmarkdown-render)
	  ;;(define-key map "\C-c\C-al" 'markdown-insert-link)
	  ;;(setq markdown-css-path
	  ;;(setq markdown-mode-hook nil)
	  ;;(add-hook 'markdown-mode-hook 'orgstruct-mode)
	  ;;(add-hook 'markdown-mode-hook 'orgstruct++-mode)

	  ;;(add-hook 'markdown-mode-hook 'pandoc-mode)
	  ;;(add-hook 'markdown-mode-hook 'orgtbl-mode)
	  ;;(add-hook 'markdown-mode-hook 'turn-on-orgtbl)
	  ))

;;(add-hook 'text-mode-hook 'turn-on-orgtbl)

;; *.Rmd files invoke r-mode                    ; Temporary fix for R markdown files
;;(add-to-list 'auto-mode-alist '("\\.Rmd$" . r-mode))
; commented while trying out:

;; (use-package pander-mode
;;   :config (progn
;; 	  (add-hook 'markdown-mode-hook 'pander-mode)
;; 	  (add-hook 'pandoc-mode-hook
;; 		    ;; checks if a default settings file exists for the file
;; 		    ;; being loaded and reads its settings if it finds one.
;; 		    'pandoc-load-default-settings)
;; 	  ))

;;(require'longlines) ;; obsolete!

;; (use-package confluence
;; COMMENTED COZ local-set-key seems to be global in text mode.  very strange.
;;
;;   :config (progn
;; 	    (setq confluence-url "https://confluencedev/rpc/xmlrpc"
;; 		  confluence-default-space-alist (list (cons confluence-url "SSU")))
;; 	    (add-hook 'confluence-edit-mode-hook
;; 		      (local-set-key "\C-xw" confluence-prefix-map)
;; 		      (local-set-key "\M-j" 'confluence-newline-and-indent)
;; 		      (local-set-key "\M-;" 'confluence-list-indent-dwim))
;; 	      ))
;; (global-set-key "\C-xwf" 'confluence-get-page)


(when nil
  ;; trying to figure out how to get tables cross referenced
  (defun org-html-list-of-tables (info)
    "Build a list of tables.
INFO is a plist used as a communication channel.  Return the list
of tables as a string, or nil if it is empty."
    (let ((lol-entries (org-export-collect-tables info)))
      ;;"asdfasdf")
      ;;(list (length lol-entries))))

      (when lol-entries
	(concat "<div id=\"list-of-tables\">\n"
		(let ((top-level (plist-get info :html-toplevel-hlevel)))
		  (format "<h%d>%s</h%d>\n"
			  top-level
			  (org-html--translate "List of Tables" info)
			  top-level))
		"<div id=\"text-list-of-tables\">\n<ul>\n"
		(let ((count 0)
		      (initial-fmt (format "<span class=\"table-number\">%s</span>"
					   (org-html--translate "Table %d:" info))))
		  (mapconcat
		   (lambda (entry)
		     (let ((label (and
				   ;;(org-element-property :name entry)
				   ;; (or (org-element-property :name entry)
				   ;;     (org-element-property :results entry))
				       (org-export-get-reference entry info)))
			   (title (org-trim
				   (org-export-data
				    (or (org-export-get-caption entry t)
					(org-export-get-caption entry))
				    info))))
		       (concat
			"<li>"
			(if (not label)
			    (concat (format initial-fmt (incf count)) " " title)
			  (format "<a href=\"#%s\">%s %s</a>"
				  label
				  (format initial-fmt (incf count))
				  title))
			"</li>")))
		   lol-entries "\n"))
		"\n</ul>\n</div>\n</div>"))))
  )


;#https://github.com/kawabata/ox-pandoc
;; default options for all output formats
(setq org-pandoc-options '((standalone . t)))
;; cancel above settings only for 'docx' format
(setq org-pandoc-options-for-docx '((standalone . nil)))
;; special settings for beamer-pdf and latex-pdf exporters
(setq org-pandoc-options-for-beamer-pdf '((latex-engine . "xelatex")))
(setq org-pandoc-options-for-latex-pdf '((latex-engine . "xelatex")))

;; (when nil
;;   (requireInst 'org-table-comment nil 
;; 	       ;;(auto-install-from-url "http://www.emacswiki.org/emacs/download/org-table-comment.el")
;; 	       (auto-install-from-emacswiki "org-table-comment.el")
;; 	       )
;; 					;(use-package org-table-comment "http://www.emacswiki.org/emacs/download/org-table-comment.el")
;; 					;(auto-install-from-emacswiki "org-table-comment.el")
;; 					;(paradox-require 'org-table-comment)
;;   (org-table-comment-mode)
;;   ;;(turn-on-orgtbl)
;;   ;; I like this but there are clashes - i.e. orgtbl ctrl-c ctrl-c
;;   ;; shadows markdown utility commands which I miss , esp those for
;;   ;; promotion and demotion out headers

;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                      SOFTWARE ENGINEERING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package gist)

(use-package magit :ensure t)		; improved git interaction over 
;; not using this yet - problems with older git at SIMR

;; (use-package yasnippet
;;   ;; COMPLETION: yasnippet should be loaded before auto complete so
;;   ;; that they can work together
;;   :config (progn
;; 	      (yas-global-mode 0)
;; seems to cause bug on opening any file!
;; 	      ))

;; (use-package auto-complete
;;   :config (progn
;; ;;	    (use-package auto-complete-config)
;; 	    (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;; 	    (ac-config-default)
;; 	    ;; set the trigger key so that it can work together with yasnippet on tab key,
;; 	    ;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;; 	    ;; activate, otherwise, auto-complete will
;; 	    (ac-set-trigger-key "TAB")
;; 	    (ac-set-trigger-key "<tab>")
;; 	    (setq  ac-use-quick-help nil) ;; else: error running timer ac-quick-help args-out-of-range https://github.com/auto-complete/auto-complete/issues/419
;; 	    ))
;;(auto-complete-mode -1) ;; it is timing out and taking too long.... just disable for now

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

;;(setq eldoc-idle-delay  0.0)

(org-babel-do-load-languages
 'org-babel-load-languages (quote ((emacs-lisp . t)
                                    (sqlite . t)
                                    (R . t)
                                    (python . t))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                 LANGUAGE MODES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package inf-ruby)

(use-package ruby-mode
  ;; :interpreter "ruby" ?? irb
  :config  (progn
	     ;; kudos https://github.com/jcf/previous-emacs.d/blob/master/ruby-custom.el
	     (use-package rbenv
	       :config
	       (progn
		 (setq
		  rbenv-modeline-function 'rbenv--modeline-plain
		  rbenv-show-active-ruby-in-modeline nil)
		 (global-rbenv-mode)))

	     (use-package ruby-tools)

	     ;; (use-package rhtml-mode
	     ;;   :mode (("\\.rhtml$" . rhtml-mode)
	     ;;          ("\\.html\\.erb$" . rhtml-mode)))

	     ;; (use-package rinari
	     ;;   :config (global-rinari-mode 1)
	     ;;   :config (setq ruby-insert-encoding-magic-comment nil))

	     ;; (use-package rspec-mode
	     ;;   :config
	     ;;   (progn
	     ;;     (setq rspec-use-rake-flag nil)
	     ;;     (defadvice rspec-compile (around rspec-compile-around activate)
	     ;;       "Use BASH shell for running the specs because of ZSH issues."
	     ;;       (let ((shell-file-name "/bin/bash"))
	     ;;         ad-do-it))))

	     (use-package robe
	       :config
	       (add-hook 'robe-mode-hook 'ac-robe-setup))

	     (use-package yard-mode)
	     (use-package rspec-mode)
	     (use-package enh-ruby-mode
	       :config
	       (progn
		 (add-hook 'ruby-mode-hook 'rbenv-use-corresponding)
		 (add-hook 'ruby-mode-hook 'rspec-mode)
		 (add-hook 'enh-ruby-mode-hook 'robe-mode)
		 (add-hook 'enh-ruby-mode-hook 'yard-mode)
		 )))

  ;;:config
  ;; (progn
  ;;   (setenv "JRUBY_OPTS" "--2.0")
  ;;   (add-hook 'ruby-mode-hook 'robe-mode)
  ;;   (add-hook 'ruby-mode-hook 'yard-mode)
  ;;   (add-hook 'ruby-mode-hook 'rspec-mode)
  ;;   (add-hook 'ruby-mode-hook 'rbenv-use-corresponding)

  ;;   (setq ruby-deep-indent-paren nil))
  :bind (("C-M-h" . backward-kill-word))
  :mode (("\\.rake$" . ruby-mode)
         ("\\.gemspec$" . ruby-mode)
         ("\\.ru$" . ruby-mode)
         ("\\.rb$" . ruby-mode)
         ("[rR]akefile$" . ruby-mode)
         ("Thorfile$" . ruby-mode)
         ("Gemfile$" . ruby-mode)
         ("Capfile$" . ruby-mode)
         ("Guardfile$" . ruby-mode)))


  ;; (add-to-list ' auto-mode-alist
  ;;              '("\\.\\(?:cap\\|gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
  ;; (add-to-list 'auto-mode-alist
  ;;              '("\\(?:Brewfile\\|Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))


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
	      (require 'man)
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
  (eval-after-load "cperl-mode" '(progn (require 'dabbrev) (ad-activate 'cperl-indent-command))))


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
(defun sh-send-line-or-region (&optional step)
  (interactive ())
  (let ((proc (get-process "shell"))
        pbuf min max command)
    (unless proc
      (let ((currbuff (current-buffer)))
        (shell)
        (switch-to-buffer currbuff)
        (setq proc (get-process "shell"))
        ))
    (setq pbuff (process-buffer proc))
    (if (use-region-p)
        (setq min (region-beginning)
              max (region-end))
      (setq min (point-at-bol)
            max (point-at-eol)))
    (setq command (concat (buffer-substring min max) "\n"))
    (with-current-buffer pbuff
      (goto-char (process-mark proc))
      (insert command)
      (move-marker (process-mark proc) (point))
      ) ;;pop-to-buffer does not work with save-current-buffer -- bug?
    (process-send-string  proc command)
    (display-buffer (process-buffer proc) t)
    (when step 
      (goto-char max)
      (next-line))
    ))

(defun sh-send-line-or-region-and-step ()
  (interactive)
  (sh-send-line-or-region t))
(defun sh-switch-to-process-buffer ()
  (interactive)
  (pop-to-buffer (process-buffer (get-process "shell")) t))


(use-package sh-script 
  :config (progn
	    ;;key-bindings taken from ESS-mode for consistency
 	    (define-key sh-mode-map [(control return)] 'sh-send-line-or-region-and-step)
 	    (define-key sh-mode-map [(control c) (control z)] 'sh-switch-to-process-buffer)
 	    ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                     SQL MODE CONFIGURATION
					;#(use-package sqlind)
;;(sqlind-minor-mode)
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

	    (setq	   sql-user ""	   ;what is default
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
		      sql-password ""	       ;relying upon ~/.my.cnf
		      sql-database "flybase"   ;blastgres? mec?
		      sql-server "flybase.org" ;postgresql-dev
		      )

	      (setq   sql-user "astoria"            
		      sql-password ""	     ;relying upon ~/.my.cnf
		      sql-database "astoria" ;blastgres? mec?
		      sql-server "postgresqlkc01" ;       ;postgresql-dev
		      )

	      (setq   sql-user "mec"            
		      sql-password ""	       ;relying upon ~/.my.cnf
		      sql-database "simr_geneious"   ;blastgres? mec?
		      sql-server "postgresqlkc01" ;postgresql-dev
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

;(use-package n3-mode)
;(load-library "n3-mode") ;; it does not provide itself!?!

(use-package yaml-mode
  :config (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
  )

(use-package lua-mode  
;(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
  :config (progn
	  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
	  (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
	  ))

(use-package js2-mode  
;(autoload 'js2-mode "js2-mode" "Js2 editing mode." t)
  :config (progn
	  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
	  (add-to-list 'interpreter-mode-alist '("js" . js2-mode))
	  (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
	  ))

(use-package nodejs-repl
  ;;## kudos https://github.com/abicky/nodejs-repl.el
  :config (progn
	    (add-hook 'js-mode-hook
		      (lambda ()
			(define-key js-mode-map (kbd "C-x C-e") 'nodejs-repl-send-last-sexp)
			(define-key js-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
			(define-key js-mode-map (kbd "C-c C-l") 'nodejs-repl-load-file)
	                (define-key js-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl)))
	    ))



;; /ssh:user@host|sudo::/path/to/file.

;; (defun sudo-find-file (file-name)
;;   "Like find file, but opens the file as root."
;;   (interactive "FSudo Find File: ")
;;   (let ((tramp-file-name (concat "/sudo:" (expand-file-name file-name))))
;;     (find-file tramp-file-name)))


;; (add-hook 'dired-mode-hook
;;     (lambda ()
;;       ;; open current file as sudo 
;;       (local-set-key
;;        ;;(kbd "C-x <M-S-return>")
;;        (kbd "C-<return>")
;;        (lambda()
;;         (interactive)
;;         (message "!!! SUDO opening %s" (dired-file-name-at-point))
;;         (sudo-find-file (dired-file-name-at-point))
;;       ))
;;     )
;;     )

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
      (concat "/sudo:root@localhost:" tempfile)))
  (let ((my-file-name)	   ; fill this with the file to open
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

(setq dired-listing-switches
      ;;list file sizes given in “human-readable” format (i.e. in units of B,
      ;;K, M, G as appropriate).
      "-alh")

(define-key global-map [(control meta shift R)] 'sudo-edit-current-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph    
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
	;; This would override `fill-column' if it's an integer.
	(emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))
    ;; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)


(put 'downcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package projectile
;;   :config (projectile-global-mode))

;;(use-package cask)


;;(use-package elpy
  ;;ERROR: require: Symbol’s value as variable is void: xref-location-marker
  ;; python: http://elpy.readthedocs.org/en/latest/index.html
  ;; https://github.com/jorgenschaefer/elpy http://elpy.readthedocs.org/en/latest/index.html
  ;;:config (elpy-enable))

(use-package python 
  ;; The package is "python" but the mode is "python-mode":
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package sx
  ;; stack-exchange client in emacs
  )

(use-package multiple-cursors)
(use-package dna-mode)

;;(load "~/.dotfiles/emacs/.emacs.d/Adding-keymaps-to-src-blocks-via-org-font-lock-hook.el")

;;(use-package helm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; git clone https://github.com/jkitchin/scimax.git
;; add-to-load-path/scimax
;;

(use-package ob-ipython)
;;(use-package lispy)

;; (setq scimax-dir
;;       ;; require fails without this!
;;       "~mec/.dotfiles/emacs/.emacs.d/add-to-load-path/scimax")
;; (push scimax-dir load-path)
;; (require 'scimax-org)			; that's all for now but theres lots of other goodies in there.
;; (add-hook 'org-mode-hook 'scimax-autoformat-mode)
;; (add-to-list 'scimax-src-block-keymaps 
;; 	     ;; (setf (alist-get "R"  scimax-src-block-keymaps) 
;; 	     `("R" . (let ((map (make-composed-keymap (, ess-mode-map org-mode-map))))
;; 		       (define-key map (kbd "C-c C-c") 'org-ctrl-c-ctrl-c)
;; 		       (define-key map (kbd "C-c '") 'org-edit-special)
;; 		       map)))


;;(setq scimax-src-block-keymaps nil)
;;(mapcar 'car scimax-src-block-keymaps)

(use-package define-word
  ;; TODO - change to hyerp (H) if I can get working: https://unix.stackexchange.com/questions/91743/can-i-change-caps-lock-to-hyper-additional-modifier
  ;; try next https://www.youtube.com/watch?v=W9_H_M-H-a4
  :bind (
	 ("H-d" . define-word-at-point)
         ("H-D" . define-word)
	 ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package dumb-jump
;;   ;;:ensure t
;;   :bind (("M-g o" . dumb-jump-go-other-window)
;;          ("M-g j" . dumb-jump-go)
;;          ("M-g b" . dumb-jump-back)
;;          ("M-g q" . dumb-jump-quick-look)
;;          ("M-g x" . dumb-jump-go-prefer-external)
;;          ("M-g z" . dumb-jump-go-prefer-external-other-window))
;;   ;:config (setq dumb-jump-selector 'ivy)
;;   )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(use-package elfeed) ;; triggers on quit emacs error: "Invalid extended read marker at head of #s list (only hash-table allowed)"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq browse-url-browser-function 'browse-url-default-browser) ; either firefox or chrome, depending on host

;; (setq browse-url-browser-function 'browse-url-generic
;;        browse-url-generic-program "google-chrome")


;;eww-browse-url
;; for more eww ideas:  http://pragmaticemacs.com/emacs/to-eww-or-not-to-eww/

;(desktop-save-mode (y-or-n-p "desktop save mode?"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; todo: switch to using orgmode to manage init.el, a la: https://github.com/ftvkyo2011/.emacs.d/blob/master/init.el

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org-onenote org-notebook auto-complete company-mode sparql-mode python-mode poly-noweb poly-markdown sqlind sql-ident sql-indent ox-gfm ox-impress-js ox-ioslide ox-reveal ox-tufte hide-mode-line org-present ox-qmd ox-md poly-R poly-org define-word ob-ipython dna-mode multiple-cursors sx nodejs-repl js2-mode lua-mode yaml-mode enh-ruby-mode rspec-mode yard-mode robe ruby-tools rbenv inf-ruby gist markdown-mode pandoc-mode auto-compile smart-mode-line edit-server ox-clip orglink org-download org-tree-slide ox-pandoc ox-twbs org-attach-screenshot org-pdfview org-plus-contrib ess use-package)))
 '(safe-local-variable-values
   (quote
    ((org-export-allow-BIND . t)
     (org-export-use-babel . t)
     (eval setq asdf "asdfasdf")
     (org-export-allow-bind-keywords . t)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package projectile
;;   :config (projectile-global-mode))

;;(use-package cask)


;;(use-package elpy
  ;;ERROR: require: Symbol’s value as variable is void: xref-location-marker
  ;; python: http://elpy.readthedocs.org/en/latest/index.html
  ;; https://github.com/jorgenschaefer/elpy http://elpy.readthedocs.org/en/latest/index.html
  ;;:config (elpy-enable))

(use-package python 
  ;; The package is "python" but the mode is "python-mode":
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package sx
  ;; stack-exchange client in emacs
  )

;;(use-package multiple-cursors)
;;(use-package dna-mode)

;;(load "~/.dotfiles/emacs/.emacs.d/Adding-keymaps-to-src-blocks-via-org-font-lock-hook.el")

;;(use-package helm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; git clone https://github.com/jkitchin/scimax.git
;; add-to-load-path/scimax
;;

;;(use-package org-ref)
(use-package ob-ipython)
;;(use-package lispy)
;; (setq scimax-dir
;;       ;; require fails without this!
;;       "~mec/.dotfiles/emacs/.emacs.d/add-to-load-path/scimax")
;; (push scimax-dir load-path)
;; (require 'scimax-org)			; that's all for now but theres lots of other goodies in there.
;; (add-hook 'org-mode-hook 'scimax-autoformat-mode)
;; (add-to-list 'scimax-src-block-keymaps 
;; 	     ;; (setf (alist-get "R"  scimax-src-block-keymaps) 
;; 	     `("R" . (let ((map (make-composed-keymap (, ess-mode-map org-mode-map))))
;; 		       (define-key map (kbd "C-c C-c") 'org-ctrl-c-ctrl-c)
;; 		       (define-key map (kbd "C-c '") 'org-edit-special)
;; 		       map)))


;;(setq scimax-src-block-keymaps nil)
;;(mapcar 'car scimax-src-block-keymaps)

(use-package define-word
  ;; TODO - change to hyerp (H) if I can get working: https://unix.stackexchange.com/questions/91743/can-i-change-caps-lock-to-hyper-additional-modifier
  ;; try next https://www.youtube.com/watch?v=W9_H_M-H-a4
  :bind (
	 ("H-d" . define-word-at-point)
         ("H-D" . define-word)
	 ))

(use-package markdown-toc :ensure t)
(use-package sparql-mode
  ;;(autoload 'sparql-mode "sparql-mode.el"  "Major mode for editing SPARQL files" t)
  :mode "\\.sparql$"
  :config nil ; other use-pacakges
  :bind () ;
  :init (progn
	  ;;(add-to-list 'auto-mode-alist '("\\.sparql$" . sparql-mode))
	  ;;(add-to-list 'auto-mode-alist '("\\.rq$" . sparql-mode))
	  (org-babel-do-load-languages 'org-babel-load-languages '((sparql . t)))
	  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package dumb-jump
;;   ;;:ensure t
;;   :bind (("M-g o" . dumb-jump-go-other-window)
;;          ("M-g j" . dumb-jump-go)
;;          ("M-g b" . dumb-jump-back)
;;          ("M-g q" . dumb-jump-quick-look)
;;          ("M-g x" . dumb-jump-go-prefer-external)
;;          ("M-g z" . dumb-jump-go-prefer-external-other-window))
;;   ;:config (setq dumb-jump-selector 'ivy)
;;   )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(use-package elfeed) ;; triggers on quit emacs error: "Invalid extended read marker at head of #s list (only hash-table allowed)"

;;(use-package   org-onenote) does NOT work as configured - only with microsoft live.com login.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq browse-url-browser-function 'browse-url-default-browser) ; either firefox or chrome, depending on host

;; (setq browse-url-browser-function 'browse-url-generic
;;        browse-url-generic-program "google-chrome")


;;eww-browse-url
;; for more eww ideas:  http://pragmaticemacs.com/emacs/to-eww-or-not-to-eww/

;(desktop-save-mode (y-or-n-p "desktop save mode?"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; todo: switch to using orgmode to manage init.el, a la: https://github.com/ftvkyo2011/.emacs.d/blob/master/init.el

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;(cancel-function-timers 'show-parent-function)
