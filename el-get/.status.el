((apel status "installed" recipe
       (:name apel :website "http://www.kanji.zinbun.kyoto-u.ac.jp/~tomo/elisp/APEL/" :description "APEL (A Portable Emacs Library) is a library to support to write portable Emacs Lisp programs." :type github :pkgname "wanderlust/apel" :build
	      (mapcar
	       (lambda
		 (target)
		 (list el-get-emacs
		       (split-string "-batch -q -no-site-file -l APEL-MK -f")
		       target "prefix" "site-lisp" "site-lisp"))
	       '("compile-apel" "install-apel"))
	      :load-path
	      ("site-lisp/apel" "site-lisp/emu")))
 (el-get status "installed" recipe
	 (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
		("el-get.*\\.el$" "methods/")
		:load "el-get.el"))
 (emacs-w3m status "installed" recipe
	    (:name emacs-w3m :description "A simple Emacs interface to w3m" :type cvs :module "emacs-w3m" :url ":pserver:anonymous@cvs.namazu.org:/storage/cvsroot" :build
		   `("autoconf"
		     ("./configure" ,(concat "--with-emacs=" el-get-emacs))
		     "make")
		   :build/windows-nt
		   ("sh /usr/bin/autoconf" "sh ./configure" "make")
		   :info "doc"))
 (emms status "installed" recipe
       (:name emms :description "The Emacs Multimedia System" :type git :url "git://git.sv.gnu.org/emms.git" :info "doc" :load-path
	      ("./lisp")
	      :features emms-setup :build
	      `(,(format "mkdir -p %s/emms " user-emacs-directory)
		,(concat "make EMACS=" el-get-emacs " SITEFLAG=\"--no-site-file -L " el-get-dir "/emacs-w3m/ \"" " autoloads lisp docs"))
	      :depends emacs-w3m))
 (expand-region status "installed" recipe
		(:name expand-region :type github :pkgname "magnars/expand-region.el" :description "Expand region increases the selected region by semantic units. Just keep pressing the key until it selects what you want." :website "https://github.com/magnars/expand-region.el#readme" :features expand-region))
 (flim status "installed" recipe
       (:name flim :description "A library to provide basic features about message representation or encoding" :depends apel :type github :branch "flim-1_14-wl" :pkgname "wanderlust/flim" :build
	      (mapcar
	       (lambda
		 (target)
		 (list el-get-emacs
		       (mapcar
			(lambda
			  (pkg)
			  (mapcar
			   (lambda
			     (d)
			     `("-L" ,d))
			   (el-get-load-path pkg)))
			'("apel"))
		       (split-string "-batch -q -no-site-file -l FLIM-MK -f")
		       target "prefix" "site-lisp" "site-lisp"))
	       '("compile-flim" "install-flim"))
	      :load-path
	      ("site-lisp/flim")))
 (multiple-cursors status "installed" recipe
		   (:name multiple-cursors :description "An experiment in adding multiple cursors to emacs" :type github :pkgname "magnars/multiple-cursors.el" :features multiple-cursors))
 (semi status "installed" recipe
       (:name semi :description "SEMI is a library to provide MIME feature for GNU Emacs." :depends flim :type github :branch "semi-1_14-wl" :pkgname "wanderlust/semi" :build
	      (mapcar
	       (lambda
		 (target)
		 (list el-get-emacs
		       (mapcar
			(lambda
			  (pkg)
			  (mapcar
			   (lambda
			     (d)
			     `("-L" ,d))
			   (el-get-load-path pkg)))
			'("apel" "flim"))
		       (split-string "-batch -q -no-site-file -l SEMI-MK -f")
		       target "prefix" "site-lisp" "site-lisp"))
	       '("compile-semi" "install-semi"))
	      :load-path
	      ("site-lisp/semi/")))
 (wanderlust status "installed" recipe
	     (:name wanderlust :description "Wanderlust bootstrap." :depends semi :type github :pkgname "wanderlust/wanderlust" :build
		    (mapcar
		     (lambda
		       (target-and-dirs)
		       (list el-get-emacs
			     (mapcar
			      (lambda
				(pkg)
				(mapcar
				 (lambda
				   (d)
				   `("-L" ,d))
				 (el-get-load-path pkg)))
			      (append
			       '("apel" "flim" "semi")
			       (when
				   (el-get-package-exists-p "bbdb")
				 (list "bbdb"))))
			     "--eval"
			     (el-get-print-to-string
			      '(progn
				 (setq wl-install-utils t)
				 (setq wl-info-lang "en")
				 (setq wl-news-lang "en")))
			     (split-string "-batch -q -no-site-file -l WL-MK -f")
			     target-and-dirs))
		     '(("wl-texinfo-format" "doc")
		       ("compile-wl-package" "site-lisp" "icons")
		       ("install-wl-package" "site-lisp" "icons")))
		    :info "doc/wl.info" :load-path
		    ("site-lisp/wl" "utils"))))
