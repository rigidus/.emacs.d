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
 (cl-lib status "installed" recipe
         (:name cl-lib :builtin "24.3" :type elpa :description "Properly prefixed CL functions and macros" :website "http://elpa.gnu.org/packages/cl-lib.html"))
 (cmake-ide status "installed" recipe
            (:name cmake-ide :description "Calls CMake to find out include paths and other compiler flags." :type github :pkgname "atilaneves/cmake-ide" :minimum-emacs-version "24.1" :depends
                   (cl-lib seq levenshtein)))
 (dash status "installed" recipe
       (:name dash :description "A modern list api for Emacs. No 'cl required." :type github :pkgname "magnars/dash.el"))
 (el-get status "installed" recipe
         (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
                ("el-get.*\\.el$" "methods/")
                :features el-get :post-init
                (when
                    (memq 'el-get
                          (bound-and-true-p package-activated-list))
                  (message "Deleting melpa bootstrap el-get")
                  (unless package--initialized
                    (package-initialize t))
                  (when
                      (package-installed-p 'el-get)
                    (let
                        ((feats
                          (delete-dups
                           (el-get-package-features
                            (el-get-elpa-package-directory 'el-get)))))
                      (el-get-elpa-delete-package 'el-get)
                      (dolist
                          (feat feats)
                        (unload-feature feat t))))
                  (require 'el-get))))
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
 (gnuplot-mode status "installed" recipe
               (:name gnuplot-mode :description "Drive gnuplot from within emacs" :type github :pkgname "bruceravel/gnuplot-mode" :build
                      `(("autoreconf" "-f" "-i")
                        ("./configure")
                        ("make" ,(concat "EMACS=" el-get-emacs)
                         "gnuplot.elc" "gnuplot-gui.elc"))
                      :info "gnuplot.info"))
 (ht status "installed" recipe
     (:name ht :website "https://github.com/Wilfred/ht.el" :description "The missing hash table utility library for Emacs." :type github :pkgname "Wilfred/ht.el"))
 (levenshtein status "installed" recipe
              (:name levenshtein :description "Edit distance between two strings." :type emacswiki :features levenshtein))
 (loop status "installed" recipe
       (:name loop :website "https://github.com/Wilfred/loop.el" :description "friendly imperative loop structures for Emacs lisp." :type github :pkgname "Wilfred/loop.el"))
 (multiple-cursors status "installed" recipe
                   (:name multiple-cursors :description "An experiment in adding multiple cursors to emacs" :type github :pkgname "magnars/multiple-cursors.el" :features multiple-cursors))
 (mustache status "installed" recipe
           (:name mustache :website "https://github.com/Wilfred/mustache.el" :description "A mustache templating library for Emacs." :type github :depends
                  (dash ht s)
                  :pkgname "Wilfred/mustache.el"))
 (package status "installed" recipe
          (:name package :description "ELPA implementation (\"package.el\") from Emacs 24" :builtin "24" :type http :url "https://repo.or.cz/w/emacs.git/blob_plain/ba08b24186711eaeb3748f3d1f23e2c2d9ed0d09:/lisp/emacs-lisp/package.el" :features package :post-init
                 (progn
                   (let
                       ((old-package-user-dir
                         (expand-file-name
                          (convert-standard-filename
                           (concat
                            (file-name-as-directory default-directory)
                            "elpa")))))
                     (when
                         (file-directory-p old-package-user-dir)
                       (add-to-list 'package-directory-list old-package-user-dir)))
                   (setq package-archives
                         (bound-and-true-p package-archives))
                   (let
                       ((protocol
                         (if
                             (and
                              (fboundp 'gnutls-available-p)
                              (gnutls-available-p))
                             "https://"
                           (lwarn
                            '(el-get tls)
                            :warning "Your Emacs doesn't support HTTPS (TLS)%s"
                            (if
                                (eq system-type 'windows-nt)
                                ",\n  see https://github.com/dimitri/el-get/wiki/Installation-on-Windows." "."))
                           "http://"))
                        (archives
                         '(("melpa" . "melpa.org/packages/")
                           ("gnu" . "elpa.gnu.org/packages/")
                           ("marmalade" . "marmalade-repo.org/packages/"))))
                     (dolist
                         (archive archives)
                       (add-to-list 'package-archives
                                    (cons
                                     (car archive)
                                     (concat protocol
                                             (cdr archive)))))))))
 (s status "installed" recipe
    (:name s :description "The long lost Emacs string manipulation library." :type github :pkgname "magnars/s.el"))
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
 (seq status "installed" recipe
      (:name seq :description "Sequence manipulation functions" :builtin "25" :type elpa :website "https://elpa.gnu.org/packages/seq.html"))
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
                    ("site-lisp/wl" "utils")))
 (with-namespace status "installed" recipe
                 (:name with-namespace :website "https://github.com/Wilfred/with-namespace.el" :description "interoperable elisp namespaces." :type github :depends
                        (dash loop)
                        :pkgname "Wilfred/with-namespace.el")))
