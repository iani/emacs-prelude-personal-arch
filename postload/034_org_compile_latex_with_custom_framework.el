;;; org_compile_latex_with_custom_framework --- 2019-06-29 08:08:23 AM
;;; Commentary:

;; 28 Feb 2019 14:18 ff
;; New version: Using a set framework.tex file
;; 15 Dec 2020 12:02
;; Second new version: Use 1 template buffer, save framework files
;; See documentation in file LATEX_README.org

;; The framework file is in a folder that may contain all other necessary assets
;; e.g. bib or graphics files.
;; The org source is exported as body.tex and then imported by the framework file
;; using \input{body.tex}
;; The pdf output file is copied to the exports folder with a name
;; provided by the user and a timestamp.

;; Compile org mode buffer to pdf using these options:
;; 1. xelatex or pdflatex
;; 2. whole buffer or current subtree only

;; Instead of defining the latex header using org-mode/emacs,
;; output the latex body only, and then import it in a framework template
;; specified by the user.
;; Use latex \import{file} directive inside template file to import the body
;; exported by org-mode.
;; To specify the template file that you want to use in an org-mode-file or section,
;; store it as file or subtree property "LATEX_EXPORT_TEMPLATE."

;; A. How the template path is stored in the org file:

;; A1: If the export option current subtree is chosen, then:
;; A1.1 Get the path stored in property "LATEX_EXPORT_TEMPLATE" in the current subtree
;; A1.2 If the path is not found in property of A1.1,
;; then get the global property "LATEX_EXPORT_TEMPLATE".
;; A1.3 If none of the above 1 and 2 are found, then use the default path:
;; ~/latex-exports/templates/00BASIC/framework.tex
;; A1.4 If the path given is a directory, then append to it "framework.tex".
;; Else use the path as-is.

;; B. How the template is used for compiling.

;; Note: By framework file we mean the file specified by the user, which will provide
;; the necessary header and footer.
;; By <template> we mean the path of the directory which contains the framework file.
;; The framework file must contain an input statement: \input{body.tex}.
;; Org exports the chosen subtree or the entire buffer as body only, into the file:
;; <template>body.tex.
;; Then it compiles the file <template>/framework.tex
;; It uses as output a name chosen interactively from the user,
;; and always adds a date stamp to it.
;; After compiling, it copies the resulting pdf file into the folder
;; ~/latex-exports/exports/

;; (defun org-insert-latex-headers-from-deft ()
;;   "Choose latex headers from recipe list using deft,
;; and append them to the currently edited file."
;;   (with-current-buffer
;;     ))


;;; Code:

