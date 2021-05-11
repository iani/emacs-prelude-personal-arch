;;; 034b_org_compile_latex_framework_redo --- 15 Mar 2021 18:14
;;; Commentary:
;; This is a redo from scratch to use a better template scheme
;; based on symbolic link from template folder to compile folder.
;; see accompanying .org file for documentation

;;; Code:

;;; ================================================================
;;; Required packages and global option settings
;; First load this package to initialize variables:
(require 'ox-latex)

;; Use xelatex as latex compiler, thus enabling use of native fonts for greek etc.
(setq org-latex-compiler "xelatex")

;;; ================================================================
;;; PATHS:
;;; org-latex-base org-latex-default-template
;;; org-latex-exports-dir org-latex-templates-dir org-latex-compile-dir
;;;

(defcustom pdflatexp ()
  "If true, use pdflatex, else use xelatex"
  :group 'org-latex-compile)

(defcustom org-latex-base (file-truename "~/latex-exports/")
  "Directory where latex template and export files are stored.
Both the source files and the resulting pdf files are stored in this directory."
  :group 'org-latex-compile)

(defcustom org-latex-template-property 'LATEX-TEMPLATE
  "Name of the org property that stores the latex template name."
  :group 'org-latex-compile)

(defcustom org-latex-default-template "default-template"
  "Default template directory name."
  :group 'org-latex-compile)

(defun org-latex-exports-dir ()
  "Directory where exported pdf files are stored."
  (concat org-latex-base "exports/"))

(defun org-latex-templates-dir ()
  "Directory storing templates for exporting to latex."
  (concat org-latex-base "templates/"))

(defun org-latex-compile-dir ()
  "Directory where latex is exported and compiled to pdf.
This is created by copying the selected template directory."
  (concat org-latex-base "compile_framework/"))

(defun org-latex-selected-template-path (&optional subtreep)
  "Get path of selected template."
  (concat org-latex-base (org-latex-selected-template subtreep)))

(defun org-latex-selected-template (&optional subtreep)
  "Get name of selected template.
If subtreep return subtree property. Else return file property"
  (stringify (if subtreep
      (or (org-property-or-variable-value org-latex-template-property)
            (org-latex-get-file-template))
    (org-latex-get-file-template))))

(defun stringify (theargument)
  "Turn symbol into string if needed."
  (if (symbolp theargument)
      (symbol-name theargument)
    theargument))

(defun org-latex-get-file-template ()
  "If defined, return file property for latex template, else return default template."
  (org-get-global-buffer-property
   (symbol-name org-latex-template-property)
   org-latex-default-template))

;;; Helper functions for getting global file property
(defun org-global-props (property &optional buffer)
  "Get the plists of global org properties of current buffer."
  (with-current-buffer (or buffer (current-buffer))
    (org-element-map (org-element-parse-buffer) 'keyword
      (lambda (el)
        (when (string-match property (org-element-property :key el)) el)))))

(defun org-get-global-buffer-property (prop &optional default)
  "Get the value of property prop defined globally in current buffer.
If not defined, return the default provided as optional argument."
  (or
   (car (mapcar (lambda (prop) (org-element-property :value prop))
            (org-global-props prop)))
   default))

;;; ================================================================
;;; THE MAIN FUNCTION

(defun org-compile-latex-with-custom-framework (&optional filep)
  "Export org to latex and compile that to pdf.
If filep is true export the entire file, else only the current section."
  (interactive "P")
  (let* (pdf-file ;; used to copy file to exports folder
         (subtreep (not filep))
         (template-path (org-latex-selected-template-path subtreep))
         ;; path of source framework file to compile to pdf
         (framework-path (concat template-path "/framework.tex"))
         (export-filename ;; input filename from user, providing default
          (read-string
           "pdf export file copy name base:"
           (if subtreep
               (substring-no-properties
                (replace-regexp-in-string "\\W" ""  (org-get-heading t t)))
             (file-name-nondirectory (file-name-sans-extension
                                      (buffer-file-name))))))
         (latex-output (org-export-as
                        ;; backend subtreep visible-only body-only ext-plist
                        'latex     subtreep      nil          t         nil
                        )))
    (copy-directory template-path (org-latex-compile-dir))
    ;; save latex outout as body file:
    (with-temp-buffer
      ;; (insert "\\noindent\n") ;; start first paragraph non-indented. Needed?
      (insert latex-output)
      (write-file (concat (org-latex-compile-dir) "/body.tex")))
    ;; compile framework using content from exported body
    (setq pdf-file                                       ;; t: do not open!
          (latex-compile-file-with-latexmk pdflatexp framework-path t))
    (copy-file
     pdf-file
     (concat (org-latex-exports-dir) (file-name-base pdf-file) ".pdf"))
    )

  )

(defun latex-compile-file-with-latexmk (&optional pdflatexp filename donotopen)
  "Compile tex file using latexmk.
  If PDFLATEXP then use pdflatex instead of xelatex.
  Open resulting pdf file with default macos open method."
  ;; (message "*Async Shell Command*")
  ;; (message "*Async Shell Command* exists? %s"
  ;;          (gnus-buffer-exists-p "*Async Shell Command*"))
  (when (gnus-buffer-exists-p "*Async Shell Command*")
    (kill-buffer "*Async Shell Command*"))
  ;; provide file name from buffer if needed
  (let* ((file (or filename (buffer-file-name)))
         (pdf-file (concat ;; compute pdf filename from tex filename
                    (file-name-sans-extension file)
                    ".pdf"))
         (org-latex-pdf-process
          (if pdflatexp
              '("latexmk -shell-escape -g -pdf -pdflatex=\"pdflatex\" -outdir=%o %f")
            '("latexmk -shell-escape -g -pdf -pdflatex=\"xelatex\" -outdir=%o %f"))))
    (message "latex compile command is:\n %s" org-latex-pdf-process)
    ;; why delete .bbl file?
    ;; (delete-file (concat (file-name-sans-extension file) ".bbl"))
    (org-latex-compile file)
    (message "tex->pdf done. Opening:\n%s" (shell-quote-argument pdf-file))
    (unless donotopen
      ;; open the copy of the exported file:
      ;; requires epdfview installed in arch linux
      ;; for macos, use "open" instead.
      (shell-command (concat "epdfview " (shell-quote-argument pdf-file) " & "))
      ;; (shell-command (concat "open " (shell-quote-argument pdf-file)))
      )
    pdf-file ;; return pdf file for further use by other function if needed
    ))

;; (concat (org-latex-compile-dir) "/body.tex")

(global-set-key (kbd "C-M-S-c") 'org-compile-latex-with-custom-framework)
;;; 034b_org_compile_latex_framework_redo ends here
