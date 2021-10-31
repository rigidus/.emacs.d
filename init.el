;;
;;    ___ _ __ ___   __ _  ___ ___
;;   / _ \ '_ ` _ \ / _` |/ __/ __|
;;  |  __/ | | | | | (_| | (__\__ \
;; (_)___|_| |_| |_|\__,_|\___|___/
;;
;; EMACS configuration file by Rigidus
;;
;; Hint: text-scale-adjust настраивает размер в GUI
;; Документация Emacs находится в пакете emacs-common-non-dfsg.
;; Или emacs27-common-non-dfsg. Потом: C-h i

;;; Comment function
(defun comment-or-uncomment-this (&optional lines)
  (interactive "P")
  (if mark-active
      (if (< (mark) (point))
          (comment-or-uncomment-region (mark) (point))
	(comment-or-uncomment-region (point) (mark)))
    (comment-or-uncomment-region
     (line-beginning-position)
     (line-end-position lines))))

(global-set-key (kbd "C-x /")
 		'comment-or-uncomment-this)

;;; Debug-Init
(require 'cl)
(setq debug-on-error t)


;;; Выделение парных скобок
(show-paren-mode 1)

;;; выделять все выражение в скобках
;; (setq show-paren-style 'expression)

;;; Goto-line
(global-set-key [?\M-g] 'goto-line)
(global-set-key (kbd "\e\eg") 'goto-line)

;;; ТОЧКИ ЕМАКС (Антон Кульчицкий)
(defun user-cyrillic-redefinitions ()
  "Set of global keys binding for cyrillic.
   This function is to be called from user-toggle-input-method"
  (global-set-key (kbd "?") (lambda()(interactive)(insert ",")))
  (global-set-key (kbd "/") (lambda()(interactive)(insert ".")))
  (global-set-key (kbd ",") (lambda()(interactive)(insert ":")))
  (global-set-key (kbd ":") (lambda()(interactive)(insert "%")))
  (global-set-key (kbd "*") (lambda()(interactive)(insert ";")))
  (global-set-key (kbd ";") (lambda()(interactive)(insert "*")))
  (global-set-key (kbd ".") (lambda()(interactive)(insert "?"))))

(defun user-nil-redefinitions ()
  "Restoring global keys binding after user-cyrillic-redefinitions.
  This function is to be called from user-toggle-input-method"
  (global-set-key (kbd "?") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd "/") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd "$") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd ",") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd ":") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd "*") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd ";") (lambda()(interactive)(self-insert-command 1)))
  (global-set-key (kbd ".") (lambda()(interactive)(self-insert-command 1))))

(defun user-toggle-input-method ()
  "Change the stadart function tuggle-input-method
   to redefine keys for cyrillic input from UNIX type to win type"
  (interactive)
  (toggle-input-method)
  (if (string= current-input-method "cyrillic-jcuken")
      (user-cyrillic-redefinitions)
    (user-nil-redefinitions))
  (message "keybord changed to %s" current-input-method))

(defun user-to-cyr ()
  "Change input method to Cyrillic,
   I bound this function with Alt-Shift-9, that is M-("
  (interactive)
  (when (string= current-input-method nil)
    (user-toggle-input-method)))

(defun user-to-nil ()
  "Change input method to nil (generally to English),
   I bound this function with Alt-Sfift-0 that is M-)"
  (interactive)
  (when (string= current-input-method "cyrillic-jcuken")
    (user-toggle-input-method)))

(set-input-method "russian-computer")
(setq default-input-method 'russian-computer)
(user-toggle-input-method)

;;; Установка раскладки при переключении по С-\
(global-set-key (kbd "\C-\\") 'user-toggle-input-method)

;;; Meta-Meta-Shift

;; Итак, я предлагаю команду 'Meta-Meta-Shift-/' для того, чтобы
;; запомнить текущую позицию и команду 'Meta-Meta-/' для того, чтобы
;; перейти на запомненную позицию, прежде запомнив текущую.
(defun save-point-and-switch ()
  "Save current point to register 0 and go to the previously
   saved position"
 (interactive)
 (let (temp)
   (setq temp (point-marker))
   (when (not (equal (get-register 0) nil))
     (jump-to-register 0))
   (set-register 0 temp)))
;;
(defun save-point-only ()
 "Save current point to register 0"
 (interactive)
 (set-register 0 (point-marker)))
;;
(global-set-key (kbd "\e\e/") 'save-point-and-switch)
(global-set-key (kbd "\e\e?") 'save-point-only)

;;; What-Can-I-Do

(defun what-can-i-do ()
  (interactive)
  (let ((pattern "\\(\\[\\(TODO\\|VRFY\\|NOTE\\):gmm\\]\\)") ;; "\\(\\[TODO:.\\{3,\\}\\]\\)"
        (curbuff (current-buffer))
        (newbuff (generate-new-buffer "*what-can-i-do*")))
    (save-excursion
      (goto-char (point-min))
      (let ((cnt 0))
        (with-output-to-temp-buffer newbuff
          (while (re-search-forward pattern nil t)
            (incf cnt)
            (let ((buff  curbuff)
                  (point (point))
                  (line  (line-number-at-pos))
                  (contents (thing-at-point 'line)))
              (with-current-buffer newbuff
                (insert-text-button (format "%d:" line)
                                    'buff buff
                                    'point point
                                    'action (lambda (x)
                                              (let* ((pos   (posn-point (event-end x)))
                                                     (buff  (get-text-property pos 'buff))
                                                     (point (get-text-property pos 'point)))
                                                (with-current-buffer buff
                                                  (goto-char point))
                                                (switch-to-buffer buff))))
                (princ contents))))
          (goto-char (point-max))
          (princ (format "\nDone. %s finded." cnt))
          )))))
;;
(global-set-key (kbd "C-c m") 'what-can-i-do)


;;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.
;; See `package-archive-priorities` and `package-pinned-packages`
;; Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; Посмотреть установленные пакеты можно в переменной С-h v package-activated-list
;; Или вызвав эту функцию:
;; (defun list-packages-and-versions ()
;;   "Returns a list of all installed packages and their versions"
;;   (mapcar
;;    (lambda (pkg)
;;      `(,pkg ,(package-desc-version
;;               (cadr (assq pkg package-alist)))))
;;    package-activated-list))
;; (list-packages-and-versions) =>
;; ((ace-jump-mode (20140616 815))
;;  (color-theme-modern (20161219 1144))
;;  (gnuplot (20141231 2137))
;;  (gnuplot-mode (20171013 1616))
;;  (unfill (20170723 146))
;;  (wanderlust (20190812 818))
;;  (semi (20190708 1302))
;;  (flim (20190526 1034))
;;  (apel (20190407 1056)))

;; ;; For important compatibility libraries like cl-lib
;; (when (< emacs-major-version 24)
;;   (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;;   (package-initialize) ;; You might already have this line
;;   (add-to-list 'package-archives
;;                '("melpa-stable" . "https://stable.melpa.org/packages/") t))

;; ;; load emacs 24's package system. Add MELPA repository.
;; (when (>= emacs-major-version 24)
;;   (require 'package)
;;   ;; (add-to-list 'package-archives
;;   ;;              '("melpa" . "https://melpa.org/packages/"))
;;   (add-to-list
;;    'package-archives
;;    ;; many packages won't show if using stable
;;    ;; '("melpa" . "http://stable.melpa.org/packages/")
;;    '("melpa" . "http://melpa.milkbox.net/packages/")
;;    t))



;;; Unfill Region
;; https://www.emacswiki.org/emacs/UnfillRegion
(defun unfill-region (beg end)
  "Unfill the region, joining text paragraphs into a single
    logical line.  This is useful, e.g., for use with
    `visual-line-mode'."
  (interactive "*r")
  (let ((fill-column (point-max)))
    (fill-region beg end)))

;; Handy key definition
(define-key global-map "\C-\M-Q" 'unfill-region)


;;; Xah-show-kill-ring
(defun xah-show-kill-ring ()
  "Insert all `kill-ring' content in a new buffer named *copy history*.
URL `http://ergoemacs.org/emacs/emacs_show_kill_ring.html'
Version 2018-10-05"
  (interactive)
  (let (($buf (generate-new-buffer "*copy history*")))
    (progn
      (switch-to-buffer $buf)
      (funcall 'fundamental-mode)
      (setq buffer-offer-save t)
      (dolist (x kill-ring )
        (insert x "\n\u000cttt\n\n"))
      (goto-char (point-min)))
    (when (fboundp 'xah-show-formfeed-as-line)
      (xah-show-formfeed-as-line))))


;;; COMMON SETTINGS

(delete-selection-mode 1)   ;; <del> и BackSpace удаляют выделенный текст
(transient-mark-mode 1)     ;; Показывать выделенный текст

;;; Makes clipboard work
(setq x-select-enable-clipboard t)
;; (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;;; Escape-sequences
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;; Codepages. First detection for utf-8-unix
(prefer-coding-system 'cp866)
(prefer-coding-system 'koi8-r-unix)
(prefer-coding-system 'windows-1251-dos)
(prefer-coding-system 'utf-8-unix)

;;; Delete trailing whitespaces before saving file
(defun delete-trailing-whitespaces ()
  (interactive "*")
  (delete-trailing-whitespace))
(add-hook 'before-save-hook
          '(lambda ()
             (delete-trailing-whitespace)))

;;; Auto Fill Mode (disbled)
(setq default-major-mode 'text-mode)
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
(remove-hook 'text-mode-hook #'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(auto-fill-mode -1)
;; (setq auto-fill-mode t)
;; (setq fill-column 73)

;;; Backups
;; (info "(emacs)Auto Save")
(setq auto-save-interval 512)            ;; Количество нажатий до автосохранения
(setq auto-save-timeout 20)   ;; Автосохранение в перерыве между нажатиями (в секундах)
(setq backup-directory-alist             ;; Все временные копии в один каталог.
      '((".*" . "~/.emacs.d/backups")))  ;; Каталог создаётся автоматически.
(setq backup-by-copying t)               ;; Режим сохранения копий
(setq version-control t)                 ;; Создавать копии с номерами версий
(setq delete-old-versions t)             ;; Удалять старые версии без подтверждения
(setq kept-new-versions 6)               ;; нумерованный бэкап - 2 первых и 2 последних
(setq kept-old-versions 2)

;;; Optimization
;; limit on number of Lisp variable bindings & unwind-protects
(setq max-specpdl-size (* 10 max-specpdl-size)) ; 10 * 1 M (default)
;; limit serving to catch infinite recursions for you before they
;; cause actual stack overflow in C, which would be fatal for Emacs
(setq max-lisp-eval-depth (* 10 max-lisp-eval-depth)) ; 10 * 400 (default)
;; speed up things by preventing garbage collections
(setq gc-cons-threshold (* 10 gc-cons-threshold)) ; 10 * 400 KB (default)

;;; INTERFACE

(menu-bar-mode -1)                   ;; Делаем емакс аскетичным
(tool-bar-mode -1)
(setq column-number-mode t)          ;; Показывать номер текущей колонки
(setq line-number-mode t)            ;; Показывать номер текущей строки
(setq inhibit-startup-message t)     ;; Не показываем сообщение при старте
(fset 'yes-or-no-p 'y-or-n-p)	     ;; не заставляйте меня печать "yes" целиком
(setq echo-keystrokes 0.001)         ;; Мгновенное отображение набранных сочетаний клавиш
(setq use-dialog-boxes nil)          ;; Не использовать диалоговые окна
(setq cursor-in-non-selected-windows nil) ;; Не показывать курсоры в неактивных окнах
(setq default-tab-width 4)           ;; размер табуляции
(setq c-basic-offset 4)              ;; табуляция (Tabulation) для режимов,
(setq tab-width 4)                   ;; основанных на c-mode
(setq cperl-indent-level 4)          ;; и для
(setq sgml-basic-offset 4)           ;; HTML-mode и XML-mode
(setq-default indent-tabs-mode nil)  ;; отступ только пробелами
(setq initial-scratch-message nil)   ;; Scratch buffer settings. Очищаем его.
(setq case-fold-search t)            ;; Поиск без учёта регистра
(global-font-lock-mode t)            ;; Поддержка различных начертаний шрифтов в буфере
(setq font-lock-maximum-decoration t);; Максимальное использование различных начертаний шрифтов
(if window-system (setq scalable-fonts-allowed t)) ;; Масштабируемые шрифты в GUI
(setq read-file-name-completion-ignore-case t) ;; Дополнение имён файлов без учёта регистра
(file-name-shadow-mode t)            ;; Затенять игнорируемую часть имени файла
(setq resize-mini-windows t)         ;; Изменять при необходимости размер минибуфера по вертикали
(auto-image-file-mode t)             ;; Показывать картинки
(setq read-quoted-char-radix 10)     ;; Ввод символов по коду в десятичном счислении `C-q'
(put 'upcase-region 'disabled nil)   ;; Разрешить поднимать регистр символов
(put 'downcase-region 'disabled nil) ;; Разрешить опускать регистр символов
(put 'narrow-to-region 'disabled nil);; Разрешить ограничение редактирования только в выделенном участке
(put 'narrow-to-page 'disabled nil)  ;; Разрешить ограничение редактирования только на текущей странице
(setq scroll-step 1)                 ;; Перематывать по одной строке
(setq temp-buffer-max-height         ;; Максимальная высота временного буфера
      (lambda (buffer)
        (/ (- (frame-height) 2) 3)))
(temp-buffer-resize-mode t)          ;; Высота временного буфера зависит от его содержимого
(setq frame-title-format '("" "%b @ Emacs " emacs-version)) ;; Заголовок окна
(setq scroll-conservatively 50)      ;; Гладкий скроллинг с полями
(setq scroll-preserve-screen-position 't)
(setq scroll-margin 10)
(setq my-author-name (getenv "USER"))
(setq user-full-name (getenv "USER"))
(setq require-final-newline t)       ;; always end a file with a newline
(set-cursor-color "red")             ;; Красный не мигающий (!) курсор
(blink-cursor-mode nil)
;; Однако в режиме терминала это не работает, поэтому..
(if (not (display-graphic-p))
    (progn ;; GUI/Terminal Mode
      (send-string-to-terminal "\033]12;red\007"))
  (progn   ;; else: GUI-mode
    ;; Максимизация окна при запуске в GUI-mode
    (add-to-list 'default-frame-alist '(fullscreen . maximized))))

(set-face-attribute 'default (selected-frame) :height 170)
;; Mouse
(global-set-key [vertical-scroll-bar down-mouse-1]
                'scroll-bar-drag) ;; Scroll Bar gets dragged by mouse btn 1
(setq mouse-yank-at-point 't)        ;; Paste at point NOT at cursor

;; Правила открытия буферов
;; (split-window-right)
(setq split-height-threshold nil)
(setq split-width-threshold 80)

;; Хочу чтобы inferior shell открывался в том же окне
(add-to-list 'display-buffer-alist
             `(,(rx bos "*shell*")
               display-buffer-same-window))

;; Aligning the code from the clipboard
(defadvice yank (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode c-mode c++-mode
                                objc-mode latex-mode plain-tex-mode python-mode))
      (indent-region (region-beginning) (region-end) nil)))

(defadvice yank-pop (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode c-mode c++-mode
                                objc-mode latex-mode plain-tex-mode python-mode))
      (indent-region (region-beginning) (region-end) nil)))


;; Заменить окончания строк в формате DOS ^M на Unix
(defun dos-to-unix ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match ""))))


;; Поиск в Google по содержимому региона
(defun google-region (beg end)
  "Google the selected region."
  (interactive "r")
  (browse-url (concat "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
                      (buffer-substring beg end))))

;; Поиск в Yandex по содержимому региона
(defun yandex-region (beg end)
  "Google the selected region."
  (interactive "r")
  (browse-url (concat "http://yandex.ru/yandsearch?text="
                      (buffer-substring beg end))))


;; Code-Blocks
;; #+BEGIN_SRC #+END_SRC CODEBLOCK
;; http://ergoemacs.org/emacs/emacs_macro_example.html
;; http://ergoemacs.org/emacs/keyboard_shortcuts.html
(defun codeblock ()
  (insert "#+END_SRC")
  (move-beginning-of-line 1)
  (newline)
  (previous-line)
  (insert "#+BEGIN_SRC "))

(global-set-key (kbd "C-x [")
                '(lambda ()
                   (interactive)
                   (set-input-method nil)
                   (codeblock)))

(global-set-key (kbd "C-x ]")
                '(lambda ()
                  (interactive)
                  (set-input-method nil)
                  (insert "#+NAME:")
                  (newline)))

;;; Fast-Jumps
;; В целях дальнейшего улучшения эргономики и отказа
;; от лишних клавиш (таких как клавиши курсора) и
;; планируемого перехода на клавиатуры уменьшенного
;; размера, добавим несколько комбинаций для
;; быстрого путешествия по тексту:
(global-set-key (kbd "M-n") 'org-forward-paragraph)
(global-set-key (kbd "M-p") 'org-backward-paragraph)
;; Также не стоит забывать про базовую комбинацию `M-r',
;; которая предоставляет удобный способ путешествовать
;; по трем позициям внутри текущего буфера.
;; Чтобы избежать использования DELETE можно использовать
;; `C-d' = delete-char
;; `M-d' = delete-word удаляет все слово
;; Клавиша BACKSPACE есть на 40%-х клавиатурах, поэтому
;; не нуждается в дополнительном определении.
;; Не стоит забывать про возможность использовать
;; команды удаления с `C-u' аргументом.

;; ;; conkeror-browser - пример вызова
;; (eval-after-load "browse-url"
;;   '(defun browse-url-conkeror (url &optional new-window)
;;      "ask the conkeror www browser to load url."
;;      (interactive (browse-url-interactive-arg "url: "))
;;      ;; url encode any `confusing' characters in the url. this needs to
;;      ;; include at least commas; presumably also close parens and dollars.
;;      (while (string-match "[,)$]" url)
;;        (setq url (replace-match
;; 				  (format "%%%x" (string-to-char (match-string 0 url)))
;; 				  t t url)))
;;      (let* ((process-environment (browse-url-process-environment))
;; 			(process
;; 			 (apply 'start-process
;; 					(concat "conkeror " url)
;; 					nil "conkeror"
;; 					(list url)))))))
;; ;; set conkeror-browser
;; (setq browse-url-browser-function 'browse-url-conkeror)


;;; EXTENSIONS

(add-to-list 'load-path "~/.emacs.d/lisp")

;;; SBCL

(setq inferior-lisp-program "sbcl --dynamic-space-size 2048")
(setq slime-lisp-implementations '((sbcl ("sbcl"))))
(setq slime-startup-animation nil)
;; Путь к локльной копии Common Lisp Hyper Specifications.
;; Если его не задавать - справка по функциям будет ходить в интернет
;; (setq common-lisp-hyperspec-root "file:///Users/lisp/HyperSpec")
;; Но есть способ оптимальнее:
;; - загрузить CLHS через Quicklisp в repl: (ql:quickload "clhs")
;; - запустить в repl: (clhs:print-emacs-setup-form):
;;   Он попросит выполнить:
;;   - (clhs:install-clhs-use-local)
;;   - (clhs:print-emacs-setup-form)
;;     И мы можем поместить сюда настройку:
(load "/home/rigidus/quicklisp/clhs-use-local.el" t)
;; Теперь "C-c C-d h" runs the command slime-documentation-lookup
;; И будет ходить за этим в локальную копию CLHS, что очень помогает
;; при отсутсвии подключения к интернету

;; SLIME
;; Путь к slime
;; (add-to-list 'load-path "~/quicklisp/dists/quicklisp/software/slime-2.4")
;; (require 'slime)
;;(setq slime-net-coding-system 'utf-8-unix)

;; SLIME-FANCY is a meta package which loads a combination
;; of the most popular packages.
;; (slime-setup '(slime-fancy slime-asdf))
;; https://www.common-lisp.net/project/slime/doc/html/Contributed-Packages.html

;; Эта настройка позволяет SWANK попросить SLIME выполнить код в контексте EMACS
;; (setq slime-enable-evaluate-in-emacs t)
;; например так:
;; swank:invoke-slime-debugger
;; (let ((*emacs-connection* ...)) (eval-in-emacs '(+ 1 2)))

;; Отступ при переводе строки в lisp-mode
(add-hook 'lisp-mode-hook
		  '(lambda ()
             (local-set-key (kbd "RET") 'newline-and-indent)))


;;; IBUFFER
;; Более удобный переключатель буферов

(require 'ibuffer)
(global-set-key [?\C-x ?\C-b] 'ibuffer)
;; Пропускать буферы с именем, удовлетворяющим регулярному выражению
(setq ibuffer-never-show-predicates
      (list "^\\*Complet" "^\\*Compile-Log" "^\\*Quail" "^\\*fsm-debug"))
;; Сортировать буферы по теме
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("ERC"    (or
                             (mode . ERC-List-mode)
                             (mode . erc-mode)))
               ("CHAT"      (or
                             (name . "^\\*---.*")))
               ("JABBER"    (or
                             (name . "^\\*-jabber-roster.*")))
               ("CONF"      (or
                             (name . "^\\*===.*")))
               ("ERLANG"    (or
                             (mode . erlang-mode)))
               ("MAKEFILE"  (or
                             (name . "^Makefile.*")
                             (mode . GNUmakefile-mode)))
               ("ASM"       (or
                             (mode . asm-mode)))
               ("FORTH"     (or
                             (mode . forth-mode)))
               ("C/CPP"     (or
                             (mode . c-mode)
                             (mode . c++-mode)))
               ("CSS"       (or
                             (mode . css-mode)))
               ("HTML"      (or
                             (mode . html-mode)
                             (mode . closure-template-html-mode)))
               ("JS"        (or
                             (mode . espresso-mode)))
               ("GO"        (or
                             (mode . go-mode)))
               ("ELISP"     (or
                             (mode . elisp-mode)
                             (mode . emacs-lisp-mode)))
               ("REPL"      (or
                             (name . "^\\*inferior-lisp.*")
                             (name . "^\\*slime-events.*")
                             (name . "^\\*slime-repl.*")
                             (name . "^\\*Python.*")
                             (name . "*\\*sldb.*")))
               ("LISP"      (or
                             (mode . lisp-mode)))
               ("ORG"       (or
                             (mode . org-mode)))
               ("SYS"       (or
                             (mode . dired-mode)
                             (name . "^\\*scratch\\*$")
                             (name . "^\\*Messages\\*$")))
               ("SHELL"     (or
                             (name . "^\\*Shell\\*$")
                             (name . "^\\*grep\\*$")))
               ))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups
             "default")))
(setq ibuffer-formats
      (quote ((mark modified read-only " "
                    (name 32 32 :left :elide) " "
                    (size 9 -1 :right) " "
                    (mode 16 16 :left :elide) " " filename-and-process)
              (mark " " (name 16 -1) " " filename))))


;;; Highlight-Parentheses

;; http://nschum.de/src/emacs/highlight-parentheses/highlight-parentheses.el
(require 'highlight-parentheses)
;; (add-hook 'lisp-mode-hook (highlight-parentheses-mode))
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode highlight-parentheses-mode)
(setq hl-paren-colors
      '("#FFFFFF" "#FFBF00" "#1FFF00" "#009EFF" "#FF00FF" "#FF0000"
        "#BFFFBF" "#00FFBF" "#FF1FBF" "#BFFF1F" "#9FBFFF" "#FF7F9F"))
(global-highlight-parentheses-mode)


;;; FORTH

(autoload 'forth-mode "gforth.el")
(autoload 'forth-block-mode "gforth.el")
(add-to-list 'auto-mode-alist '("\\.fs$" . forth-mode))
(add-to-list 'auto-mode-alist '("\\.f$" . forth-mode))


;;; JABBER

;; (add-to-list 'load-path "~/.emacs.d/emacs-jabber")
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-jabber")
;; (require 'jabber)
;; (setq jabber-auto-reconnect t)
;; (setq jabber-chat-buffer-format "*---%n-*")
;; (setq jabber-groupchat-buffer-format "*===%n-*")
;; (setq jabber-history-dir "~/.jabber-chatlogs")
;; (setq jabber-history-enabled t)
;; (setq jabber-history-muc-enabled t)
;; (setq jabber-history-size-limit 1024000000)

;; ;; Не закрывать буфер ростера при активном подключении
;; (my-hook-for (kill-buffer-query-functions)
;;   (not
;;    (and *jabber-connected*
;;     (eql (current-buffer)
;;           (get-buffer jabber-roster-buffer)))))

;; ;; Не закрывать буферы с активными конференциями
;; (my-hook-for (kill-buffer-query-functions)
;;   (not (and jabber-group
;;             (assoc jabber-group *jabber-active-groupchats*))))

;; M-x jabber-edit-bookmarks - для редактирвания закладок

;; Специальные настройки jabber-аккаунтов
;; (load-file "~/.emacs.d/lisp/jabber-account.el")


;;; ACE-JUMP-MODE


;; https://www.emacswiki.org/emacs/AceJump
;; https://www.youtube.com/watch?v=UZkpmegySnc
;; https://github.com/winterTTr/ace-jump-mode
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
;;
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; If you use viper mode :
;;   (define-key viper-vi-global-user-map (kbd "SPC") 'ace-jump-mode)
;; If you use evil
;;   (define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

;; https://emacs.stackexchange.com/questions/5749/using-ace-jump-mode-inside-shell-in-emacs
(defun my-shell-hook ()
  (define-key shell-mode-map (kbd "C-c SPC") 'ace-jump-mode))
(add-hook 'shell-mode-hook 'my-shell-hook)
(defun my-org-mode-hook ()
  (define-key org-mode-map (kbd "C-c SPC") 'ace-jump-mode))
(add-hook 'org-mode-hook 'my-org-mode-hook)


;;; ACE-MC (ace & multiple-cursors)

;; ace-mc-add-multiple-cursors запрашивает «Query Char» для первого
;; символа слова, почти так же, как это делает Ace Jump.  Фактически,
;; ace-mc-add-multiple-cursors принимает аналогичные префиксные
;; аргументы, что и ace-jump-mode. Поэтому, если вы передадите ему
;; один префикс C-u, он активирует режим ace-jump-char-char,
;; а с C-u C-u активирует режим ace-jump-line-mode.

;; После того, как вы введете запрос char, вам будет предложено
;; указать места для добавления курсоров в режиме нескольких
;; курсоров. Если курсор уже находится в этом месте, он будет
;; удален. Вам будет постоянно предлагаться добавлять или удалять
;; курсоры в других местах, пока вы не выйдете из него нажатием
;; клавиши «Ввод», «Esc» или чего-либо еще, кроме буквенных.

;; Когда у вас есть активный регион, запрос «char char» не
;; запрашивается. Вместо этого вы просто получаете список
;; местоположений, которые соответствуют тексту в вашем регионе.

;; ace-mc-add-single-cursor делает то же самое, что
;; ace-mc-add-multiple-cursors, только без зацикливания.

(global-set-key (kbd "M-]") 'ace-mc-add-multiple-cursors)
(global-set-key (kbd "C-M-]") 'ace-mc-add-single-cursor)


;;; UNIQUIFY
;; http://emacswiki.org/emacs/uniquify
(require 'uniquify)
;; (setq uniquify-buffer-name-style t)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")
(setq post-forward-angle-brackets 'post-forward-angle-brackets)

;;; FULLSCREEN
(require 'fullscreen)

;;; COLOR-THEME-MODERN
(add-to-list
 'custom-theme-load-path
 (file-name-as-directory "~/.emacs.d/elpa/color-theme-modern-20161219.1144"))
;;
(load-theme 'comidia t t)
(enable-theme 'comidia)
;;
;; (load-theme 'tango t)
;; (enable-theme 'wheatgrass)
;; Here's list of emacs 24.3 themes.
;; adwaita
;; deeper-blue
;; dichromacy
;; light-blue
;; manoj-dark
;; misterioso
;; tango
;; tango-dark
;; tsdh-dark
;; tsdh-light
;; wheatgrass
;; whiteboard
;; wombat


;;; DICTEM

;; Бегаете по переводимому тексту. На незнакомом слове нажали C-c d
;; и в отдельном буфере в отдельном окне отображается перевод. Между
;; тем фокус остается там же где и был, но некотором
;; слове. Переместились к следующему непонятному слову, нажали C-c
;; d, и в уже открытом окне с буфером появится перевод нового слова.

;; (when (executable-find "dictd")
;;   ;; check dictd is available
;;   (add-to-list 'load-path "~/.emacs.d/dictem-1.0.4")
;;   (require 'dictem)

;;   ;; (setq dictem-server "localhost")

;;   (setq dictem-user-databases-alist
;;         '(("_en-ru"  . ("mueller-base" "mueller-dict"
;;                         "mueller-geo" "mueller-names"
;;                         "mueller-abbrev"))
;;           ))

;;   (setq dictem-use-existing-buffer t)
;;   (setq dictem-use-user-databases-only t)

;;   (setq dictem-port "2628")
;;   (dictem-initialize)

;;   ;; redefined function
;;   (defun dictem-ensure-buffer ()
;;     "If current buffer is not a dictem buffer, create a new one."
;;     (let* ((dictem-buffer (get-buffer-create dictem-buffer-name))
;;            (dictem-window (get-buffer-window dictem-buffer))
;;            (window-configuration (current-window-configuration))
;;            (selected-window (frame-selected-window)))
;;       (if (window-live-p dictem-window)
;;           (select-window dictem-window)
;;         (switch-to-buffer-other-window dictem-buffer))

;;       (if (dictem-mode-p)
;;           (progn
;;             (if dictem-use-content-history
;;                 (setq dictem-content-history
;;                       (cons (list (buffer-substring
;;                                    (point-min) (point-max))
;;                                   (point)) dictem-content-history)))
;;             (setq buffer-read-only nil)
;;             (erase-buffer))
;;         (progn
;;           (dictem-mode)

;;           (make-local-variable 'dictem-window-configuration)
;;           (make-local-variable 'dictem-selected-window)
;;           (make-local-variable 'dictem-content-history)
;;           (setq dictem-window-configuration window-configuration)
;;           (setq dictem-selected-window selected-window)))))

;;   (add-hook 'dictem-postprocess-match-hook
;;             'dictem-postprocess-match)

;;   (add-hook 'dictem-postprocess-definition-hook
;;             'dictem-postprocess-definition-separator)

;;   (add-hook 'dictem-postprocess-definition-hook
;;             'dictem-postprocess-definition-hyperlinks)

;;   (add-hook 'dictem-postprocess-show-info-hook
;;             'dictem-postprocess-definition-hyperlinks)

;;   (add-hook 'dictem-postprocess-definition-hook
;;             'dictem-postprocess-each-definition)

;;   (define-key dictem-mode-map [tab] 'dictem-next-link)
;;   (define-key dictem-mode-map [(backtab)] 'dictem-previous-link)

;;   ;; http://paste.lisp.org/display/89086
;;   (defun dictem-run-define-at-point-with-query ()
;;     "Query the default dict server with the word read in within this function."
;;     (interactive)
;;     (let* ((default-word (thing-at-point 'symbol))
;;            (default-prompt (concat "Lookup Word "
;;                                    (if default-word
;;                                        (concat "(" default-word ")") nil)
;;                                    ": "))
;;            (dictem-query
;;             (funcall #'(lambda (str)
;;                          "Remove Whitespace from beginning and end of a string."
;;                          (replace-regexp-in-string "^[ \n\t]*\\(.*?\\)[ \n\t]*$"
;;                                                    "\\1"
;;                                                    str))
;;                      (read-string default-prompt nil nil default-word))))
;;       (if (= (length dictem-query) 0) nil
;;         (dictem-run 'dictem-base-search "_en-ru" dictem-query "."))))

;;   (defun dictem-run-define-at-point ()
;;     "dictem look up for thing at point"
;;     (interactive)
;;     (let* ((default-word (thing-at-point 'symbol))
;;            (selected-window (frame-selected-window))
;;            (dictem-query
;;             (funcall #'(lambda (str)
;;                          "Remove Whitespace from beginning and end of a string."
;;                          (replace-regexp-in-string "^[ \n\t]*\\(.*?\\)[ \n\t]*$"
;;                                                    "\\1"
;;                                                    str))
;;                      default-word)))
;;       (if (= (length dictem-query) 0)
;;           nil
;;         (progn
;;           (dictem-run 'dictem-base-search "_en-ru" dictem-query ".")
;;           (select-window selected-window)))))

;;   (global-set-key "\C-cd" 'dictem-run-define-at-point)
;;   (global-set-key "\C-cz" 'dictem-run-define-at-point-with-query)

;;   ) ;; end of (when (executable-find "dictd") ...)


;;; UNFILL (from melpa - not need require, only for note)
;; (require 'unfill)
;; Usage
;; M-x unfill-region
;; M-x unfill-paragraph
;; M-x unfill-toggle


;;; EMMC (not works from meplpa yet)
;; http://www.gnu.org/software/emms/quickstart.html
;; (require 'emms-setup)
;; (emms-standard)
;; (emms-default-players)
;; (setq emms-player-list '(
;;                          ;; emms-player-mpg321
;;                          ;; emms-player-ogg123
;;                          emms-player-mplayer))
;; (emms-standard)
;; (emms-default-players)
;; (require 'emms-player-simple)
;; (setq exec-path (append exec-path '("/usr/local/bin")))
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/emms/lisp")
;; (require 'emms-setup)
;; (require 'emms-player-mplayer)
;; (emms-standard)
;; (emms-default-players)
;; (define-emms-simple-player mplayer '(file url)
;;   (regexp-opt '(".ogg" ".mp3" ".wav" ".mpg" ".mpeg" ".wmv" ".wma"
;;                 ".mov" ".avi" ".divx" ".ogm" ".asf" ".mkv" "http://" "mms://"
;;                 ".rm" ".rmvb" ".mp4" ".flac" ".vob" ".m4a" ".flv" ".ogv" ".pls"))
;;         "mplayer" "-slave" "-quiet" "-really-quiet" "-fullscreen")
;; (require 'emms)
;; (emms-all)
;; (emms-default-players)


;;; WANDERLUST
;; http://box.matto.nl/emacsgmail.html
;; http://www.emacswiki.org/emacs/hgw-init-wl.el

;; (autoload 'wl "wl" "Wanderlust" t)
;; (autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
;; (autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; (setq mime-edit-split-message nil)

;; (setq wl-from "rigidus <i.am.rigidus@gmail.com>")
;; (setq elmo-imap4-default-user "i.am.rigidus"
;;       elmo-imap4-default-server "imap.gmail.com"
;;       elmo-imap4-default-port 993
;;       elmo-imap4-default-authenticate-type 'clear
;;       elmo-imap4-default-stream-type 'ssl
;;       elmo-imap4-use-modified-utf7 t

;;       wl-message-id-domain "i.am.rigidus@gmail.com"
;;       wl-from "i.am.rigidus <i.am.rigidus@gmail.com>"
;;       wl-smtp-posting-server "smtp.gmail.com"
;;       wl-smtp-connection-type 'starttls
;;       wl-smtp-posting-port 587
;;       wl-smtp-authenticate-type "plain"
;;       wl-smtp-posting-user "i.am.rigidus"
;;       wl-local-domain "gmail.com"

;;       elmo-pop3-debug t
;;       ssl-certificate-verification-policy 1
;;       wl-default-folder "%inbox"
;;       wl-default-spec "%"
;;       wl-folder-check-async t
;;       wl-thread-indent-level 4
;;       wl-thread-have-younger-brother-str "+"
;;       wl-thread-youngest-child-str       "+"
;;       wl-thread-vertical-str             "|"
;;       wl-thread-horizontal-str           "-"
;;       wl-thread-space-str                " "
;;       wl-summary-width	nil
;;       wl-summary-line-format "%n%T%P %W %D-%M-%Y %h:%m %t%[%c %f% %] %s"
;;       wl-message-buffer-prefetch-folder-type-list nil
;;       mime-transfer-level 8
;;       mime-edit-split-message nil
;;       mime-edit-message-max-length 32768
;;       mime-header-accept-quoted-encoded-words t
;;       ;; mime-browse-url-function 'browse-url-conkeror
;;       pgg-passphrase-cache-expiry 300
;;       pgg-decrypt-automatically t
;;       wl-message-ignored-field-list '("^.*")
;;       wl-message-visible-field-list '("^From:" "^To:" "^Cc:" "^Date:" "^Subject:" "^User-Agent:" "^X-Mailer:")
;;       wl-message-sort-field-list    wl-message-visible-field-list
;;       wl-message-window-size '(1 . 3)
;;       wl-folder-window-width 40
;;       wl-draft-preview-attributes-buffer-lines 7
;;       wl-draft-config-alist
;;       '(
;;         ((string-match "avenger" wl-draft-parent-folder)
;;          (wl-message-id-domain . "avenger-f@yandex.ru")
;;          (wl-from . "rigidus <avenger-f@yandex.ru>")
;;          ("From" . "avenger-f@yandex.ru")
;;          ;; ("Fcc" . "%Sent:avenger-f@yandex.ru:993")
;;          (wl-smtp-posting-server . "smtp.yandex.ru")
;;          ;; (wl-smtp-connection-type . nil)
;;          (wl-smtp-connection-type . 'starttls)
;;          ;; (wl-smtp-connection-type . 'ssl)
;;          ;; (wl-smtp-posting-port . 25)
;;          ;; (wl-smtp-posting-port . 465)
;;          (wl-smtp-posting-port . 587)
;;          (wl-smtp-authenticate-type . "plain")
;;          (wl-smtp-posting-user . "avenger-f")
;;          (wl-local-domain . "yandex.ru")
;;          )
;;         ((string-match "i.am.rigidus" wl-draft-parent-folder)
;;          (wl-message-id-domain . "i.am.rigidus@gmail.com")
;;          (wl-from . "i.am.rigidus <i.am.rigidus@gmail.com>")
;;          ("From" . "i.am.rigidus@gmail.com")
;;          (wl-smtp-posting-server . "smtp.gmail.com")
;;          (wl-smtp-connection-type . 'starttls)
;;          (wl-smtp-posting-port . 587)
;;          (wl-smtp-authenticate-type . "plain")
;;          (wl-smtp-posting-user . "i.am.rigidus")
;;          (wl-local-domain . "gmail.com")
;;          )
;;         )
;;       )

;; (autoload 'wl-user-agent-compose "wl-draft" nil t)
;; (if (boundp 'mail-user-agent)
;;     (setq mail-user-agent 'wl-user-agent))
;; (if (fboundp 'define-mail-user-agent)
;;     (define-mail-user-agent
;;       'wl-user-agent
;;       'wl-user-agent-compose
;;       'wl-draft-send
;;       'wl-draft-kill
;;       'mail-send-hook))


;;; ERC
;; (require 'erc)

;; ;; загружаем авто-подключение к каналам, и задаем список каналов для
;; ;; подключения
;; (erc-autojoin-mode t)

;; (setq erc-autojoin-channels-alist
;;       '(("irc.freenode.net" "#lisp" "#emacs")))


;; (require 'erc-fill)
;; (erc-fill-mode t)

;; ;; задаем персональные данные, хотя их можно задать и через
;; ;; M-x customize-group erc
;; (setq erc-user-full-name "rigidus")
;; (setq erc-email-userid "avenger-f@yandex.ru")

;; ;; часть относящаяся к логированию переговоров на каналах
;; ;; нужно ли вставлять старый лог в окно канала?
;; (setq erc-log-insert-log-on-open nil)

;; ;; логировать переговоры на каналах?
;; (setq erc-log-channels t)

;; ;; где будут храниться логи
;; (setq erc-log-channels-directory "~/.irclogs/")

;; ;; сохранять ли логи при возникновении PART
;; (setq erc-save-buffer-on-part t)

;; ;; убирать или нет временные отметки?
;; (setq erc-hide-timestamps nil)

;; ;; максимальный размер буфера канала
;; (setq erc-max-buffer-size 500000)



;;; COMPANY-MODE

;; Once installed, enable company-mode with M-x company-mode.

;; Completion will start automatically after you type a few letters.
;; Use:
;; M-n and M-p to select,
;;  <return> to complete or
;; <tab> to complete the common part.
;; Search through the completions with C-s, C-r and C-o.
;; Press M-(digit) to quickly complete with one of the first 10 candidates.

;; Type M-x company-complete to initiate completion manually.
;; Bind this command to a key combination of your choice.

;; When the completion candidates are shown,
;; press <f1> to display the documentation for the selected candidate,
;; or C-w to see its source. Not all back-ends support this.

;; To use company-mode in all buffers, add the following line to your init file:

;; (add-hook 'after-init-hook 'global-company-mode)

;; To see or change the list of enabled back-ends,
;; type M-x customize-variable RET company-backends.
;; Also see its description for information on writing a back-end.
;; For information on specific back-ends,
;; also check out the comments inside the respective files.
;; For more information, type M-x describe-function RET company-mode.
;; To customize other aspects of its behavior,
;; type M-x customize-group RET company.




;;; COMPANY-FLX

(with-eval-after-load 'company
  (company-flx-mode +1))


;;; TELEGA

;; (use-package telega
;;              :load-path  "~/telega.el"
;;              :commands (telega)
;;                :defer t)
;; (add-to-list 'load-path "~/.emacs.d/elpa/telega-20190913.1912/")
;; (require 'telega)
;; (setq telega-msg-rainbow-title nil)


;;; HELM

;; (require 'helm-config)


;;; LISP-EXTRA-FONT-LOCK
(add-to-list 'load-path "~/.emacs.d/elpa/lisp-extra-font-lock-20181008.1921/")
(require 'lisp-extra-font-lock)
(lisp-extra-font-lock-global-mode 1)



;;; OrgMode


;; http://orgmode.org/manual/Installation.html
;; (add-to-list 'load-path "~/src/org-mode/lisp")
;; (add-to-list 'load-path "~/src/org-mode/contrib/lisp" t)
;; (add-to-list 'load-path "~/repo/org-mode/lisp")
;; (add-to-list 'load-path "~/repo/org-mode/contrib/lisp" t)

;; Переключаться автоматически в org-mode при открытии файла с расширением .org:
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on

;; Включение fill-column для org-mode (отключено)
;; (add-hook 'org-mode-hook (lambda () (setq fill-column 73)))

;; Включение visual-line-mode для org-mode
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)


;; Задание цепочек ключевых слов
;; (переключение между словами клавишами Shift + Right
;; или + Left с курсором на заголовке).
;; "|" отмечает границу, если заголовок в статусе
;; после этого разделителя, то он "выполнен",
;; это влияет на планирование и отображение в Agenda Views:
(setq org-todo-keywords
      '((sequence "TODO(t)" "START(s)" "MEET(m)" "CALL(c)" "DELEGATED(d)" "WAIT(w)" "|" "CANCEL(r)"  "DONE(f)")
        (sequence "WEEK(w)" "MONTH(m)" "IDEA(i)")))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; Задание произвольного начертания ключевым словам:
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("START" . (:foreground "red" :background "white" :weight bold))
        ("MEET" . (:foreground "yellow" :weight bold))
        ("CALL" . (:foreground "lightblue" :weight bold))
        ("DELEGATED" . (:foreground "white" :weight bold))
        ("WAIT" . (:foreground "gray" :weight bold))
        ("CANCEL" . (:foreground "violet" :weight bold))
        ("DONE" . (:foreground "green" :weight bold))))

;; ORG-MODE TODO|VRFY|NOTE font-lock-faces
(font-lock-add-keywords 'org-mode
                        '(("\\(\\[TODO:[a-z]\\{3,\\}\\]\\)" . 'font-lock-warning-face)
                          ("\\(\\[COMMENT:[a-z]\\{3,\\}\\]\\)" . 'font-lock-keyword-face)
                          ;; ("\\(comment\\)" . 'font-lock-comment-face)
                          ("\\(\\[VRFY:[a-z]\\{3,\\}\\]\\)" . 'font-lock-function-name-face)
                          ("\\(\\[NOTE:[a-z]\\{3,\\}\\]\\)" . 'font-lock-function-name-face)
                          ;; ("\\(variable-name\\)" . 'font-lock-variable-name-face)
                          ;; ("\\(keyword\\)" . 'font-lock-keyword-face)
                          ;; ("\\(comment\\)" . 'font-lock-comment-face)
                          ;; ("\\(type\\)" . 'font-lock-type-face)
                          ;; ("\\(constant\\)" . 'font-lock-constant-face)
                          ;; ("\\(builtin\\)" . 'font-lock-builtin-face)
                          ;; ("\\(string\\)" . 'font-lock-string-face)
                          ;; ("\\(function-name\\)" . 'font-lock-function-name-face)
                          ))

;; Требуется для корректной работы Org Mode:
(global-font-lock-mode 1)

;; Показывать картинки при открытии org-файлов
(setq org-startup-with-inline-images t)

;; (define-key mode-specific-map [?a] 'org-agenda)

;; (eval-after-load "org"
;;   '(progn
;;      (define-prefix-command 'org-todo-state-map)

;;      (define-key org-mode-map "\C-cx" 'org-todo-state-map)

;;      (define-key org-todo-state-map "x"
;;        #'(lambda nil (interactive) (org-todo "CANCELLED")))
;;      (define-key org-todo-state-map "d"
;;        #'(lambda nil (interactive) (org-todo "DONE")))
;;      (define-key org-todo-state-map "f"
;;        #'(lambda nil (interactive) (org-todo "DEFERRED")))
;;      (define-key org-todo-state-map "l"
;;        #'(lambda nil (interactive) (org-todo "DELEGATED")))
;;      (define-key org-todo-state-map "s"
;;        #'(lambda nil (interactive) (org-todo "STARTED")))
;;      (define-key org-todo-state-map "w"
;;        #'(lambda nil (interactive) (org-todo "WAITING")))

;;      (define-key org-agenda-mode-map "\C-n" 'next-line)
;;      (define-key org-agenda-keymap "\C-n" 'next-line)
;;      (define-key org-agenda-mode-map "\C-p" 'previous-line)
;;      (define-key org-agenda-keymap "\C-p" 'previous-line)))

;; (require 'remember)

;; (add-hook 'remember-mode-hook 'org-remember-apply-template)

;; (define-key global-map [(control meta ?r)] 'remember)


;; ;; Bootstrap the Emacs environment to load literate Emacs initialization files.
;; ;; First, establish a root directory from which we can locate the org-mode files we need.
;; (setq dotfiles-dir (file-name-directory (or (buffer-file-name) load-file-name)))
;; ;; Locate the directory that has the org-mode files
;; (let* ((org-dir (expand-file-name
;;                  "lisp" (expand-file-name
;;                          "org-mode" (expand-file-name
;;                                      "src" dotfiles-dir)))))
;;   (add-to-list 'load-path org-dir)
;;   (require 'org-install)
;;   (require 'ob)
;;   )

;; ;; Load all literate org-mode files in this directory (any org-mode files residing there)
;; (mapc #'org-babel-load-file (directory-files dotfiles-dir t "\\.org$"))


;;; Org Babel

;; (require 'org-babel)
;; (require 'org-babel-init)

(require 'ob-tangle)

;;; Ditaa
(setq org-ditaa-jar-path "/usr/share/ditaa/ditaa.jar")

;;; Gnuplot
(require 'gnuplot)
;; (require 'org-babel-gnuplot)

;;; PlantUML
;; /usr/bin/plantuml
(load-file "~/.emacs.d/lisp/plantuml_helpers.el")
(setq org-plantuml-jar-path "/usr/share/plantuml/plantuml.jar")

(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))
(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)

;;; Make babel results blocks lowercase
(setq org-babel-results-keyword "results")


;;; Org-babel-do-load-languages
(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         (dot . t)
         (ditaa . t)
         (R . t)
         (C . t)
         (css . t)
         (awk . t)
         (python . t)
         (ruby . t)
         (gnuplot . t)
         (clojure . t)
         ;; (shell . t)
         (ledger . t)
         (org . t)
         (plantuml . t)
         (latex . t))))

;;; Do not prompt to confirm evaluation
;; This may be dangerous - make sure you understand the consequences
;; of setting this -- see the docstring for details
(setq org-confirm-babel-evaluate nil)
(setq org-support-shift-select t)


;;; Org-Mode-Exporting
;; put your css files there
(defvar org-theme-css-dir "~/.emacs.d/org-css/")

(defun toggle-org-custom-inline-style ()
  (interactive)
  (let ((hook 'org-export-before-parsing-hook)
        (fun 'set-org-html-style))
    (if (memq fun (eval hook))
        (progn
          (remove-hook hook fun 'buffer-local)
          (message "Removed %s from %s" (symbol-name fun) (symbol-name hook)))
      (add-hook hook fun nil 'buffer-local)
      (message "Added %s to %s" (symbol-name fun) (symbol-name hook)))))

(defun org-theme ()
  (interactive)
  (let* ((cssdir org-theme-css-dir)
         (css-choices (directory-files cssdir nil ".css$"))
         (css (completing-read "theme: " css-choices nil t)))
    (concat cssdir css)))

(defun set-org-html-style (&optional backend)
  (interactive)
  (when (or (null backend) (eq backend 'html))
    (let ((f (or (and (boundp 'org-theme-css) org-theme-css) (org-theme))))
      (if (file-exists-p f)
          (progn
            (set (make-local-variable 'org-theme-css) f)
            (set (make-local-variable 'org-html-head)
                 (with-temp-buffer
                   (insert "<style type=\"text/css\">\n<!--/*--><![CDATA[/*><!--*/\n")
                   (insett "1234")
                   ;; (insert-file-contents f)
                   ;; (goto-char (point-max))
                   (insert "\n/*]]>*/-->\n</style>\n")
                   (buffer-string)))
            (set (make-local-variable 'org-html-head-include-default-style)
                 nil)
            (message "Set custom style from %s" f))
        (message "Custom header file %s doesnt exist")))))


(defun org-custom-link-img-follow (path)
  (org-open-file-with-emacs
   (format "../img/%s" path)))

(defun org-custom-link-img-export (path desc format)
  (cond
   ((eq format 'html)
    (format "<div class=\"figure\"><img src=\"/img/%s\" alt=\"%s\"/><p>%s</p></div>"
            path desc (if desc desc "")))))

(org-add-link-type "img" 'org-custom-link-img-follow 'org-custom-link-img-export)

(setq org-export-time-stamp-file nil)
(setq org-publish-project-alist
      '(("org-notes"
         :base-directory "~/src/rigidus.ru/org/"
         :base-extension "org"
         :publishing-directory "~/src/rigidus.ru/www/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :timestamp nil
         :html-doctype "html5"
         :section-numbers nil
         :html-postamble nil
         :html-preamble nil
         :with-timestamps nil
         :timestamp nil
         :with-date nil
         :html-head-extra "<link href=\"/css/style.css\" rel=\"stylesheet\" type=\"text/css\" />"
         :html-head-include-default-style nil
         :html-head-include-scripts nil)
        ("org-static"
         :base-directory "~/src/rigidus.ru/org/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|djvu"
         :publishing-directory "~/src/rigidus.ru/www/"
         :recursive t
         :publishing-function org-publish-attachment)
        ("org"
         :components ("org-notes" "org-static"))
        ;; ("in-solar-notes"
        ;;  :base-directory "~/src/in-solar/org/"
        ;;  :base-extension "org"
        ;;  :publishing-directory "~/src/in-solar/www/"
        ;;  :recursive t
        ;;  :publishing-function org-html-publish-to-html
        ;;  :timestamp nil
        ;;  :html-doctype "html5"
        ;;  :section-numbers nil
        ;;  :html-postamble nil
        ;;  :html-preamble nil
        ;;  :with-timestamps nil
        ;;  :timestamp nil
        ;;  :with-date nil
        ;;  ;; :html-head-extra "<link href=\"../css/style.css\" rel=\"stylesheet\" type=\"text/css\" />"
        ;;  :html-head-include-default-style nil
        ;;  :html-head-include-scripts nil)
        ;; ("in-solar-static"
        ;;  :base-directory "~/src/in-solar/org/"
        ;;  :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|djvu"
        ;;  :publishing-directory "~/src/in-solar/www/"
        ;;  :recursive t
        ;;  :publishing-function org-publish-attachment)
        ;; ("in-solar"
        ;;  :components ("in-solar-notes" "in-solar-static"))
         ))


;;; OrgPresent

(autoload 'org-present "org-present" nil t)

(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)))))


;;; CUSTOM

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-frame-buffer-list nil)
 '(c-tab-always-indent nil)
 '(column-number-mode t)
 '(ecb-options-version "2.40")
 '(jabber-history-size-limit 49741824)
 '(jabber-use-global-history nil)
 '(lj-cache-login-information t)
 '(lj-default-username "rigidus")
 '(org-agenda-files nil)
 '(org-default-notes-file "~/org/notes.org")
 '(org-directory "~/org/")
 '(org-support-shift-select t)
 '(package-selected-packages
   (quote
    (org-roam ace-jump-mode emacs-everywhere rust-mode exec-path-from-shell toml-mode lsp-ui lsp-mode python-mode flymake-yaml yaml-mode vyper-mode flymake-solidity solidity-flycheck company-solidity org-tree-slide org-pdftools use-package pdf-tools plantuml-mode projectile better-defaults clojure-mode cider htmlize helm-projectile lisp-extra-font-lock go-guru go-direx go-scratch gotest multi-compile go-rename company-go yasnippet go-eldoc go-mode slime helm telega wanderlust unfill gnuplot-mode gnuplot company-flx color-theme-modern ace-mc)))
 '(size-indication-mode t)
 '(tab-width 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-lisp-show-completion ((t (:background "brightcyan"))))
 '(helm-selection ((t (:background "ForestGreen" :distant-foreground "white"))))
 '(helm-selection-line ((t (:inherit highlight :distant-foreground "white"))))
 '(widget-field ((t (:background "color-235" :foreground "brightblack")))))



;;; GoLang
;; http://reangdblog.blogspot.com/2016/06/emacs-ide-go.html

(require 'company)
(require 'flycheck)
(require 'yasnippet)
(require 'multi-compile)
(require 'go-eldoc)
(require 'company-go)

;; (add-hook 'before-save-hook 'gofmt-before-save)
(setq-default gofmt-command "goimports")
(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-hook 'go-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends) '(company-go))
            (company-mode)))

(add-hook 'go-mode-hook 'yas-minor-mode)
;; (add-hook 'go-mode-hook 'flycheck-mode)
(setq multi-compile-alist
      '((go-mode
         . (("go-build" "go build -v"
             (locate-dominating-file buffer-file-name ".git"))
            ("go-build-and-run"
             "go build -v && echo 'build finish' && eval ./${PWD##*/}"
             (multi-compile-locate-file-dir ".git"))))))


;;; assembler comments for GAS
(defcustom asm-comment-char ?\;
  "*The comment-start character assumed by Asm mode."
  :type 'character
  :group 'asm)

;;; Pdf-Tools

;; (from akatel)

;; Из коробки org-mode не знает о pdf-инструментах.
;; Однако вы можете добавить поддержку открытия
;; ссылок org на файлы pdf с помощью org-pdfview

;; need melpa install: pdf-tools.
;; Delete the pdf-tools package.
;; Restart Emacs.
;; Reinstall pdf-tools.

;; PdfLatex is a tool that converts Latex sources into PDF. This is
;; specifically very important for researchers, as they use it to
;; publish their findings. It could be installed very easily using
;; Linux terminal, though this seems an annoying task on
;; Windows. Installation commands are given below.

;; Install the TexLive base

;; sudo apt-get install texlive-latex-base

;; Also install the recommended and extra fonts to avoid running
;; into the error [1], when trying to use pdflatex on latex files
;; with more fonts.

;; sudo apt-get install texlive-fonts-recommended
;; sudo apt-get install texlive-fonts-extra

;; Install the extra packages,

;; sudo apt-get install texlive-latex-extra

;; Install all languages
;; sudo apt-get install texlive-lang-all

;; Once installed as above, you may be able to create PDF files from latex sources using PdfLatex as below.

;; pdflatex latex_source_name.tex

;; Ref:
;; - http://kkpradeeban.blogspot.com/2014/04/installing-latexpdflatex-on-ubuntu.html
;; - https://gist.github.com/rain1024/98dd5e2c6c8c28f9ea9d

;; USING: M-x org-latex-export-to-pdf


(require 'use-package)

(use-package pdf-tools :ensure t
  :defer 18
  :custom
  (pdf-tools-enabled-modes
   '(pdf-history-minor-mode
     pdf-isearch-minor-mode
     pdf-links-minor-mode
     pdf-misc-minor-mode
     pdf-outline-minor-mode
     pdf-misc-size-indication-minor-mode
     pdf-misc-menu-bar-minor-mode
     pdf-annot-minor-mode
     pdf-sync-minor-mode
     pdf-misc-context-menu-minor-mode
     pdf-cache-prefetch-minor-mode
     pdf-view-auto-slice-minor-mode
     pdf-occur-global-minor-mode))
  :config
  (dolist
      (pkg
       '( pdf-annot pdf-cache pdf-dev pdf-history pdf-info pdf-isearch
                    pdf-links pdf-misc pdf-occur pdf-outline pdf-sync
                    pdf-util pdf-view pdf-virtual))
    (require pkg))
  (pdf-tools-install t))

(use-package pdf-view :ensure pdf-tools :defer 19
  :after (pdf-tools)
  :magic ("%PDF" . pdf-view-mode)
  :custom
  ;; tomorrow-night
  (pdf-view-midnight-colors '("#c5c8c6" . "#1d1f21"))
  :bind (:map pdf-view-mode-map
              ([remap avy-goto-line] . pdf-view-goto-page)
              ([remap forward-word] . scroll-up-command)
              ([remap backward-word] . scroll-down-command)))

(use-package tex :ensure auctex :defer 20
  :after (pdf-tools)
  :preface
  (defvaralias 'akater-TeX-after-compilation-hook 'TeX-after-compilation-finished-functions)
  :custom
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  (TeX-source-correlate-start-server t)
  :hook
  ;; Update PDF buffers after successful LaTeX runs
  (akater-TeX-after-compilation . TeX-revert-document-buffer))

(use-package org-pdfview :ensure t :disabled t
  :defer 21
  :after (org pdf-view)
  :config
  (add-to-list 'org-file-apps
               '("\\.pdf\\'" . (lambda (_file link)
                                 (org-pdfview-open link)))))


;;; Emacs Presentations - org-tree-slide

(when (require 'org-tree-slide nil t)
  (global-set-key (kbd "<f8>") 'org-tree-slide-mode)
  (global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)
  (define-key org-tree-slide-mode-map (kbd "<f9>")
    'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>")
    'org-tree-slide-move-next-tree)
  (define-key org-tree-slide-mode-map (kbd "<f11>")
    'org-tree-slide-content)
  (setq org-tree-slide-skip-outline-level 4)
  (org-tree-slide-narrowing-control-profile)
  (setq org-tree-slide-skip-done nil))


;; ---------------------

;; http://emacs-fu.blogspot.com/search/label/beamer
;; allow for export=>beamer by placing

;; #+LaTeX_CLASS: beamer in org files

(require 'ox-latex)

(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))

(add-to-list
 'org-export-latex-classes
 ;; beamer class, for presentations
 '("beamer"
   "\\documentclass{beamer}\n
    \\mode<{{{beamermode}}}>\n
    \\setbeameroption{show notes}
    \\usepackage[utf8]{inputenc}\n
    \\usepackage[T1]{fontenc}\n
    \\usepackage{hyperref}\n
    \\usepackage{color}
    \\usepackage{listings}
    \\lstset{numbers=none,language=[ISO]C++,tabsize=4,frame=single,basicstyle=\\small,showspaces=false,showstringspaces=false,showtabs=false,keywordstyle=\\color{blue}\\bfseries,commentstyle=\\color{red},}\n
    \\usepackage{verbatim}\n
    \\institute{{{{beamerinstitute}}}}\n
    \\subject{{{{beamersubject}}}}\n"
   ("\\section{%s}" . "\\section*{%s}")
   ("\\begin{frame}[fragile]\\frametitle{%s}"
    "\\end{frame}"
    "\\begin{frame}[fragile]\\frametitle{%s}"
    "\\end{frame}")))

;; letter class, for formal letters

(add-to-list
 'org-export-latex-classes
 '("letter"
   "\\documentclass[11pt]{letter}\n
    \\usepackage[utf8]{inputenc}\n
    \\usepackage[T1]{fontenc}\n
    \\usepackage{color}"
   ("\\section{%s}" . "\\section*{%s}")
   ("\\subsection{%s}" . "\\subsection*{%s}")
   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
   ("\\paragraph{%s}" . "\\paragraph*{%s}")
   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


;;; Markdown exporting

(require 'ox-md)

;; Rust env (https://robert.kra.hn/posts/2021-02-07_rust-with-emacs/)

;; When using this directly, you will need to have use-package installed:
;; M-x package-install, select use-package. But if you start via
;; `standalone.el', this is being taken care of automatically.


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; rustic = basic rust-mode + additions

;; (use-package rustic
;;   :ensure
;;   :bind (:map rustic-mode-map
;;               ("M-j" . lsp-ui-imenu)
;;               ("M-?" . lsp-find-references)
;;               ("C-c C-c l" . flycheck-list-errors)
;;               ("C-c C-c a" . lsp-execute-code-action)
;;               ("C-c C-c r" . lsp-rename)
;;               ("C-c C-c q" . lsp-workspace-restart)
;;               ("C-c C-c Q" . lsp-workspace-shutdown)
;;               ("C-c C-c s" . lsp-rust-analyzer-status)
;;               ("C-c C-c e" . lsp-rust-analyzer-expand-macro)
;;               ("C-c C-c d" . dap-hydra)
;;               ("C-c C-c h" . lsp-ui-doc-glance))
;;   :config
;;   ;; uncomment for less flashiness
;;   ;; (setq lsp-eldoc-hook nil)
;;   ;; (setq lsp-enable-symbol-highlighting nil)
;;   ;; (setq lsp-signature-auto-activate nil)

;;   ;; comment to disable rustfmt on save
;;   (setq rustic-format-on-save t)
;;   (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

;; (defun rk/rustic-mode-hook ()
;;   ;; so that run C-c C-c C-r works without having to confirm, but don't try to
;;   ;; save rust buffers that are not file visiting. Once
;;   ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
;;   ;; no longer be necessary.
;;   (when buffer-file-name
;;     (setq-local buffer-save-without-query t)))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; for rust-analyzer integration

;; (use-package lsp-mode
;;   :ensure
;;   :commands lsp
;;   :custom
;;   ;; what to use when checking on-save. "check" is default, I prefer clippy
;;   (lsp-rust-analyzer-cargo-watch-command "clippy")
;;   (lsp-eldoc-render-all t)
;;   (lsp-idle-delay 0.6)
;;   (lsp-rust-analyzer-server-display-inlay-hints t)
;;   :config
;;   (add-hook 'lsp-mode-hook 'lsp-ui-mode))

;; (use-package lsp-ui
;;   :ensure
;;   :commands lsp-ui-mode
;;   :custom
;;   (lsp-ui-peek-always-show t)
;;   (lsp-ui-sideline-show-hover t)
;;   (lsp-ui-doc-enable nil))


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; inline errors

(use-package flycheck :ensure)

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; auto-completion and code snippets

;; (use-package yasnippet
;;   :ensure
;;   :config
;;   (yas-reload-all)
;;   (add-hook 'prog-mode-hook 'yas-minor-mode)
;;   (add-hook 'text-mode-hook 'yas-minor-mode))

;; (use-package company
;;   :ensure
;;   :bind
;;   (:map company-active-map
;;         ("C-n". company-select-next)
;;         ("C-p". company-select-previous)
;;         ("M-<". company-select-first)
;;         ("M->". company-select-last))
;;   (:map company-mode-map
;;         ("<tab>". tab-indent-or-complete)
;;         ("TAB". tab-indent-or-complete)))

;; (defun company-yasnippet-or-completion ()
;;   (interactive)
;;   (or (do-yas-expand)
;;       (company-complete-common)))

;; (defun check-expansion ()
;;   (save-excursion
;;     (if (looking-at "\\_>") t
;;       (backward-char 1)
;;       (if (looking-at "\\.") t
;;         (backward-char 1)
;;         (if (looking-at "::") t nil)))))

;; (defun do-yas-expand ()
;;   (let ((yas/fallback-behavior 'return-nil))
;;     (yas/expand)))

;; (defun tab-indent-or-complete ()
;;   (interactive)
;;   (if (minibufferp)
;;       (minibuffer-complete)
;;     (if (or (not yas/minor-mode)
;;             (null (do-yas-expand)))
;;         (if (check-expansion)
;;             (company-complete-common)
;;           (indent-for-tab-command)))))


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; for Cargo.toml and other config files

(use-package toml-mode :ensure)

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; setting up debugging support with dap-mode

;; (use-package exec-path-from-shell
;;   :ensure
;;   :init (exec-path-from-shell-initialize))

;; (when (executable-find "lldb-mi")
;;   (use-package dap-mode
;;     :ensure
;;     :config
;;     (dap-ui-mode)
;;     (dap-ui-controls-mode 1)

;;     (require 'dap-lldb)
;;     (require 'dap-gdb-lldb)
;;     ;; installs .extension/vscode
;;     (dap-gdb-lldb-setup)
;;     (dap-register-debug-template
;;      "Rust::LLDB Run Configuration"
;;      (list :type "lldb"
;;            :request "launch"
;;            :name "LLDB::Run"
;;            :gdbpath "rust-lldb"
;;            ;; uncomment if lldb-mi is not in PATH
;;            ;; :lldbmipath "path/to/lldb-mi"
;;            ))))

;; Org-roam
(setq org-roam-v2-ack t)
(use-package org-roam
  :ensure t
  :init
    (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/src/org")
  (org-roam-complete-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i"   . completion-at-point))
  :config
  (org-roam-setup))
