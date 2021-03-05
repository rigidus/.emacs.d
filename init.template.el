
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-auto-save t)
 '(TeX-source-correlate-mode t)
 '(TeX-view-program-selection '((output-pdf "PDF Tools")))
 '(auto-package-update-delete-old-versions t)
 '(auto-package-update-hide-results nil)
 '(auto-package-update-interval 1)
 '(auto-save-interval 150)
 '(auto-save-visited-file-name t)
 '(auto-save-visited-mode t)
 '(aweshell-valid-command-color "#007A00")
 '(backup-directory-alist '(("." . "/home/daniel/yandex/backup/")))
 '(battery-mode-line-format "-%p- ")
 '(calendar-date-display-form
   '((if dayname
	 (concat dayname ", "))
     day " " monthname " " year))
 '(calendar-week-start-day 1)
 '(cdlatex-command-alist
   '(("ter" "Insert roman text" "\\textrm{?}" cdlatex-position-cursor nil t t)
     ("teu" "Insert upright text" "\\textup{?}" cdlatex-position-cursor nil t t)
     ("teb" "Insert bold text" "\\textbf{?}" cdlatex-position-cursor nil t t)
     ("tei" "Insert italic text" "\\textit{?}" cdlatex-position-cursor nil t t)))
 '(cdlatex-use-dollar-to-ensure-math nil)
 '(column-number-mode t)
 '(custom-safe-themes
   '("d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb" default))
 '(dashboard-org-agenda-categories '("notes" "classes-plan"))
 '(dashboard-page-separator "
")
 '(debug-on-error nil)
 '(default-frame-alist '((font . "Iosevka Term-10") (vertical-scroll-bars)))
 '(default-input-method "russian-computer")
 '(delete-old-versions t)
 '(delete-selection-mode nil)
 '(dired-always-read-filesystem t)
 '(dired-dwim-target 'dired-dwim-target-next)
 '(dired-kept-versions 4)
 '(dired-listing-switches "-alht")
 '(dired-recursive-copies 'always)
 '(dired-recursive-deletes 'always)
 '(display-battery-mode nil)
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-default-load-average nil)
 '(doom-modeline-height 30)
 '(fill-column 90)
 '(global-visual-fill-column-mode nil)
 '(global-visual-line-mode t)
 '(ido-enable-flex-matching t)
 '(ido-enable-prefix nil)
 '(ido-everywhere t)
 '(inhibit-startup-buffer-menu t)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice
   '(lambda nil
      (org-agenda-list 2)
      (delete-other-windows)
      (get-buffer "*Org Agenda*")))
 '(initial-major-mode 'org-mode)
 '(initial-scratch-message nil)
 '(kept-new-versions 4)
 '(kept-old-versions 0)
 '(message-fill-column 80)
 '(org-adapt-indentation nil)
 '(org-agenda-files '("~/study.org" "~/habits.org" "~/work.org" "~/notes.org"))
 '(org-agenda-skip-deadline-prewarning-if-scheduled t)
 '(org-agenda-skip-scheduled-delay-if-deadline t)
 '(org-agenda-skip-scheduled-if-deadline-is-shown t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-babel-load-languages '((emacs-lisp . t) (lisp . t)))
 '(org-capture-templates
   '(("e" "Things to do related to English classes" entry
      (file+headline "/home/daniel/notes.org" "English")
      "* TODO %?
