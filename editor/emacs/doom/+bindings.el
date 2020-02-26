;;; ~/dev/dotfiles/editor/emacs/doom/+bindings.el -*- lexical-binding: t; -*-

;;                 ▄▄▄▄· ▪   ▐ ▄ ·▄▄▄▄  ▪   ▐ ▄  ▄▄ • .▄▄ ·
;;                 ▐█ ▀█▪██ •█▌▐███▪ ██ ██ •█▌▐█▐█ ▀ ▪▐█ ▀.
;;                 ▐█▀▀█▄▐█·▐█▐▐▌▐█· ▐█▌▐█·▐█▐▐▌▄█ ▀█▄▄▀▀▀█▄
;;                 ██▄▪▐█▐█▌██▐█▌██. ██ ▐█▌██▐█▌▐█▄▪▐█▐█▄▪▐█
;;                 ·▀▀▀▀ ▀▀▀▀▀ █▪▀▀▀▀▀• ▀▀▀▀▀ █▪·▀▀▀▀  ▀▀▀▀

;;                  == Spacemacs-esque keybinding scheme ==


(defvar my-completion-map (make-sparse-keymap))
(defvar my-org-format-map (make-sparse-keymap))


(setq
  doom-leader-key ","
  ;; FIXME
  doom-leader-alt-key "s-,"
  ;; doom-leader-alt-key "C-,"
  doom-localleader-key ", m"
  ;; FIXME
  doom-localleader-alt-key "s-m"
  ;; doom-localleader-alt-key "C-m"
  +evil-repeat-keys '("|" . "\\"))


;; ┏━╸╻  ┏━┓┏┓ ┏━┓╻  ┏━┓
;; ┃╺┓┃  ┃ ┃┣┻┓┣━┫┃  ┗━┓
;; ┗━┛┗━╸┗━┛┗━┛╹ ╹┗━╸┗━┛
;; Globals

(map!
  :givn "s-x" #'execute-extended-command

  "s-;" #'execute-extended-command
  "s-." #'helpful-key

  "s-[" #'previous-buffer
  "s-]" #'next-buffer

  "s-g" #'magit-status
  "s-p" #'+treemacs/toggle

  "s-r" #'+eval/open-repl-other-window
  "s-R" #'+eval/open-repl-same-window

  "s-i" #'org-capture
  "s-I" #'org-journal-new-entry

  :m  [up]     #'+evil-multi-previous-line
  :m  [down]   #'+evil-multi-next-line

  ;; Disable smart tab which is not very smart...
  :niv [tab]   nil

  :nv  [tab]   #'evil-jump-item
  (:when (featurep! :ui workspaces)
    :nv  [S-tab] #'persp-switch)

  :n   "SPC"   #'evil-toggle-fold
  :v   "SPC"   #'evil-vimish-fold/create

  (:when (featurep! :ui workspaces)
    "s-t" #'+workspace/new
    "s-{" #'+workspace/switch-left
    "s-}" #'+workspace/switch-right
    "s-h" #'+workspace/switch-left
    "s-l" #'+workspace/switch-right)

  [remap evil-jump-to-tag] #'projectile-find-tag
  [remap find-tag]         #'projectile-find-tag

  ;; misc
  :nvi "C-n"  #'sp-next-sexp
  :nvi "C-p"  #'sp-previous-sexp

  :gnv "s-/"  #'which-key-show-top-level
  :nv  ";"    #'evil-ex
  :nv  ":"    #'pp-eval-expression

  :n "#"      #'evilnc-comment-or-uncomment-lines
  :v "#"      #'comment-or-uncomment-region

  ;; Shift text
  :n  "<"     #'evil-shift-left-line
  :n  ">"     #'evil-shift-right-line
  (:after evil-org :map evil-org-mode-map
    :n "<"    #'+evil/evil-org-<
    :n ">"    #'+evil/evil-org->)
  ;; don't leave visual mode after shifting
  :v  "<"     #'+evil/visual-dedent  ; vnoremap < <gv
  :v  ">"     #'+evil/visual-indent  ; vnoremap > >gv

  :nv "H"     #'previous-buffer
  :nv "L"     #'next-buffer
  (:after evil-magit :map magit-mode-map
    ;; FIXME Figure out a way to rebind `magit-log-refresh in the
    ;; `magit-dispatch' transient command or just ignore it
    "L" nil)

  :n  "C-."   (cond ((featurep! :completion ivy)   #'ivy-resume)
                ((featurep! :completion helm)  #'helm-resume))

  :n  [C-tab]        #'evil-switch-to-windows-last-buffer

  :gi [C-backspace]  #'delete-forward-char

  :gi "C-d"          #'evil-delete-line
  :gi "C-S-d"        #'evil-delete-whole-line
  :gi "C-S-u"        #'evil-change-whole-line
  :gi "C-S-w"        #'backward-kill-sexp

  :gi "C-S-a"        #'sp-beginning-of-sexp
  :gi "C-S-e"        #'sp-end-of-sexp

  :gi "C-S-f"        #'sp-forward-sexp
  :gi "C-S-b"        #'sp-backward-sexp

  :gi "C-h"          #'left-char
  :gi "C-l"          #'right-char
  :gi "C-S-h"        #'sp-backward-symbol
  :gi "C-S-l"        #'sp-forward-symbol

  ;; Basic editing
  :i "S-SPC"         #'tab-to-tab-stop
  ;; TODO: Tranpose last two WORDS not those around
  :gi "C-t"          #'transpose-words
  ;; TODO: Tranpose last two SEXPS not those around
  :gi "C-S-t"        #'transpose-sexps

  :nv "C-a"   #'evil-numbers/inc-at-pt
  :nv "C-S-a" #'evil-numbers/dec-at-pt

  ;; Easier window/tab navigation
  (:map general-override-mode-map
    :n "C-h"   #'evil-window-left
    :n "C-j"   #'evil-window-down
    :n "C-k"   #'evil-window-up
    :n "C-l"   #'evil-window-right)
  ;; overrides
  (:after evil-org-agenda :map evil-org-agenda-mode-map
    :m "C-h"   #'evil-window-left
    :m "C-j"   #'evil-window-down
    :m "C-k"   #'evil-window-up
    :m "C-l"   #'evil-window-right)
  (:map comint-mode-map
    :in "C-h"   #'evil-window-left
    :in "C-j"   #'evil-window-down
    :in "C-k"   #'evil-window-up
    :in "C-l"   #'evil-window-right)
  (:after treemacs-mode :map treemacs-mode-map
    :g "C-h"   #'evil-window-left
    :g "C-l"   #'evil-window-right)

  (:after git-timemachine :map git-timemachine-mode-map
    :n "C-p" #'git-timemachine-show-previous-revision
    :n "C-n" #'git-timemachine-show-next-revision)

  (:after evil-snipe
    "C-s"    #'evil-snipe-repeat
    "C-S-s"  #'evil-snipe-repeat-reverse
    :nv "S"    #'evil-avy-goto-char-2

    :map (evil-snipe-override-mode-map evil-snipe-parent-transient-map)
    :gm ";"  nil
    :gm ","  nil)

  ;; expand-region
  :v "v"   (general-predicate-dispatch 'er/expand-region
             (eq (evil-visual-type) 'line)
             'evil-visual-char)
  :v "C-v" #'er/contract-region

  :n  "s"     #'evil-surround-edit
  :v  "s"     #'evil-surround-region

  (:map (prog-mode-map org-mode-map)
    :nv  [S-return] #'+default/search-project)
  (:map prog-mode-map
    :nv  [return]   #'+default/search-project-for-symbol-at-point)

  (:prefix "g"
    :nv "Q"    #'+eduarbo/unfill-paragraph
    :nv "o"    #'avy-goto-char-timer
    :nv "O"    (λ! (let ((avy-all-windows t)) (avy-goto-char-timer)))
    :nv "/"    #'+default/search-project
    :n  "."    #'call-last-kbd-macro
    ;; narrowing and widening
    :nv "n"    #'+eduarbo/narrow-or-widen-dwim)
  )

;; help
(map! (:map help-map
        "H"   #'+lookup/documentation))


;; ┏┳┓┏━┓╺┳┓╻ ╻╻  ┏━╸┏━┓
;; ┃┃┃┃ ┃ ┃┃┃ ┃┃  ┣╸ ┗━┓
;; ╹ ╹┗━┛╺┻┛┗━┛┗━╸┗━╸┗━┛
;; Modules

;;; :completion
(map! (:when (featurep! :completion company)
        :i [tab]      #'+company/complete
        :i [C-tab]    my-completion-map

        (:after company
          (:map company-active-map
            [S-tab]   #'company-select-previous
            "C-l"     #'company-complete
            [right]   #'company-complete
            "C-h"     #'company-abort
            [left]    #'company-abort))

        (:map my-completion-map
          "d"      #'+company/dict-or-keywords
          "f"      #'company-files
          "s"      #'company-ispell
          [C-tab]  #'company-yasnippet
          "o"      #'company-capf
          "a"      #'+company/dabbrev
          ))

      (:when (featurep! :completion ivy)
        (:after ivy
          :map ivy-minibuffer-map
          "C-n"      #'scroll-up-command
          "C-p"      #'scroll-down-command
          "s-o"      #'hydra-ivy/body)
        (:after counsel
          :map counsel-ag-map
          [S-tab]  #'+ivy/woccur
          [C-return] #'+ivy/git-grep-other-window-action
          "C-o"      #'+ivy/git-grep-other-window-action)
        (:after swiper
          :map swiper-map
          [S-tab] #'+ivy/woccur))

      (:when (featurep! :completion helm)
        (:after helm
          (:after swiper-helm
            :map swiper-helm-keymap [S-tab] #'helm-ag-edit)
          (:after helm-ag
            :map helm-ag-map
            [S-tab]  #'helm-ag-edit))))

;;; :ui
(map! (:when (featurep! :ui workspaces)
        :n  [C-S-tab]  #'+eduarbo/switch-to-last-workspace

        :n "C-S-l" #'+workspace/switch-right
        :n "C-S-h" #'+workspace/switch-left)
  )

;;; :editor
(map!
  ;; NOTE: Fix broken evil-multiedit bindings
  (:when (featurep! :editor multiple-cursors)
    :n  "s-d"   #'evil-multiedit-match-symbol-and-next
    :n  "s-D"   #'evil-multiedit-match-symbol-and-prev
    :v  "s-d"   #'evil-multiedit-match-and-next
    :v  "s-D"   #'evil-multiedit-match-and-prev
    :nv "C-s-d" #'evil-multiedit-restore
    (:after evil-multiedit
      (:map evil-multiedit-state-map
        "s-d"    #'evil-multiedit-match-and-next
        "s-D"    #'evil-multiedit-match-and-prev
        [return] #'evil-multiedit-toggle-or-restrict-region)))

  (:when (featurep! :editor snippets)
    :i  [S-tab]    (λ! (unless (call-interactively 'yas-expand)
                         (call-interactively 'company-yasnippet)))
    :v  [S-tab]    #'yas-insert-snippet

    :i  [C-return] #'aya-expand
    :nv [C-return] #'aya-create

    (:after yasnippet
      (:map yas-keymap
        ;; Do not interfer with company
        [tab]         nil
        "TAB"         nil
        [S-tab]       nil
        "<S-tab>"     nil
        "C-n"         #'yas-next-field
        "C-p"         #'yas-prev-field))))

;;; :emacs
(map! :map emacs-lisp-mode-map
      :nv "K"  #'helpful-at-point)

;;; :lang

(map!
  (:after org
    (:map my-org-format-map
      ;; Basic char syntax:
      ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Basic-Char-Syntax.html#Basic-Char-Syntax
      "b"   (λ! (org-emphasize ?*)) ;; bold
      "i"   (λ! (org-emphasize ?/)) ;; italic
      "k"   #'org-insert-link
      "K"   #'+org/remove-link
      "l"   #'org-store-link
      "m"   (λ! (org-emphasize ?~)) ;; monospace/code
      "u"   (λ! (org-emphasize ?_)) ;; underline
      "v"   (λ! (org-emphasize ?=)) ;; verbose
      "s"   (λ! (org-emphasize ?+)) ;; strikethrough
      "r"   (λ! (org-emphasize ?\s)) ;; restore format
      )

    (:map org-mode-map
      "s-r"        #'org-refile
      "s-R"        #'+org/refile-to-running-clock
      :vi "s-f"    my-org-format-map

      :n "SPC"     #'org-todo
      :n "S-SPC"   #'org-todo-yesterday

      :n "C-n"     #'org-metadown
      :n "C-p"     #'org-metaup

      :mi "C-o"    #'evil-org-org-insert-heading-respect-content-below

      (:when IS-MAC
        "s-o"   #'+org/insert-item-below
        "s-O"   #'+org/insert-item-above)

      :localleader
      :desc "format" "f"    my-org-format-map
      :desc "Timestamp"                        "t"   #'org-time-stamp
      :desc "Togle Timestamp type"             "T"   #'org-toggle-timestamp-type
      :desc "Inactive Timestamp"               "i"   #'org-time-stamp-inactive

      "F" #'org-footnote-new
      "y" #'org-copy
      "p" #'org-paste-subtree
      "P" #'org-priority)

    (:map org-capture-mode-map
      "s-r" #'org-capture-refile
      "s-w" #'org-capture-kill
      "s-s" #'org-capture-finalize
      )

    (:map org-src-mode-map
      "s-w" #'org-edit-src-abort
      "s-s" #'org-edit-src-exit
      ))

  (:after evil-org-agenda
    :map evil-org-agenda-mode-map
    ;; :map (org-agenda-keymap org-agenda-mode-map org-super-agenda-header-map)
    :m "k" #'org-agenda-previous-item
    :m "j" #'org-agenda-next-item)
  )


;; ╻  ┏━╸┏━┓╺┳┓┏━╸┏━┓
;; ┃  ┣╸ ┣━┫ ┃┃┣╸ ┣┳┛
;; ┗━╸┗━╸╹ ╹╺┻┛┗━╸╹┗╸
;; Leader

(map! :leader
      :desc "Eval expression"          ":"    #'pp-eval-expression
      :desc "M-x"                      ";"    #'execute-extended-command
      :desc "Switch to scratch buffer" "X"    #'doom/switch-to-scratch-buffer
      :desc "Show marks"               "'"    #'counsel-evil-marks

      ;;; <leader> l --- language
      (:when (featurep! :config language)
        (:prefix ("l" . "language")
          :desc "Configure translate languages"    ","   #'+language/set-google-translate-languages
          :desc "Translate"                        "t"   #'google-translate-smooth-translate
          :desc "Translate any language"           "a"   #'+language/google-translate-smooth-translate-any
          :desc "Translate from source lang"       "s"   #'google-translate-at-point
          :desc "Translate from destination lang"  "d"   #'google-translate-at-point-reverse))

      ;;; <leader> b --- buffer
      (:prefix ("b" . "buffer")
        :desc "Kill buried buffers"         "K"   #'doom/kill-buried-buffers)

      ;;; <leader> f --- file
      (:prefix ("f" . "file")
        :desc "Search in emacs.d"           "E" (λ! (+eduarbo/search-project doom-emacs-dir))
        :desc "Find file in DOOM config"    "c" (λ! (+eduarbo/find-file doom-private-dir))
        :desc "Search in DOOM config"       "C" (λ! (+eduarbo/search-project doom-private-dir))
        :desc "Find file in other project"  "o" #'doom/find-file-in-other-project
        :desc "Search in other project"     "O" #'+default/search-other-project
        :desc "Find file in .dotfiles"      "d" (λ! (+eduarbo/find-file dotfiles-dir))
        :desc "Search in .dotfiles"         "D" (λ! (+eduarbo/search-project dotfiles-dir)))

      ;;; <leader> g --- git
      (:prefix ("g" . "git")
        (:when (featurep! :tools magit)
          :desc "Timemachine for branch"    "T"   #'git-timemachine-switch-branch
          :desc "Magit diff staged"         "d"   #'magit-diff-buffer-file
          :desc "Magit diff"                "D"   #'magit-diff))

      ;;; <leader> n --- notes
      (:prefix ("n" . "notes")
        :desc "New Entry"                     "j" #'org-journal-new-entry
        :desc "Search Forever"                "J" #'org-journal-search-forever
        :desc "Open project notes"            "p" #'+org/find-notes-for-project)

      ;;; <leader> o --- open
      (:prefix ("o" . "open")
        :desc "Shell command"                 "s" #'async-shell-command
        :desc "Shell command in project root" "S" #'projectile-run-async-shell-command-in-root)

      ;;; <leader> TAB --- workspace
      (:prefix ("TAB" . "workspace")
        :desc "Kill this workspace"          "k" #'+workspace/delete)

      ;;; <leader> p --- project
      (:prefix ("p" . "project")
        :desc "Run cmd in project root"      "!" #'projectile-run-async-shell-command-in-root
        :desc "Discover projects"            "D" #'projectile-discover-projects-in-search-path
        :desc "Open project notes"           "n" #'+org/find-notes-for-project)

      ;;; <leader> t --- toggle
      (:prefix ("t" . "toggle")
        :desc "Line numbers"                 "l" #'display-line-numbers-mode
        :desc "Global Line numbers"          "L" #'global-display-line-numbers-mode
        :desc "Visual line mode"             "v" #'visual-line-mode
        :desc "Subword mode"                 "w" #'subword-mode
        :desc "Frame maximized"              "z" #'toggle-frame-maximized)

      ;;; <leader> w --- window
      (:prefix ("w" . "window")
        :desc "Most recently used buffer"    "w" #'evil-window-mru))
