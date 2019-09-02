;;; ~/.dotfiles/editor/emacs/doom/+bindings2.el -*- lexical-binding: t; -*-

;; This file defines a Spacemacs-esque keybinding scheme

;;
;;; Global keybindings

(map! "s-;" #'execute-extended-command
      "s-x" #'execute-extended-command
      "s-," #'+nav-flash/blink-cursor
      "s-." #'helpful-key

      "s-[" #'previous-buffer
      "s-]" #'next-buffer

      :m "s-j" #'multi-next-line
      :m "s-k" #'multi-previous-line

      :i [tab] (general-predicate-dispatch nil ; fall back to nearest keymap
                 (and (featurep! :editor snippets)
                      (bound-and-true-p yas-minor-mode)
                      (yas-maybe-expand-abbrev-key-filter 'yas-expand))
                 'yas-expand
                 (and (featurep! :completion company)
                      (+company-has-completion-p))
                 'company-indent-or-complete-common)

      (:when (featurep! :ui workspaces)
        "s-t" #'+workspace/new
        "s-{" #'+workspace/switch-left
        "s-}" #'+workspace/switch-right)

      [remap evil-jump-to-tag] #'projectile-find-tag
      [remap find-tag]         #'projectile-find-tag

      ;; Smarter RET in normal mode
      :n "RET" (general-predicate-dispatch nil
                 (and (bound-and-true-p flyspell-mode)
                      (+flyspell-correction-at-point-p))
                 'flyspell-correct-word-generic)

      ;; misc
      :nvi "C-n"  #'sp-next-sexp
      :nvi "C-p"  #'sp-previous-sexp

      :gnv "s-/"  #'which-key-show-top-level
      :nv ";"     #'evil-ex
      :nv ":"     #'eval-expression

      :n "#"      #'evil-commentary-line
      :v "#"      #'evil-commentary

      ;; Shift text
      :n  "<"     #'evil-shift-left-line
      :n  ">"     #'evil-shift-right-line
      ;; don't leave visual mode after shifting
      :v  "<"     #'+evil/visual-dedent  ; vnoremap < <gv
      :v  ">"     #'+evil/visual-indent  ; vnoremap > >gv

      :n  "H"     #'previous-buffer
      :n  "L"     #'next-buffer

      :n  "C-."   (cond ((featurep! :completion ivy)   #'ivy-resume)
                        ((featurep! :completion helm)  #'helm-resume))

      :n  "~"        #'evil-switch-to-windows-last-buffer
      (:map evil-org-mode-map
        :n  "~"        #'evil-switch-to-windows-last-buffer)

      ;; Insert mode
      :gi "C-s"          #'isearch-forward
      (:map isearch-mode-map
        :gi "C-S-s"      #'isearch-repeat-backward)

      ;; Behave like a backspace
      :gi [C-backspace]  #'backward-delete-char-untabify

      ;; :gi [S-backspace]  #'delete-forward-char

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
      :i "S-RET"         #'tab-to-tab-stop
      :i [S-return]      #'tab-to-tab-stop
      ;; TODO: Tranpose last two WORDS not those around
      :gi "C-t"          #'transpose-words
      ;; TODO: Tranpose last two SEXPS not those around
      :gi "C-S-t"        #'transpose-sexps

      :nv "C-a"   #'evil-numbers/inc-at-pt
      :nv "C-S-a" #'evil-numbers/dec-at-pt

      ;; Easier window/tab navigation
      :en "C-h"   #'evil-window-left
      :en "C-j"   #'evil-window-down
      :en "C-k"   #'evil-window-up
      :en "C-l"   #'evil-window-right

      ;; expand-region
      :v "v"   (general-predicate-dispatch 'er/expand-region
                 (eq (evil-visual-type) 'line)
                 'evil-visual-char)
      :v "C-v" #'er/contract-region

      :nv "go"    #'avy-goto-char-timer
      :nv "g/"    #'+default/search-project
      :n  "g."    #'call-last-kbd-macro)

;; help
(map! (:map help-map
        "H"   #'+lookup/documentation))


;;
;;; Module keybinds

;;; :completion
(map! (:when (featurep! :completion company)
        (:prefix [backtab]
          :i "l"    #'+company/whole-lines
          :i "k"    #'+company/dict-or-keywords
          :i "f"    #'company-files
          :i "t"    #'company-etags
          :i "s"    #'company-ispell
          :i "y"    #'company-yasnippet
          :i "o"    #'company-capf
          :i "n"    #'+company/dabbrev
          :i "p"    #'+company/dabbrev-code-previous))

      (:when (featurep! :completion ivy)
        (:after ivy
          :map ivy-minibuffer-map
          [C-return] #'ivy-call-and-recenter  ; preview file
          "C-o"      #'hydra-ivy/body
          )
        (:after counsel
          :map counsel-ag-map
          [C-return]    #'ivy-call-and-recenter ; preview
          [backtab]  #'+ivy/woccur
          "C-,"      (+ivy-do-action! #'+ivy-git-grep-other-window-action))
        (:after swiper
          :map swiper-map
          [backtab] #'+ivy/wgrep-occur))

      (:when (featurep! :completion helm)
        (:after helm
          (:after swiper-helm
            :map swiper-helm-keymap [backtab] #'helm-ag-edit)
          (:after helm-ag
            :map helm-ag-map
            [backtab]  #'helm-ag-edit))))

;;; :ui
(map! (:when (featurep! :ui workspaces)
        :n  "C-`"  #'+eduarbo/switch-to-last-workspace
        (:map evil-org-mode-map
          :n  "C-`"  #'+eduarbo/switch-to-last-workspace)

        :n "C-S-l" #'+workspace/switch-right
        :n "C-S-h" #'+workspace/switch-left)

      (:when (featurep! :ui treemacs)
        (:map evil-treemacs-state-map
          "C-h" #'evil-window-left
          "C-l" #'evil-window-right
          "s-j" #'multi-next-line
          "s-k" #'multi-previous-line)))

;;; :editor
(map! (:when (featurep! :editor fold)
        :nv "SPC" #'+fold/toggle)

      (:when (featurep! :editor snippets)
        (:after yasnippet
          (:map yas-keymap
            ;; Do not interfer with yas-expand, sometimes I want to type "a" and
            ;; move to the next field without accidentally inserting a snippet
            [tab]         nil
            "TAB"         nil
            [backtab]     nil
            "<S-tab>"     nil
            "C-n"         #'yas-next-field
            "C-p"         #'yas-prev-field))))

;;; :emacs
(map! :map emacs-lisp-mode-map
      :nv "K"  #'helpful-at-point)

;;; :tools
(map! (:when (featurep! :tools flyspell)
        ;; Keybinds that have no Emacs+evil analogues (i.e. don't exist):
        ;;   zq - mark word at point as good word
        ;;   zw - mark word at point as bad
        ;;   zu{q,w} - undo last marking
        ;; Keybinds that evil define:
        ;;   z= - correct flyspell word at point
        ;;   ]s - jump to previous spelling error
        ;;   [s - jump to next spelling error
        :m "]S" #'flyspell-correct-word-generic
        :m "[S" #'flyspell-correct-previous-word-generic)

      (:when (featurep! :tools flycheck)
        :m "]e" #'next-error
        :m "[e" #'previous-error)

      (:when (featurep! :tools gist)
        :after gist
        :map gist-list-menu-mode-map
        :n "RET"    #'+gist/open-current
        :n [return] #'+gist/open-current))

;;; :lang

(map! :map evil-org-mode-map
      :after org
      :n "SPC"   #'org-todo)

(map! :map org-mode-map
      :after org

      :nv "s-j"  #'org-metadown
      :nv "s-k"  #'org-metaup

      (:when IS-MAC
        "s-o"   #'+org/insert-item-below
        "s-O"   #'+org/insert-item-above)

      :localleader
      ;; A fresh start - Unmap the whole map
      "" nil

      :localleader

      :desc "Schedule"              :n  "s"   #'org-schedule
      :desc "Set deadline"          :n  "d"   #'org-deadline
      :desc "Set tags"              :n  "t"   #'org-set-tags-command
      ;; Basic char syntax:
      ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Basic-Char-Syntax.html#Basic-Char-Syntax
      :desc "Bold"                  :v  "b"   (λ! (org-emphasize ?*)) ;; bold
      :desc "Italic"                :v  "i"   (λ! (org-emphasize ?/)) ;; italic
      :desc "Insert link"           :v  "k"   #'org-insert-link
      :desc "Remove link"           :nv "K"   #'+org/remove-link
      :desc "Store link to heading" :n  "l"   #'org-store-link
      :desc "Monospace/code"        :v  "m"   (λ! (org-emphasize ?~)) ;; monospace/code
      :desc "Restore format"        :v  "r"   (λ! (org-emphasize ?\s)) ;; restore format
      :desc "Underline"             :v  "u"   (λ! (org-emphasize ?_)) ;; underline
      :desc "Verbose"               :v  "v"   (λ! (org-emphasize ?=)) ;; verbose
      :desc "Strikethrough"         :v  "x"   (λ! (org-emphasize ?+)) ;; strikethrough

      (:prefix ("c" . "clock/timer")
        :desc "Start timer"                   :n "c" #'org-clock-in
        :desc "Stop timer"                    :n "C" #'org-clock-out
        :desc "Display total time on heading" :n "d" #'org-clock-display
        :desc "Create table report"           :n "d" #'org-clock-report
        :desc "Go to running timer's entry"   :n "g" #'org-clock-goto
        :desc "Select past timers entry"      :n "G" (λ! (org-clock-goto 'select))
        :desc "Cancel running timer"          :n "x" #'org-clock-cancel))

(map! :mode org-journal-mode
      :localleader
      :map org-journal-mode-map
      "n" #'org-journal-open-next-entry
      "p" #'org-journal-open-previous-entry)


;;
;;; <leader>

(map! :leader
      :desc "Eval expression"       ":"    #'eval-expression
      :desc "M-x"                   ";"    #'execute-extended-command

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
        :desc "Find file in .dotfiles"        "t" #'+eduarbo/find-in-dotfiles
        :desc "Browse .dotfiles"              "T" #'+eduarbo/browse-dotfiles)

      ;;; <leader> g --- git
      (:prefix ("g" . "git")
        :desc "Git link for line or region" "y"   #'git-link
        (:when (featurep! :tools magit)
          :desc "Magit diff staged"         "d"   #'magit-diff-buffer-file
          :desc "Magit diff"                "D"   #'magit-diff))

      (:when (featurep! :ui workspaces)
        :desc "Switch workspace"            "TAB" #'persp-switch

        ;;; <leader> k --- workspace
        "k" doom-leader-workspace-map ;; Remap workspace to K prefix
        (:prefix ("k" . "workspace")
          :desc "Load a past session"       "L"   #'+workspace/load-session
          :desc "Autosave current session"  "S"   #'+workspace/save-session))

      ;;; <leader> n --- notes
      (:prefix ("n" . "notes")
        :desc "New Journal entry"             "d" #'org-journal-new-entry
        :desc "Open mode notes"               "m" #'+eduarbo/find-notes-for-major-mode
        :desc "Open project notes"            "p" #'+eduarbo/find-notes-for-project)

      ;;; <leader> p --- project
      (:prefix ("p" . "project")
        :desc "Discover projects"            "D" #'projectile-discover-projects-in-search-path)

      ;;; <leader> t --- toggle
      (:prefix ("t" . "toggle")
        :desc "Line numbers"                 "l" #'display-line-numbers-mode
        :desc "Global Line numbers"          "L" #'global-display-line-numbers-mode
        :desc "Visual line mode"             "v" #'visual-line-mode
        :desc "Subword mode"                 "w" #'subword-mode
        :desc "Frame maximized"              "z" #'toggle-frame-maximized))