SCHEDULED: %^t DEADLINE: %^t" :empty-lines 1)
     ("s" "Things to do related to Spanish classes" entry
      (file+headline "/home/daniel/notes.org" "Spanish")
      "* TODO %?
SCHEDULED: %^t DEADLINE: %^t" :empty-lines 1)
     ("u" "University related notes" entry
      (file+headline "/home/daniel/notes.org" "University")
      "* TODO %?
SCHEDULED: %^t DEADLINE: %^t")
     ("i" "Random ideas to maybe develop or complete" entry
      (file+headline "/home/daniel/notes.org" "Ideas")
      "* TODO %?
SCHEDULED: %^t" :empty-lines 1)
     ("a" "Different appointments" entry
      (file+headline "/home/daniel/notes.org" "Appointments")
      "* TODO %?
%^t")))
 '(org-catch-invisible-edits 'show)
 '(org-clock-into-drawer "CLOCKBOOK")
 '(org-ctrl-k-protect-subtree t)
 '(org-cycle-separator-lines 0)
 '(org-default-notes-file "/home/daniel/yandex/notes.org")
 '(org-enforce-todo-dependencies t)
 '(org-file-apps
   '((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.djvu\\'" . "GTK_THEME=Adwaita:dark evince %s")
     ("\\.mp3\\'" . "vlc %s")
     ("\\.mp4\\'" . "vlc %s")
     ("\\.mpeg\\'" . "vlc %s")))
 '(org-footnote-auto-adjust t)
 '(org-footnote-define-inline nil)
 '(org-format-latex-header
   "\\documentclass{article}
\\usepackage[usenames]{color}
[DEFAULT-PACKAGES]
[PACKAGES]
\\setmainfont{XITS}
\\setmathfont{XITS Math}
\\pagestyle{empty}             % do not remove
% The settings below are copied from fullpage.sty
\\setlength{\\textwidth}{\\paperwidth}
\\addtolength{\\textwidth}{-3cm}
\\setlength{\\oddsidemargin}{1.5cm}
\\addtolength{\\oddsidemargin}{-2.54cm}
\\setlength{\\evensidemargin}{\\oddsidemargin}
\\setlength{\\textheight}{\\paperheight}
\\addtolength{\\textheight}{-\\headheight}
\\addtolength{\\textheight}{-\\headsep}
\\addtolength{\\textheight}{-\\footskip}
\\addtolength{\\textheight}{-3cm}
\\setlength{\\topmargin}{1.5cm}
\\addtolength{\\topmargin}{-2.54cm}")
 '(org-format-latex-options
   '(:foreground default :background default :scale 1.2 :html-foreground "Black" :html-background "Transparent" :html-scale 1.2 :matchers
		 ("begin" "\\(" "\\[")))
 '(org-habit-following-days 3)
 '(org-habit-graph-column 38)
 '(org-habit-preceding-days 45)
 '(org-habit-scheduled-past-days 10000)
 '(org-habit-show-all-today nil)
 '(org-habit-show-done-always-green t)
 '(org-habit-show-habits-only-for-today nil)
 '(org-hide-leading-stars t)
 '(org-hierarchical-todo-statistics t)
 '(org-latex-classes
   '(("beamer" "\\documentclass[presentation]{beamer}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("article" "\\documentclass{article}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("report" "\\documentclass[11pt]{report}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("book" "\\documentclass[11pt]{book}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
 '(org-latex-compiler "xelatex")
 '(org-latex-default-packages-alist
   '(("AUTO" "inputenc" t
      ("pdflatex"))
     ("T1" "fontenc" t
      ("pdflatex"))
     ("" "graphicx" t nil)
     ("" "grffile" t nil)
     ("" "longtable" nil nil)
     ("" "wrapfig" nil nil)
     ("" "rotating" nil nil)
     ("normalem" "ulem" t nil)
     ("" "amsmath" t nil)
     ("" "textcomp" t nil)
     ("" "amssymb" t nil)
     ("" "capt-of" nil nil)
     ("" "hyperref" nil nil)))
 '(org-latex-packages-alist
   '(("14pt" "extsizes" nil)
     ("left=23mm,right=8mm,top=10mm,bottom=25mm" "geometry" nil)
     ("warn" "mathtext" t)
     ("" "fontspec" t)
     ("" "unicode-math" t)
     ("" "titlesec" nil)
     ("" "parskip" nil)
     ("" "float" nil)
     ("" "fancyhdr" nil)
     ("" "indentfirst" nil)
     ("AUTO" "polyglossia" nil)
     ("shortcuts" "extdash" nil)
     ("" "hhline" nil)
     ("" "subcaption" nil)
     ("" "adjustbox" nil)
     ("" "multirow" nil)
     ("" "lscape" nil)
     ("" "array" nil)
     ("" "makecell" nil)
     ("" "xpatch" nil)
     ("" "enumitem" nil)
     ("" "setspace" nil)
     ("dvipsnames" "xcolor" t)
     ("" "paracol" nil)))
 '(org-list-allow-alphabetical t)
 '(org-log-into-drawer t)
 '(org-modules
   '(ol-bbdb ol-bibtex ol-docview ol-eww ol-gnus org-habit ol-info ol-irc ol-mhe ol-rmail org-tempo ol-w3m))
 '(org-num-skip-commented t)
 '(org-num-skip-footnotes t)
 '(org-num-skip-tags '("noexport"))
 '(org-num-skip-unnumbered t)
 '(org-pretty-entities t)
 '(org-preview-latex-default-process 'dvisvgm)
 '(org-preview-latex-process-alist
   '((dvipng :programs
	     ("latex" "dvipng")
	     :description "dvi > png" :message "you need to install the programs: latex and dvipng." :image-input-type "dvi" :image-output-type "png" :image-size-adjust
	     (1.0 . 1.0)
	     :latex-compiler
	     ("latex -interaction nonstopmode -output-directory %o %f")
	     :image-converter
	     ("dvipng -D %D -T tight -o %O %f"))
     (dvisvgm :programs
	      ("xelatex" "dvisvgm")
	      :description "xdv > svg" :message "you need to install the programs: xelatex and dvisvgm." :image-input-type "xdv" :image-output-type "svg" :image-size-adjust
	      (1.7 . 1.5)
	      :latex-compiler
	      ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
	      :image-converter
	      ("dvisvgm %f -n -b min -c %S -o %O"))
     (imagemagick :programs
		  ("xelatex" "convert")
		  :description "pdf > png" :message "you need to install the programs: xelatex and imagemagick." :image-input-type "pdf" :image-output-type "png" :image-size-adjust
		  (1.0 . 1.0)
		  :latex-compiler
		  ("xelatex -interaction nonstopmode -output-directory %o %f")
		  :image-converter
		  ("convert -density %D -trim -antialias %f -quality 100 %O"))))
 '(org-provide-todo-statistics
   '(("TOREAD" "TODO" "TOPREPARE" "READY" "READING" "FINISHED")
     ("DONE" "GIVEN" "ANALIZED" "REGISTERED")))
 '(org-return-follows-link t)
 '(org-special-ctrl-a/e t)
 '(org-special-ctrl-k t)
 '(org-special-ctrl-o t)
 '(org-startup-indented t)
 '(org-structure-template-alist
   '(("s" . "src")
     ("e" . "example")
     ("q" . "quote")
     ("v" . "verse")
     ("V" . "verbatim")
     ("c" . "center")
     ("C" . "comment")
     ("l" . "export latex")
     ("h" . "export html")
     ("a" . "export ascii")))
 '(org-superstar-headline-bullets-list '("☯" "☢" "☮" "☸" "☣"))
 '(org-superstar-item-bullet-alist '((42 . 10132) (43 . 10172) (45 . 10148)))
 '(org-superstar-leading-bullet "-")
 '(org-superstar-leading-fallback 45)
 '(org-superstar-special-todo-items nil)
 '(org-superstar-todo-bullet-alist
   '(("TODO" . 9744)
     ("DONE" . 9745)
     ("TOPREPARE" . 9888)
     ("READY" . 9995)
     ("GIVEN" . 9996)
     ("TOREAD" . 9842)
     ("READING" . 9850)
     ("FINISHED" . 9851)
     ("ANALIZED" . 9852)))
 '(org-tags-column -80)
 '(org-tempo-keywords-alist
   '(("L" . "latex")
     ("T" . "attr_latex")
     ("H" . "html")
     ("A" . "ascii")
     ("i" . "index")
     ("n" . "name")
     ("S" . "startup")
     ("o" . "options")
     ("p" . "caption")))
 '(org-use-fast-todo-selection 'prefix)
 '(org-use-sub-superscripts '{})
 '(package-selected-packages
   '(org-ql org-mind-map disk-usage smex multiple-cursors dired-rainbow dired-subtree dired-narrow all-the-icons-dired org-superstar shrface org-noter-pdftools w3m org-pdftools doom-modeline nov cdlatex org-download minions telega fontawesome emacs-lisp-mode use-package company-quickhelp slime-company company-auctex company-emoji company-math company-shell company pdf-tools all-the-icons-ibuffer doom-themes all-the-icons auctex rainbow-delimiters slime smartparens vterm))
 '(save-place-mode t)
 '(send-mail-function 'mailclient-send-it)
 '(shift-select-mode nil)
 '(show-paren-highlight-openparen nil)
 '(shr-use-fonts nil)
 '(sp-base-key-bindings 'sp)
 '(sp-highlight-pair-overlay nil)
 '(sp-highlight-wrap-overlay nil)
 '(sp-highlight-wrap-tag-overlay nil)
 '(sp-ignore-modes-list '(minibuffer-inactive-mode))
 '(sp-navigate-close-if-unbalanced t)
 '(telega-chat-fill-column 70)
 '(telega-chat-prompt-show-avatar-for '(and has-avatar (permission :can_send_messages)))
 '(telega-chat-title-emoji-use-images nil)
 '(telega-chat-use-markdown-version nil)
 '(telega-emoji-font-family "\"Noto Color Emoji\"")
 '(telega-emoji-fuzzy-match t)
 '(telega-emoji-use-images nil)
 '(telega-notifications-call-args nil)
 '(telega-notifications-defaults nil)
 '(telega-notifications-delay 0.2)
 '(telega-notifications-msg-args '(:timeout 5000 :urgency normal))
 '(telega-notifications-msg-body-limit 30)
 '(telega-notifications-timeout 10.0)
 '(telega-root-fill-column 80)
 '(telega-sticker-set-show-emoji t)
 '(telega-sticker-size '(4 . 24))
 '(telega-url-shorten-mode-for 'all)
 '(telega-webpage-fill-column 80)
 '(typit-dict "english.txt")
 '(typit-dict-dir "/home/daniel/.emacs.d/elpa/typit-20200217.2059/dict/")
 '(typit-test-time 120)
 '(version-control t)
 '(visual-fill-column-center-text t)
 '(visual-fill-column-fringes-outside-margins nil)
 '(vterm-always-compile-module t)
 '(vterm-buffer-name-string "Terminal")
 '(vterm-clear-scrollback-when-clearing t)
 '(vterm-kill-buffer-on-exit t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-quoted ((t (:family "DejaVu Sans Mono"))))
 '(epe-pipeline-time-face ((t (:foreground "orange"))))
 '(telega-entity-type-code ((t (:family "DejaVu Sans Mono"))))
 '(telega-entity-type-pre ((t (:family "DejaVu Sans Mono"))))
 '(underline ((t (:underline t)))))