;; First load this package to initialize variables:
(require 'ox-latex)

;; Use xelatex as latex compiler, thus enabling use of native fonts for greek etc.
(setq org-latex-compiler "xelatex")

;; ================================================================
;; PATHS OF DIRECTORIES AND FILES USED IN THE COMPILE PROCESS:

(defcustom org-latex-export-path (file-truename "~/latex-exports")
  "Directory where latex template and export files are stored.
Both the source files and the resulting pdf files are stored in this directory."
  :group 'org-latex-compile)

(defcustom org-latex-template-directory "/000BASIC"
  "Subdirectory containing sources for compiling latex.
Contains the framework file with latex header, style specifications and footer,
and any auxiliary files e.g. bibtex, images etc.
The body.tex file produced by org-export-as as well as the resulting
pdf file are temporarily stored here.  The final pdf is copied to ../exports
after the end of the export process.
"
  :group 'org-latex-compile)

(defcustom org-latex-history-directory "/history"
  "Subdirectory storing framework files.
After each export, add Copy file framework.tex after each export to this directory,
used to compile pdf after after each export, and
"
  :group 'org-latex-compile)

(defun org-latex-framework-path ()
  "Calculate actual path of framework file."
  (let ((template-path (concat org-latex-export-path
                               org-latex-template-directory
                               org-latex-history-directory
                               "/framework.tex")))
    (if (file-exists-p template-path)
        template-path
      (error "You must install latex-templates in your home folder to use this."))))

(defun org-latex-default-framework-path ()
  "Calculate default path of framework file."
  (let ((template-path (concat org-latex-export-path
                               org-latex-template-directory
                               org-latex-history-directory
                               "/framework.tex")))
    (if (file-exists-p template-path)
        template-path
      (error "You must install latex-templates in your home folder to use this."))))

(defun org-latex-body-path (framework-path)
  "Calculate full path of file to export latex body from org."
  (concat org-latex-export-path org-latex-template-directory "/body.tex"))

(defun org-latex-get-subtree-template-path ()
  "Get latex template file path from LATEX_HEADER_PATH property of current subtree."
  (save-excursion
    (org-with-wide-buffer
     (goto-char (point-min)))
    (let* ((property-name "LATEX_HEADER_PATH")
           (property-value (org-entry-get (point) property-name)))
      (if property-value
          property-value
        (org-latex-get-file-template-path)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Bibliography stuff - not yet implemented
(defcustom org-latex-bib-folder "/bibliographies/"
  "Directory where default bib files are stored.
  This is a subdirectory of ORG-LATEX-EXPORT-PATH."
  :group 'org-latex-compile)

(defcustom org-latex-bib-filename "References.bib"
  "Name of default bib file."
  :group 'org-latex-compile)

(defun org-latex-bib-full-path ()
  "Calculate full path of file to default bib file.
  Concatenate org-latex-export-path with org-latex-bib-folder and org-latex-bib-filename."
  (concat org-latex-export-path org-latex-bib-folder org-latex-bib-filename))

;;; end of bibliography stuff block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun org-pdflatex-compile-buffer ()
  "Export buffer as body.tex and create pdf with pdflatex using template.
  The template for the buffer is chosen by org-latex-get-file-template-path."
  (interactive)
  ;;                               pdflatexp subtreep
  (org-latex-compile-with-template t         nil))

(defun org-xelatex-compile-buffer ()
  "Export buffer as body.tex and create pdf with xelatex using template.
  The template for the buffer is chosen by org-latex-get-file-template-path."
  (interactive)
  ;;                               pdflatexp subtreep
  (org-latex-compile-with-template nil        nil))

(defun org-pdflatex-compile-subtree ()
  "Export subtree as body.tex and create pdf with pdflatex using template.
  The template for the buffer is chosen by org-latex-get-file-template-path."
  (interactive)
  ;;                               pdflatexp subtreep
  (org-latex-compile-with-template t         t))

(defun org-xelatex-compile-subtree ()
  "Export subtree as body.tex and create pdf with xelatex using template.
  The template for the buffer is chosen by org-latex-get-file-template-path."
  (interactive)
  ;;                               pdflatexp subtreep
  (org-latex-compile-with-template nil        t))

(defun org-latex-compile-with-template (pdflatexp subtreep)
  "Export buffer or subtree as body.tex and create pdf using template.
  If PDFLATEXP then use pdflatex, else use xelatex.
  If SUBTREEP then export subtree only, else export entire buffer.
  The template for the buffer is chosen by org-latex-get-file-template-path."
  (let*
      ((template-path (if subtreep
                          (org-latex-get-subtree-template-path)
                        (org-latex-get-file-template-path)))
       (template-directory (file-name-directory template-path))
       (export-file-copy-path
        (concat
         org-latex-export-path "/exports/"
         (read-string
          "pdf export file copy name base:"
          (if subtreep
              (substring-no-properties
               (replace-regexp-in-string "\\W" ""  (org-get-heading t t)))
            (file-name-nondirectory (file-name-sans-extension
                                     (buffer-file-name)))))
         "_"
         (format-time-string "%y%m%d")
         ".pdf"))
       (body-path (concat template-directory "body.tex"))
       (latex-output (org-export-as
                      ;; backend subtreep visible-only body-only ext-plist
                      'latex     subtreep      nil          t         nil
                      )))
    ;; prepare body file containing plain tex body output
    (with-temp-buffer
      (insert "\\noindent\n")
      (insert latex-output)
      (write-file body-path))
    ;; prepare framework file by copying template file to the
    ;; compilation folder, and naming it "framework.tex"

    (copy-file template-path (concat template-directory "framework.tex") t)
    ;; compile framework and body files into framework.pdf file
    (latex-compile-file-with-latexmk pdflatexp template-path t) ;; t: do not open!
    (copy-file
     (concat (file-name-sans-extension template-path) ".pdf")
     export-file-copy-path
     t)
    ;; open the copy of the exported file:
    ;; requires epdfview installed in arch linux
    ;; for macos, use "open" h.
    (shell-command
     (concat "epdfview " (shell-quote-argument export-file-copy-path) " & "))
    (message "pdf export file copied to:\n%s" export-file-copy-path)
    (message "now trying to copy TEMPLATE - EXPERIMENTAL")
    (message "the path is %s" template-path)
    (let ((target-path (concat (file-name-directory template-path) "history/"
                                (file-name-base export-file-copy-path) ".tex")))
      (message "should copy from:%s\n to:\n %s" template-path target-path)
      (make-directory (file-name-directory target-path) t)
      (copy-file template-path target-path)
      ;; save target-path in buffer for future reference
      (if subtreep
          (org-latex-set-subtree-template target-path)
        (org-latex-set-buffer-template target-path))
      (message "done"))))

(defun xelatex-compile-buffer ()
  "Compile current tex buffer into PDF using xelatex.
  Use latexmk command as seen in org-mode export code."
  (interactive)
  (latex-compile-file-with-latexmk))

(defun pdflatex-compile-buffer ()
  "Compile current tex buffer into PDF using pdflatex.
  Use latexmk command as seen in org-mode export code."
  (interactive)
  (latex-compile-file-with-latexmk t))

(defun latex-compile-file-with-latexmk (&optional pdflatexp filename donotopen)
  "Compile tex file using latexmk.
  If PDFLATEXP then use pdflatex instead of xelatex.
  Open resulting pdf file with default macos open method."
  ;; (message "*Async Shell Command*")
  ;; (message "*Async Shell Command* exists? %s"
  ;;          (gnus-buffer-exists-p "*Async Shell Command*"))
  (when (gnus-buffer-exists-p "*Async Shell Command*")
    (kill-buffer "*Async Shell Command*"))
  (let* ((file (or filename (buffer-file-name)))
         (pdf-file (concat
                    (file-name-sans-extension file)
                    ".pdf"))
         (org-latex-pdf-process
          (if pdflatexp
              '("latexmk -shell-escape -g -pdf -pdflatex=\"pdflatex\" -outdir=%o %f")
            '("latexmk -shell-escape -g -pdf -pdflatex=\"xelatex\" -outdir=%o %f"))))
    (message "latex compile command is:\n %s" org-latex-pdf-process)
    (delete-file (concat (file-name-sans-extension file) ".bbl"))
    (org-latex-compile file)
    (message "tex->pdf done. Opening:\n%s" (shell-quote-argument pdf-file))
    (unless donotopen
      ;; open the copy of the exported file:
      ;; requires epdfview installed in arch linux
      ;; for macos, use "open" instead.
      (shell-command (concat "epdfview " (shell-quote-argument pdf-file) " & "))
      ;; (shell-command (concat "open " (shell-quote-argument pdf-file)))
      )))

(defun org-latex-post-file-template-path ()
  "Post the path of the latex template file for this file."
  (interactive)
  (message "The file template path is:\n%s" (org-latex-get-file-template-path)))

(defun org-latex-get-file-template-path ()
  "Get the path of the latex template file from the LATEX_HEADER_PATH property of this file."
  (save-excursion
    (org-with-wide-buffer
     (goto-char (point-min))
     (let* ((property-value (org-latex-default-template-path))
            (property-name "LATEX_HEADER_PATH")
            (here (re-search-forward
                   (concat "^"
                           (regexp-quote (concat "#+" property-name ":"))
                           " ?") nil t)))
       (message "found here: %s" here)
       (when here
         (goto-char here)
         ;; (message (buffer-substring-no-properties here (line-end-position)))
         (setq property-value
               (buffer-substring-no-properties here (line-end-position))))
       property-value))))

(defun org-latex-post-subtree-template-path ()
  "Post the path of the latex template file for current subtree."
  (interactive)
  (message "The subtree template path is:\n%s" (org-latex-get-subtree-template-path)))

(defun org-latex-set-subtree-template-interactively ()
  "Read value of LATEX_HEADER_PATH property from user and set it in current subtree."
  (interactive)
  (let ((path (org-latex-read-template-path)))
    (org-latex-set-subtree-template path)))

(defun org-latex-set-subtree-template (path)
  "Set value of LATEX_HEADER_PATH property in current subtree."
  (org-set-property "LATEX_HEADER_PATH" path)
  (message "You selected: \n%s" path))

(defun org-latex-read-template-path ()
  "Read template path interactively from default folder."
  (let
      ((result
        (read-file-name "Select template file: "
                        "~/latex-exports/templates/000BASIC/history/"
                        "framework.tex")))
    (if (file-directory-p result)
        (concat result "framework.tex")
      result)))

(defun org-latex-set-buffer-template-interactively ()
  "Read value of LATEX_HEADER_PATH from user and set it globally in buffer."
  (interactive)
  (let ((path (org-latex-read-template-path)))
    (org-latex-set-buffer-template path)))

(defun org-latex-set-buffer-template (path)
  "Set value of LATEX_HEADER_PATH property globally in current buffer."
  (save-excursion
    (org-with-wide-buffer
     (goto-char (point-min))
     (let ((new-line "")
           (here (re-search-forward
                  (concat "^"
                          (regexp-quote (concat "#+" "LATEX_HEADER_PATH" ":"))
                          " ?") nil t)))
       (cond
        (here
         (goto-char here)
         (beginning-of-line)
         (kill-line))
        (t
         (setq new-line "\n")
         (goto-char (point-min))))
       (insert "#+LATEX_HEADER_PATH: " path new-line))))
  (message "You selected: \n%s" path))

(defun org-latex-set-buffer-export-name (&optional name)
  "Set value of LATEX_EXPORT_NAME property globally in current buffer."
  (interactive "sName: ")
  (org-set-subtree-or-buffer-property "LATEX_EXPORT_NAME" name t))

(defun org-latex-set-subtree-export-name (&optional name)
  "Set value of LATEX_EXPORT_NAME property in current subtree."
  (interactive "sName: ")
  (org-set-subtree-or-buffer-property "LATEX_EXPORT_NAME" name nil))

(defun org-set-subtree-or-buffer-property (property value bufferp)
  "Set PROPERTY to VALUE, in buffer if BUFFERP, else in subtree."
  (if bufferp
      (save-excursion
        (org-with-wide-buffer
         (goto-char (point-min))
         (let ((new-line "")
               (here (re-search-forward
                      (concat "^"
                              (regexp-quote (concat "#+" property ":"))
                              " ?") nil t)))
           (cond
            (here
             (goto-char here)
             (beginning-of-line)
             (kill-line))
            (t
             (setq new-line "\n")
             (goto-char (point-min))))
           (insert "#+" property ": " value new-line))))
    (org-set-property property value))
  (message "You selected: \n%s" value))

(defun org-get-custom-property (property-name)
  "Get property PROPERTY-NAME locally or globally."
  ;; (interactive "M")
  (unless property-name (setq property-name "LATEX_HEADER_PATH"))
  (let ((property-value (org-entry-get (point) property-name)))
    ;; (message "I found this: %s" property-value)
    (unless property-value
      (save-excursion
        (goto-char (point-min))
        (let ((here (re-search-forward
                     (concat "^"
                             (regexp-quote (concat "#+" property-name ":"))
                             " ?") nil t)))
          ;; (message "found here: %s" here)
          (when here
            (goto-char here)
            ;; (message (buffer-substring-no-properties here (line-end-position)))
            (setq property-value (buffer-substring-no-properties here (line-end-position))))
          )))
    property-value
    ))

(defun org-latex-find-file-template-file ()
  "Open file's template file."
  (interactive)
  (find-file (org-latex-get-file-template-path)))

(defun org-latex-find-subtree-template-file ()
  "Open file's template file."
  (interactive)
  (find-file (org-latex-get-subtree-template-path)))

(defun kill-latex-process-buffer ()
 "Kill the latex-proces buffer"
 (interactive)
 (kill-buffer "*Async Shell Command*"))

(defhydra hydra-latex (:color red :columns 2)
  "latex hydra"
  ("x" org-xelatex-compile-buffer "ORG xelatex buffer")
  ("X" org-xelatex-compile-subtree "ORG xelatex subtree")
  ("l" pdflatex-compile-buffer "TEX pdflatex buffer")
  ("L" xelatex-compile-buffer "TEX xelatex buffer")
  ("p" org-pdflatex-compile-buffer "ORG pdflatex buffer")
  ("P" org-pdflatex-compile-subtree "ORG pdflatex subtree")
  ("t" org-latex-set-buffer-template-interactively "set buffer template")
  ("T" org-latex-set-subtree-template-interactively "set subtree template")
  ("/" org-latex-post-file-template-path "post file template path")
  ("?" org-latex-post-subtree-template-path "post subtree template path")
  ("f" org-latex-find-file-template-file "find file template file")
  ("F" org-latex-find-subtree-template-file "find subtree template file")
  ("K" kill-latex-process-buffer "kill latex process buffer" :exit t)
  ("q" quit "exit hydra" :exit t))

(global-set-key (kbd "C-M-S-l") 'hydra-latex/body)
(provide 'org_compile_latex_with_custom_framework)
;;; 034_org_compile_latex_with_custom_framework.el ends here
