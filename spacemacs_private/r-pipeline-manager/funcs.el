;;; pipeline.el --- This is a lisp script for R project management

;;; Commentary:
;;

;;; Code:

;;; in order to avoid name collision, I add my name as prefix...
(defun ghan-add-r-script ()
  (interactive)
  (let ((script-name (read-file-name "Enter script name([a-z].[0-9].xxx.r):")))
    ;;TODO: threshold the number of characters of xxx to 20, that makes the pipeline figure easy to read
    (when (file-exists-p script-name)
      (error "script file: %s already exists." script-name)
      )
    (write-region "#' @input \n#' @output \n" nil script-name)
    ;;open a buffer for this new filenumber of lines and characters in the region. and switch to this buffer
    (find-file script-name)
    )
  )

;;(ghan-add-r-script )

(defun ghan-generate-r-pipeline-flowchart ();;project-root-dir)
  (interactive)
  "Invoke to show the overall pipeline, this is cool.
Argument PROJECT-ROOT-DIR work directory for your project."
  (let (;;(project-root-dir (read-directory-name "Enter script name([a-z].[0-9].xxx.r):"))
        ;;(default-directory project-root-dir)
        (command-make-image (concat "R --no-save <" (prin1-to-string configuration-layer-private-layer-directory) "r-pipeline-manager/show_pipeline.r"))
        (flowchart-file-name "pipeline-diagram.png"))
    (message command-make-image)
    (shell-command command-make-image)
    (when (file-exists-p flowchart-file-name)
      (find-file flowchart-file-name)
      )
    )
  )
;;(ghan-generate-r-pipeline-flowchart )

;;some small auxiliary fxns
(defun ghan-swapEqual(start end)
  "swap the word at the two side of ="

  (interactive "r")
  (let ((selContent (buffer-substring-no-properties start end)))
    ;;    (message selContent)
    (delete-region start end)
    (goto-char start)
    (insert (string-join (reverse  (split-string selContent "="))  "=")))
  )
(defun ghan-swapComma(start end)
  "swap the word at the two side of ,"

  (interactive "r")
  (let ((selContent (buffer-substring-no-properties start end)))
    ;;    (message selContent)
    (delete-region start end)
    (goto-char start)
    (insert (string-join (reverse  (split-string selContent ","))  ",")))
  )

;;insert date time
(defun ghan-insert-current-date ()
  (interactive)
  (insert (format-time-string "%y-%m-%d %H:%M:%S" (current-time))))

;;create an easy readable r script
(defun ghan-new-r-script ()
  (interactive)
  "create an r script that is easily readable"

  (progn
    (pop-to-buffer (generate-new-buffer "new-r-script"))
    (insert (concat "## Creation date: "  (format-time-string "%Y-%m-%d %H:%M:%S") " \n\n" "## What does it do: \n\n" "## Statistical tests: \n\n" "## Data we need (Only include data you really need, don't put everything all together. \n## You can't combine them before you can correctly divide to get them.): \n\n"  "## Key data table 1: data table right after finish data cleaning \n" "## Key data table summary \n" "## Key data table 2: data table right before statistical test\n" "## Key data table 2 summary \n\n" "## Statistical test 1\n" "## Statistical test result 1\n\n" "## Result plot 1\n\n" "## End of the script\n"))
    )
  (insert (concat "## Creation date: "  (format-time-string "%Y-%m-%d %H:%M:%S") " \n\n"
                  "## What does it do: \n\n"
                  "## Statistical tests: \n\n"
                  "## Data we need (Only include data you really need, don't put everything all together. \n"
                  "## You can't combine them before you can correctly divide to get them.): \n\n"
                  "## Key data table 1: data table right after finish data cleaning \n"
                  "## Key data table summary \n"
                  "## Key data table 2: data table right before statistical test\n"
                  "## Key data table 2 summary \n\n"
                  "## Statistical test 1\n"
                  "## Statistical test result 1\n\n"
                  "## Result plot 1\n\n"
                  "## traditional DEG analysis plots:\n"
                  "a) volcano plot for visualizing significance and fold change \n"
                  "b) boxplot with jitter dots and p value to check samples\n"
                  "c) heatmap to check clustering of samples\n"
                  "## End of the script\n"))
  )

;; create an easy readable ruby script
(defun ghan-new-rb-script ()
  (interactive)
  "create a ruby script that is easily readable"
  (progn
    (pop-to-buffer (generate-new-buffer "new-ruby-script"))
    (insert (concat "## Creation date: " (format-time-string "%Y-%m-%d %H:%M:%S") "\n\n" "## What does it do: \n\n" "## End of the script\n"))
    )
  )
;; grep content in pdf files (useful when writing scientific paper)
;; require pdfgrep tool available from brew
;;(defun ghan-pdfgrep()
;;  (interactive)
;;  "grep content in pdf file using pdfgrep"
;;  (let ((keyword (read-string "keyword to search: ")))
;;    (pop-to-buffer (generate-new-buffer "pdfgrep-result"))
;;    (insert (shell-command-to-string (concat "pdfgrep " "\"" keyword "\" " "~/Dropbox/pdf-paper/*.pdf")))
;;    )
;;  )
;; grep content in pdf files (useful when writing scientific paper)
;; this one grep the text file generated by pdftotext
(defun ghan-helm-do-ag-paper()
  (interactive)
  "grep content in paper file using helm-do-ag"
  (helm-do-ag (expand-file-name "~/Dropbox/pdf-paper"))
  )
(defun ghan_add_to_ag_code()
  (interactive)
  "add current workdir to ag search list(by softlink it to dropbox/codes)"
  let (
       (default-directory project-root-dir)
       (lnkDir nil)
       (command-add-to-dp (concat "ln -s " default-directory " " lnkDir))
       )
  (message command-add-to-dp)
;  (shell-command command-add-to-dp)
  )
(defun ghan-helm-do-ag-codes()
  (interactive)
  "grep content in code files using helm-do-ag"
  (helm-do-ag (expand-file-name "~/Dropbox/codes"))
  )
(defun ghan-counsel-ag-codes()
  (interactive)
  "grep content in code files using helm-do-ag"
  (counsel-ag nil (expand-file-name "~/Dropbox/codes"))
  )
;; (defun ghan-open-file-at-point-in-external-app (arg)
;;   "Open file under cursor in external application."
;;   (interactive "P")
;;   (if arg
;;       (spacemacs//open-in-external-app (expand-file-name default-directory))
;;     (let ((file-path (if (derived-mode-p 'dired-mode)
;;                          (dired-get-file-for-visit)
;;                        buffer-file-name)))
;;       (if file-path
;;           (spacemacs//open-in-external-app file-path)
;;         (message "No file associated to this buffer.")))))

(defun ghan-insert-filename ()
  "Insert file name of current buffer at current point"

  (interactive)
  (insert (buffer-file-name (current-buffer)))
  )
(defun ghan-sp2tab ()
  "replace continuing whitespace to tab"

  (interactive)
  (goto-char (point-min))
  (while (re-search-forward " +" nil t)
    (replace-match "\t" nil t))
  )
;;; pipeline.el ends here