(eval-when-compile
  (require 'use-package))

(require 'bind-key)

(use-package auto-package-update
  :ensure t
  :config
  (auto-package-update-maybe))

(use-package system-packages
  :ensure t
  :config
  (setq system-packages-use-sudo t)
  (setq system-packages-package-manager 'pacman))

(use-package use-package-ensure-system-package
  :ensure t)

(use-package doom-themes
  :if window-system
  :ensure t
  :config
  (load-theme 'doom-Iosvkem t)
  (doom-themes-org-config)
  (doom-themes-visual-bell-config)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (fringe-mode -1)
  (scroll-bar-mode -1))

(use-package doom-modeline
  :if window-system
  :ensure t
  :init
  (setq doom-modeline-minor-modes t)
  (setq doom-modeline-buffer-encoding nil)
  (setq inhibit-compacting-font-caches t)
  (doom-modeline-mode 1))

(use-package minions
  :ensure t
  :config
  (minions-mode 1))

(use-package all-the-icons
  :ensure t)

(use-package all-the-icons-dired
  :ensure t)

(use-package all-the-icons-ibuffer
  :ensure t
  :init (all-the-icons-ibuffer-mode 1))

(use-package ido
  :config
  (ido-mode 1))

(use-package smex
  :ensure t
  :bind (("M-x" . smex)
	 ("M-X" . smex-major-mode-commands)
	 ("C-c M-x" . execute-extended-command))
  :config (smex-initialize))

(use-package abbrev
  :config
  (setq save-abbrevs 'silently)
  (setq-default abbrev-mode t))

(use-package dired
  :hook ((dired-mode . all-the-icons-dired-mode))
  :config
  (require 'dired-x))

(use-package dired-narrow
  :ensure t
  :bind (:map dired-mode-map
              ("/" . dired-narrow)))

(use-package dired-subtree
  :ensure t
  :config
  (bind-keys :map dired-mode-map
             ("i" . dired-subtree-insert)
             (";" . dired-subtree-remove)))

(use-package dired-rainbow
  :ensure t
  :config
  (progn
    (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx" "cbr"))
    (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define media "#de751f" ("mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac" "m4a" "m4b"))
    (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    (dired-rainbow-define log "#c17d11" ("log"))
    (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
    (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*")))

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer)
  :config
  (setq all-the-icons-ibuffer-icon-size 1.0)
  (setq all-the-icons-ibuffer-icon-v-adjust 0.1)
  (setq all-the-icons-ibuffer-human-readable-size t))

(use-package vterm
  :ensure t)

(use-package smartparens-config
  :ensure smartparens
  :config
  (sp-pair "\\[" "\\]")
  (sp-local-pair 'org-mode "“" "”"
		 :actions '(insert navigate))
  (sp-local-pair 'org-mode "‘" "’"
		 :actions '(insert navigate))
  (sp-local-pair 'LaTeX-mode "“" "”"
		 :actions '(insert navigate))
  (sp-local-pair 'LaTeX-mode "‘" "’"
		 :actions '(insert navigate))
  (smartparens-global-mode 1))

(use-package rainbow-delimiters
  :ensure t)

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (use-package company-emoji
    :ensure t
    :config (add-to-list 'company-backends 'company-emoji))
  (use-package company-quickhelp
    :ensure t
    :config
    (define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin)
    (company-quickhelp-mode 1))
  (use-package company-math
    :ensure t
    :config
    (add-to-list 'company-backends 'company-math-symbols-latex)
    (add-to-list 'company-backends 'company-math-symbols-unicode))
  (use-package company-shell
    :ensure t
    :config
    (add-to-list 'company-backends '(company-shell company-shell-env))))

(use-package slime-company
  :after (slime company)
  :config
  (setq slime-company-completion 'fuzzy
        slime-company-after-completion 'slime-company-just-one-space)
  (define-key company-active-map (kbd "\C-n") 'company-select-next)
  (define-key company-active-map (kbd "\C-p") 'company-select-previous)
  (define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
  (define-key company-active-map (kbd "M-.") 'company-show-location))

(use-package telega
  :ensure t
  :bind-keymap (("C-c t" . telega-prefix-map))
  :hook ((telega-load . global-telega-squash-message-mode)
         (telega-chat-mode . (lambda ()
			       (set (make-local-variable 'company-backends)
				    (append '(telega-company-emoji
					      telega-company-username
					      telega-company-hashtag)
					    (when (telega-chat-bot-p telega-chatbuf--chat)
					      '(telega-company-botcmd))))
			       (company-mode 1))))
  :config
  (telega-notifications-mode 1)
  (use-package telega-dired-dwim
    :load-path "/home/daniel/.emacs.d/elisp"))

(use-package slime
  :ensure t
  :init
  (setq inferior-lisp-program "/bin/sbcl")
  (add-hook 'slime-mode-hook (lambda ()
			       (unless (slime-connected-p)
				 (save-excursion (slime)))))
  :hook ((slime-mode . rainbow-delimiters-mode)
	 (slime-repl-mode . rainbow-delimiters-mode))
  :config
  (use-package slime-autoloads
    :config
    (setq slime-contribs '(slime-repl inferior-slime slime-c-p-c slime-autodoc slime-asdf slime-banner slime-editing-commands slime-fancy-inspector slime-presentations slime-references slime-scratch slime-trace-dialog slime-quicklisp slime-company))))

(use-package ispell
  :config
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_GB,russian-aot,es_ANY")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_GB,russian-aot,es_ANY"))

(use-package org
  :bind (("C-c l" . org-store-link)
	 ("C-c c" . org-capture)
	 ("C-c a" . org-agenda))
  :init
  (setq org-default-notes-file "/home/daniel/notes.org")
  (setq org-todo-keyword-faces
	'(("TODO" . "orange red") ("DONE" . "blue")
	  ("TOPREPARE" . "red") ("READY" . "gold")
	  ("GIVEN" . "green") ("TOREAD" . "red")
	  ("READING" . "gold") ("FINISHED" . "green")
	  ("ANALIZED" . "gray") ("TOSTUDY" . "orange red")
	  ("TOWATCH" . "dark orange") ("WATCHED" . "medium spring green")
	  ("STUDIED" . "cyan") ("PREPARED" . "deep sky blue")
	  ("CANCELLED" . "dim gray") ("REGISTERED" . "deep sky blue")))
  (defun org-summary-todo (n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise."
    (let (org-log-done org-log-states)   ; turn off logging
      (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
  :hook ((org-after-todo-statistics . org-summary-todo)
	 (org-mode . flyspell-mode)
	 (org-mode . turn-on-org-cdlatex)
	 (org-mode . font-lock-mode)
	 (org-mode . hl-line-mode)
	 (org-mode . (lambda () (company-mode -1))))
  :config
  (use-package org-pdftools
    :ensure t
    :hook (org-mode . org-pdftools-setup-link))
  (use-package org-noter
    :ensure t)
  (use-package org-superstar
    :if window-system
    :ensure t
    :hook (org-mode . (lambda () (org-superstar-mode 1))))
  (use-package org-download
    :ensure t
    :hook ((dired-mode . org-download-enable)
	   (org-mode . org-download-enable)))
  (defun drp-color-export (path description format)
    (cond ((eq format 'latex)
	   (format "\\textcolor{%s}{%s}" path description))))
  (defun drp-color-face (path)
    (list :foreground path))
  (org-link-set-parameters
   "color"
   :export 'drp-color-export
   :face 'drp-color-face))

(use-package pdf-tools
  :ensure t
  :demand
  :magic ("%PDF" . pdf-view-mode)
  :hook (pdf-view-mode . (lambda () (visual-fill-column-mode -1)))
  :config
  (pdf-tools-install)
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))

(use-package shrface
  :ensure t
  :demand
  :config
  (shrface-basic)
  (setq shrface-href-versatile t)
  (setq shrface-toggle-bullets nil))

(use-package nov
  :ensure t
  :after (shrface)
  :demand
  :mode ("\\.epub\\'" . nov-mode)
  :hook ((nov-mode . visual-line-mode)
	 (nov-mode . visual-fill-column-mode)
	 (nov-mode . shrface-mode))
  :config
  (setq nov-variable-pitch nil)
  (setq nov-text-width t))

(use-package eww
  :hook ((eww-after-render . shrface-mode)))

;; (use-package org-noter-pdftools
;;   :after org-noter
;;   :config
;;   (with-eval-after-load 'pdf-annot
;;     (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

(use-package cdlatex
  :ensure t)

(use-package tex
  :ensure auctex
  :hook
  ((LaTeX-mode . flyspell-mode)
   (LaTeX-mode . (lambda () (set (make-local-variable 'TeX-electric-math)
				 (cons "\\(" "\\)"))))
   (LaTeX-mode . cdlatex-mode)
   (LaTeX-mode . TeX-source-correlate-mode)
   (LaTeX-mode . LaTeX-math-mode)
   (LaTeX-mode . rainbow-delimiters-mode)
   (LaTeX-mode . hl-line-mode)
   (TeX-after-compilation-finished . TeX-revert-document-buffer))
  :config
  (setq TeX-parse-self t)
  (setq-default TeX-master t)
  (setq-default TeX-engine 'xetex)
  (setq-default TeX-PDF-mode t)
  (setq TeX-electric-sub-and-superscript t)
  (define-key cdlatex-mode-map  "$"         'nil)
  (define-key cdlatex-mode-map  "("         'nil)
  (define-key cdlatex-mode-map  "{"         'nil)
  (define-key cdlatex-mode-map  "["         'nil)
  (define-key cdlatex-mode-map  "|"         'nil)
  (define-key cdlatex-mode-map  "<"         'nil))

(use-package multiple-cursors
  :ensure t
  :demand
  :bind (("C-c m c" . mc/edit-lines)
	 ("C-c m n" . mc/mark-next-like-this)
	 ("C-c m p" . mc/mark-previous-like-this)
	 ("C-c m a" . mc/mark-all-like-this)
	 ("C-c m m" . mc/mark-pop)
	 ("C-c m b" . mc/edit-beginnings-of-lines)
	 ("C-c m e" . mc/edit-ends-of-lines)
	 ("<M-S-mouse-1>" . mc/add-cursor-on-click)))

(use-package image-mode
  :hook (image-mode . (lambda () (visual-fill-column-mode -1))))

(use-package aweshell
  :load-path "/home/daniel/.emacs.d/aweshell")

(use-package w3m
  :ensure t)

(use-package disk-usage
  :ensure t)

(use-package fontawesome
  :ensure t)

(use-package quail
  :config
  (add-to-list 'quail-keyboard-layout-alist '("workman" . "                                1!2@3#4$5%6^7&8*9(0)-_=+`~    qQdDrRwWbBjJfFuUpP;:[{]}      aAsShHtTgGyYnNeEoOiI'\"\\|      zZxXmMcCvVkKlL,<.>/?                                      "))
  (quail-set-keyboard-layout "workman"))

(use-package org-mind-map
  :init
  (require 'ox-org)
  :ensure t
  :ensure-system-package (gvgen . graphviz)
  :config
  (setq org-mind-map-engine "dot"))

;; Load the dependencies and then elgantt
(use-package org-ql
  :ensure t)
(use-package ts
  :ensure t)
(use-package s
  :ensure t)
(use-package dash
  :ensure t)
(add-to-list 'load-path "/home/daniel/.emacs.d/elisp/elgantt/")
(require 'elgantt)

;; Code to set the gradient between the scheduled and deadline dates
(setq elgantt-user-set-color-priority-counter 0)
(elgantt-create-display-rule draw-scheduled-to-deadline
  :parser ((elgantt-color . ((when-let ((colors (org-entry-get (point) "ELGANTT-COLOR")))
                               (s-split " " colors)))))
  :args (elgantt-scheduled elgantt-color elgantt-org-id)
  :body ((when elgantt-scheduled
           (let ((point1 (point))
                 (point2 (save-excursion
                           (elgantt--goto-date elgantt-scheduled)
                           (point)))
                 (color1 (or (car elgantt-color)
                             "black"))
                 (color2 (or (cadr elgantt-color)
                             "red")))
             (when (/= point1 point2)
               (elgantt--draw-gradient
                color1
                color2
                (if (< point1 point2) point1 point2) ;; Since cells are not necessarily linked in
                (if (< point1 point2) point2 point1) ;; chronological order, make sure they are sorted
                nil
                `(priority ,(setq elgantt-user-set-color-priority-counter
                                  (1- elgantt-user-set-color-priority-counter))
                           ;; Decrease the priority so that earlier entries take
                           ;; precedence over later ones (note: it doesn’t matter if the number is negative)
                           :elgantt-user-overlay ,elgantt-org-id)))))))

;; Set the file (or files) to be checked when creating the chart
(setq elgantt-agenda-files "~/.emacs.d/elisp/elgantt/test.org")

;; Set the default values to show the gantt chart
(setq elgantt-header-type 'outline
      elgantt-insert-blank-line-between-top-level-header t
      elgantt-startup-folded nil
      elgantt-show-header-depth t
      elgantt-draw-overarching-headers t)

;; (load-file "/home/daniel/.emacs.d/emacs-yeis/yeis.el")
;; (load-file "/home/daniel/.emacs.d/emacs-yeis/x-leim/robin-packages.el")
;; (load-file "/home/daniel/.emacs.d/emacs-yeis/x-leim/x-leim-list.el")
;; (setq default-input-method "robin-russian-workman")
;; (setq-default robin-current-package-name "robin-russian-workman")
;; (setq yeis-path-plain-word-list "/home/daniel/.emacs.d/emacs-yeis/wordlist")
;; (global-set-key (kbd "C-x C-\\") 'yeis-transform-previous-word)

;; Set and bind functions to insert opening and closing UTF-8 quotes in the buffer
(defun drp-insert-open-quotes ()
  (interactive)
  (execute-kbd-macro "“"))
(global-set-key (kbd "C-c d s \"") 'drp-insert-open-quotes)

(defun drp-insert-open-single-quotes ()
  (interactive)
  (execute-kbd-macro "‘"))
(global-set-key (kbd "C-c d s \'") 'drp-insert-open-single-quotes)

;; Create command to insert horizontal ellipsis instead of using 3 dots in a row
(defun drp-insert-horizontal-ellipsis ()
  (interactive)
  (insert-char '#x2026))
(global-set-key (kbd "C-c d s .") 'drp-insert-horizontal-ellipsis)

;; Command to insert check and cross marks
(defun drp-insert-check ()
  (interactive)
  (insert-char '#x2713))
(global-set-key (kbd "C-c d s t") 'drp-insert-check)

(defun drp-insert-cross ()
  (interactive)
  (insert-char '#x274C))
(global-set-key (kbd "C-c d s c") 'drp-insert-cross)

;; Load the alarm file
(load-file "/home/daniel/.emacs.d/elisp/drp-alarm-clock.el")

;; Set rainbow delimiters for emacs lisp
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)

;; Load mode to open rtf files
(load-file "/home/daniel/.emacs.d/elisp/rtf-mode.el")
(require 'rtf-mode)

;; Set different fonts to show unicode characters.
(set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend)
(set-fontset-font t 'symbol (font-spec :family "STIX Math") nil 'prepend)
(set-fontset-font t 'symbol (font-spec :family "DejaVu Sans") nil 'prepend)

;; Set general default font
(set-face-attribute 'default nil :font "Iosevka Term-10")

;; Set registers to open some files faster
(set-register ?w '(file . "/home/daniel/work.org"))
(set-register ?r '(file . "/home/daniel/read.org"))
(set-register ?n '(file . "/home/daniel/notes.org"))
(set-register ?h '(file . "/home/daniel/habits.org"))
(set-register ?s '(file . "/home/daniel/study.org"))
(set-register ?i '(file . "/home/daniel/.emacs.d/init.el"))
(set-register ?I '(file . "/home/daniel/.stumpwm.d/init.lisp"))

;; Use the function downcase region with C-x C-l
(put 'downcase-region 'disabled nil)
