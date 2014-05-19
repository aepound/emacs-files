; Set up my identity.
(setq user-full-name "Andrew Pound")
(setq user-mail-address "apound@sandia.gov")

;; set up a default directory to work in:
(setq default-directory "~/")

;; Set default load path for lisp files
(add-to-list 'load-path "~/emacs")

;; Tell emacs that I am going to be using a true meta key ie 8-bit codes.
(setq meta-flag "t")

;; Basic emacs settings:
;;(tool-bar-mode nil)                        ;; Don't show the toolar
(setq scroll-margin 1
      scroll-conservatively 100000
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)       ;; Do smooth scrolling:
(global-font-lock-mode t)                  ;; Always do syntax highlighting
(auto-fill-mode 1)                         ;; Always break beyond 80 chars
(global-linum-mode)                        ;; Enable line numbers
(setq visible-bell t)                      ;; Disable system beep
(setq transient-mark-mode t)               ;; Enable visual feedbakck on selections
(column-number-mode t)                     ;; Enable column numbers in mode line
(size-indication-mode t)                   ;; show file size
(blink-cursor-mode 0)                      ;; Don't blink cursor
(show-paren-mode)                          ;; Show matching parenthesis
(setq x-stretch-cursor t)                  ;; Cursor as wide as the glyph under it
(setq backup-inhibited t)                  ;; No backup files
;;(setq delete-by-moving-to-trash t)         ;; Delete moves to recycle bin
;;(iswitchb-mode t)                          ;; Easy buffer switching ???
(global-set-key "%" 'match-paren) 


(load-theme 'tango-dark)                   ;; Set color theme
(setq linum-format "%d ")                  ;; Add space after line numbers
(setq-default truncate-lines t)            ;; Truncate lines by default

(setq display-time-day-and-date t)         ;; Dispaly date along with time in status bar
(display-time)                             ;; Display date and time in status bar
(setq require-final-newline t)             ;; Always end a file with a newline
(setq frame-title-format "emacs - %b")     ;; Set frame title to "emacs - <buffer name>"
(setq linum-format "%3d")				   ;; Right-aligned line numbers with width 3
(fringe-mode '(nil . 0))				   ;; Left fringes only


;; Use unix line endings by default
(setq default-buffer-file-coding-system 'utf-8-unix)

;; Figure out and use the proxy settings from IE:
;(add-to-list 'load-path "C:/Users/apound/emacs")
(eval-after-load "url"
  '(progn
     (require 'w32-registry)
     (defadvice url-retrieve (before
                              w32-set-proxy-dynamically
                              activate)
       "Before retrieving a URL, query the IE Proxy settings, and use them."
       (let ((proxy (w32reg-get-ie-proxy-config)))
         (setq url-using-proxy proxy
               url-proxy-services proxy)))))


;;;; Package settings

; package stuff...
(require 'package)
;(add-to-list 'package-archives
;   '("melpa" . "


; save place:
(setq save-place-file "~/.emacs.d/saveplace") ;; loaction of saveplace file
(setq-default save-place t)   ;; activate for all buffers
(require 'saveplace)

; org mode:
(require 'org)
(setq org-hide-leading-stars t)  ;; hide but one star in outline
(setq org-add-levels-only t)     ;; align items nicely
(setq org-clock-persost t)       ;; Keep track of time ....
;(org-clock-persistance-insinuate);; .... across sessions
(setq org-clock-out-remove-zero-time-clocks t);;remove 0-duration clocked

; color theme
;(require 'color-theme)    ;; use s color theme
;(color-theme-initialize)
;(color-theme-arjen)  ;; maybe find my own?


;; Make sure that the cygwin bash executable can be found (Windows Emacs)
(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "C:/cygwin64/bin/bash.exe")
  (setq shell-file-name explicit-shell-file-name)
  (add-to-list 'exec-path "C:/cygwin64/bin"))

;; Add an easy way to produce dummy text
;; (source: http://www.emacswiki.org/emacs/download/lorem-ipsum.el)

(require 'lorem-ipsum)
(global-set-key (kbd "C-c C-l") 'Lorem-ipsum-insert-paragraphs)

;; Add support for isearch functionality with multiple cursors
;; (source: https://github.com/zk-phi/phi-search.git)
(add-to-list 'load-path "C:/Users/apound/emacs/phi-search")
(require 'phi-search)
;; Make phi-search the default instead of isearch (I think I like it better)
(global-set-key (kbd "C-s") 'phi-search)
(global-set-key (kbd "C-r") 'phi-search-backward)


;;=================================================================
;;--  Multiple Cursors
;;=================================================================
;; Add support for using multiple cursors
;; (source: https://github.com/magnars/multiple-cursors.el.git)
(add-to-list 'load-path "C:/Users/apound/emacs/multiple-cursors")
(require 'multiple-cursors)

;; Customize key bindings for multiple cursors mode
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c C->") 'mc/mark-more-like-this-extended)
(global-set-key (kbd "C-c SPC") 'set-rectangular-region-anchor)
(global-set-key (kbd "C-c C-SPC") (lambda () (interactive) (mc/create-fake-cursor-at-point)))
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-S-c C-<") 'mc/mark-all-in-region)
;(global-set-key (kbd "C-S-c C->") 'mc/mark-all-regexp-in-region)
(global-set-key (kbd "<f7>") 'multiple-cursors-mode)

;; Keybindings for multiple cursors mode in TTY
(global-set-key (kbd "M-[ 1 ; 6 n") 'mc/mark-next-like-this)
(global-set-key (kbd "M-[ 1 ; 6 l") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c M-[ 1 ; 6 l") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c M-[ 1 ; 6 n") 'mc/mark-more-like-this-extended)

;; Unfortunately, multiple-cursors falls short on rectangular selection
;;   so I use rect-mark.el to fill in the gaps for now
;; (source: http://www.emacswiki.org/emacs/rect-mark.el)
(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x") 'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w") 'rm-kill-region)
(global-set-key (kbd "C-x r M-w") 'rm-kill-ring-save)
(global-set-key (kbd "C-x r C-y") 'yank-rectangle)
(autoload 'rm-set-mark "rect-mark"
  "Set mark for rectangle." t)
(autoload 'rm-exchange-point-and-mark "rect-mark"
  "Exchange point and mark for rectangle." t)
(autoload 'rm-kill-region "rect-mark"
  "Kill a rectangular region and save it in the kill ring." t)
(autoload 'rm-kill-ring-save "rect-mark"
  "Copy a rectangular region to the kill ring." t)

;; Add extended interoperability between phi-search and multiple cursors
;; (source: https://github.com/knu/phi-search-mc.el.git)
(add-to-list 'load-path "C:/Users/apound/emacs/phi-search-mc")
(require 'phi-search-mc)
(phi-search-mc/setup-keys)


;;=================================================================
;;--  Matlab
;;=================================================================
;; Add support for editing matlab files
;; (source: http://matlab-emacs.cvs.sourceforge.net/viewvc/matlab-emacs/matlab-emacs/?view=tar)
(add-to-list 'load-path "C:/Users/apound/emacs/matlab-emacs")
(load-library "matlab-load")


;; Add sublimity mode for mini-map
;; (source: https://github.com/zk-phi/sublimity.git)
;(add-to-list 'load-path "C:/Users/apound/emacs/sublimity")
;(require 'sublimity)
;(require 'sublimity-scroll)
;(require 'sublimity-map)



;;=================================================================
;;--  AUCTeX
;;=================================================================
;; Add AUCTeX Mode for generating LaTeX documents
;; (source: http://ftp.gnu.org/pub/gnu/auctex/auctex-11.87.tar.gz)
;(add-to-list 'load-path "C:/Users/apound/emacs/.emacs.d/site-lisp/auctex")
;(add-to-list 'load-path
;"C:/Users/apound/emacs/.emacs.d/site-lisp/auctex/preview")
;(add-to-list 'load-path "C:/Users/apound/emacs/emacs-files")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq
  TeX-auto-save t
  TeX-parse-self t
  TeX-source-correlate-method (quote synctex)
  TeX-source-correlate-mode t
  TeX-source-correlate-start-server t
  reftex-plug-into-AUCTeX t
  TeX-view-program-list (quote (("Sumatra PDF" "C:/Users/apound/emacs/sumatra/SumatraPDF.exe -reuse-instance %o")))
  TeX-view-program-selection (quote ((output-pdf "Sumatra PDF"))))
(setq-default TeX-master t)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)

(setq LaTeX-mode-hook
   '(lambda()
      (tex-pdf-mode)
      (setq LaTeX-default-environment "enumerate")
      (local-set-key "\M-j" 'LaTeX-fill-paragraph )
      (local-set-key "\M-q" 'query-replace)
      (local-set-key "\M-g" 'goto-line)
      (local-set-key "\e-j" 'LaTeX-fill-paragraph )
      (local-set-key "\e-q" 'query-replace)
      (local-set-key "\e-g" 'goto-line)
      (load "matrix.el")
      (local-set-key "\C-c[" 'bmatrix)
      (local-set-key "\C-c(" 'pmatrix)
      (local-set-key "\C-cm" 'matrix)
      (local-set-key "\C-cv" 'vmatrix)
      (local-set-key "\C-cV" 'Vmatrix)
      (local-set-key "\C-cl" 'seteqlabel)
      (local-set-key "\C-cr" 'refeq)
      (local-set-key "\C-cs" 'smallmatrix)
      (local-set-key "\C-c\\" 'tabstop)
      (local-set-key "\C-c\C-a"   'eqalign)
      (local-set-key "\C-ct"  'LaTeX-insertmtitem)
      (local-set-key "\C-c\C-u"   'delbf)
      (local-set-key "\C-c\C-b"   'addbf)
      (local-set-key "\C-c8"   'addbar)
      (local-set-key "\C-c7"   'delbar)
      (local-set-key "\C-ch"   'slideH) ; slide "heading"
      (local-set-key "\C-cH"   'slideH) ; slide "heading"
      (LaTeX-math-mode)
	  (setq abbrev-mode "t")
      (load "markindex1")
      (local-set-key "\C-ci" index-key-map)
;      (setq TeX-command-list (cons (list "latex2pdf1" "latex2pdf1 '%t'" 'Tex-run-LaTeX nil t) TeX-command-list))

      ; Replaced yap with xdvi for this next section: (aepound)
      (setq TeX-view-style
			'(("^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "%(o?)yap %dS -paper a4 %d")
			  ("^a5\\(?:comb\\|paper\\)$" "%(o?)yap %dS -paper a5 %d")
			  ("^b5paper$" "%(o?)yap %dS -paper b5 %d")
			  ("^letterpaper$" "%(o?)yap %dS -paper us %d")
			  ("^legalpaper$" "%(o?)yap %dS -paper legal %d")
			  ("^executivepaper$" "%(o?)yap %dS -paper 7.25x10.5in %d")
			  ("^landscape$" "%(o?)yap %dS -paper a4r -s 0 %d")
			  ("." "%(o?)yap %dS %d")))

;  '("^" (regexp-opt '("a4paper" "a4dutch" "a4wide" "sem-a4")) "$")
;     "%(o?)xdvi %dS -paper a4 %d")
;    (,(concat "^" (regexp-opt '("a5paper" "a5comb")) "$")
;     "%(o?)yap %dS -paper a5 %d")
;   ("^b5paper$" "%(o?)yap %dS -paper b5 %d")
;    ("^letterpaper$" "%(o?)yap %dS -paper us %d")
;    ("^legalpaper$" "%(o?)yap %dS -paper legal %d")
;    ("^executivepaper$" "%(o?)yap %dS -paper 7.25x10.5in %d")
;    ("^landscape$" "%(o?)yap %dS -paper a4r -s 0 %d")
;    ("." "%(o?)xdvi %dS %d")
;  :group 'TeX-command
;  :type '(repeat (group regexp (string :tag "Command"))))
    )
)
(require 'tex-site)
;(setq LaTeX-command-style '(("" "%(PDF)%(latex) -file-line-error %S%(PDFout)")))


(defun LaTeX-insert-mtitem ()
  "Insert a new mtitem."
  (interactive "*")
  (let ((environment (LaTeX-current-environment)))
   (newline)
   (TeX-insert-macro "mtitem")
    (LaTeX-indent-line)))

(setq bibtex-text-indentation 8)
(setq bibtex-ontline-indentation 10)

;;=================================================================
;;-- Programming modes
;;=================================================================
;; Set up indenting in C/C++
(autoload 'c++-mode "cc-mode" "C++ Editing Mode" t)
(autoload 'c-mode   "c-mode" "C Editing Mode" t)
(setq c-default-style "linux")
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(c-set-offset 'inline-open 0)
(setq c-mode-hook
   '(lambda()
	  (setq c-indent-level 3)
	  (setq c-basic-offset 3)
	  (setq c-comment-only-line-offset 0)
	  (setq c-recognize-knr-p nil)
          (global-set-key "\M-c" 'compile)
    )
)
(setq c++-mode-hook
   '(lambda()
	  (setq c-basic-offset 3)
	  (setq c-comment-only-line-offset 0)
	  (setq c-recognize-knr-p nil)
	  (local-set-key "\ej" 'c-fill-paragraph)
	  (global-set-key "\eq" 'query-replace)
      (global-set-key "\M-c" 'compile)
      (local-set-key "\C-c;" 'comment-region)
    )
)

;;=================================================================
;;--- Some customization for auto-insert ---
;;=================================================================
(setq auto-mode-alist 
	  '(("\\.text$" . org-mode)
	    ("\\.txt$" . org-mode)
	    ("\\.c$" . c-mode) 
	    ("\\.h$" . c++-mode) 
	    ("\\.tex$" . LaTeX-mode)
	    ("\\.el$" . emacs-lisp-mode) 
	    ("\\.scm$" . scheme-mode)
	    ("\\.l$" . lisp-mode) 
	    ("\\.lisp$" . lisp-mode)
	    ("\\.f$" . fortran-mode) 
	    ("\\.mss$" . scribe-mode)
	    ("\\.pl$" . prolog-mode)
	    ("\\.TeX$" . LaTeX-mode)
	    ("\\.sty$" . LaTeX-mode)
	    ("\\.bbl$" . LaTeX-mode)
	    ("\\.bib$" . bibtex-mode)
	    ("\\.ltx$" . LaTeX-mode)
	    ("\\.article$" . text-mode)
	    ("\\.letter$" . text-mode)
	    ("\\.texinfo$" . texinfo-mode)
	    ("\\.lsp$" . lisp-mode)
	    ("\\.prolog$" . prolog-mode) 
	    ("^/tmp/Re" . text-mode)
	    ("^/tmp/fol/" . text-mode) 
	    ("/Message[0-9]*$" . text-mode) 
	    ("\\.y$" . c-mode)
	    ("\\.cc$" . c++-mode) 
	    ("\\.scm.[0-9]*$" . scheme-mode)
	    ("[]>:/]\\..*emacs" . emacs-lisp-mode) 
	    ("\\.ml$" . lisp-mode)
	    ("\\.std$" . fortran-mode)
	    ("\\.cpp$" . c++-mode)
	    ("\\.C$" . c++-mode)
	    ("\\.m$" . matlab-mode)
	    ("\\.p$" . perl-mode)
	    ("\\.html$" . html-mode)
	    ("\\.r$" . s-mode)
	    ))

(load "autoinsert")
(setq auto-insert-directory "C:/Users/apound/emacs/personal/")
(setq auto-insert-alist '(("\\.tex$" . "tex-insert.tex")
                ("\\.ltx$" . "ltx-insert.ltx")
                ("\\.c$" . "c-insert.c")
                ("\\.h$" . "h-insert.c")
                ("[Mm]akefile" . "makefile.inc")
                ("\\.bib$" . "tex-insert.tex")
                ("\\.C$" . "cc-insert.c")
                ("\\.cc$" . "cc-insert.c")
                ("\\.cpp$" . "cc-insert.c")
                ("\\.html$" . "html-insert.html")
))
(auto-insert-mode)




;;=================================================================
;;--  Column markers
;;=================================================================
;; Enable column markers at column 81 to warn of long lines
;; (source: http://www.emacswiki.org/emacs/download/column-marker.el)
(require 'column-marker)
(defun marker-at-81 () (interactive) (column-marker-1 81))
(add-hook 'matlab-mode-hook 'marker-at-81)
(add-hook 'c-mode-hook 'marker-at-81)
(add-hook 'c++-mode-hook 'marker-at-81)
(add-hook 'LaTeX-mode-hook 'marker-at-81)
(setq matlab-comment-column 50)
(setq-default fill-column 81)
(setq-default auto-fill-function 'do-auto-fill)
;(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;=================================================================
;;--  Custom/Misc functions
;;=================================================================
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "[([{]") (forward-sexp 1) (backward-char))
        ((looking-at "[])}]") (forward-char) (backward-sexp 1))
        (t (self-insert-command (or arg 1)))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-auto-save nil)
 '(TeX-parse-self nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
