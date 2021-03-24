;;; 034b_org_compile_latex_framework_redo --- 15 Mar 2021 18:14
;;; Commentary:
;; This is a redo from scratch to use a better template scheme
;; based on symbolic link from template folder to compile folder.

;;; Code:

;;; ================================================================
;;; Required packages and global option settings
;; First load this package to initialize variables:
(require 'ox-latex)

;; Use xelatex as latex compiler, thus enabling use of native fonts for greek etc.
(setq org-latex-compiler "xelatex")

;;; ================================================================
;;; Paths and path components for compiling
;; ================ SUMMARY ================
;; There is one custom variable: org-latex-base
;; There is one function for obtaining the selected-template name from the
;; exported file or subtree: org-latex-selected-template
;; There are are 4 functions for obtaining the paths of following directories:
;; 1. org-latex-compile-dir = org-latex-base ++ "compile_framework"
;; 2. org-latex-exports-dir = org-latex-base ++ "exports"
;; 3. org-latex-templates-dir = org-latex-base ++ "templates"
;; 4. org-latex-selected-template-path =
;;                  org-latex-templates ++ org-latex-selected-template
;; ================ DETAILS ================
;; 1. org-latex-base : Basic directory (contains all other directories)
;; org-latex-base is a custom variable;

;; 2. org-latex-compile-dir : used to compile the exported latex to pdf
;; function: concatenate org-latex-base with "compile_framework"

;; 3. org-latex-exports-dir : compiled pdf files are copied to
;; this directory.
;; function: concatenate org-latex-base with "exports"

;; 4. org-latex-templates-dir : contains all templates as subdirectories
;; function: concatenate org-latex-base with "templates"

;; 5. org-latex-selected-template : name of directory to use as template.
;; function: obtain from file or subtree property "LATEX_TEMPLATE"
;; defaults to "default_framework"

;; 6. org-latex-selected-template-path : path of template directory
;; The template is linked (or copied?) from this path to org-latex-compile-dir
;; function: concatenate org-latex-templates-dir with selected-template

;;; ================================================================
;;; Auxiliary help functions for getting properties from file
;; org-latex-get-file-template-name :
;;      Get template name from file property
;; org-latex-get-subtree-template-name :
;;      Get template name from subtree property

;;; ================================================================
;; Interactive functions (called from hydra. Calling with U-argument
;; switches not feasible because of 2 options: xelatexp, subtreep)
;;; 1. Main function: org-compile-latex-with-custom-framework
;;; argument: (P - interactive with prefix)
;; - entirefilep: if not nil, compile entire file. Else compile subtree
;;; 2. Set compiler choice: xelatex or pdflatex
;; Function: org-latex-set-compiler
;; Allow a choice of xelatex or pdflatex from minibuffer

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
After each export, rename and copy file framework.tex (the file providing the
style and package specifications for compiling the pdf) to this directory.
The name is named after from the filename or compile name of the pdf + timestamp.

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

;;; 034b_org_compile_latex_framework_redo ends here
