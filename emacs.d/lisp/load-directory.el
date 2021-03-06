;;
;; load-directory.el
;; http://www.emacswiki.org/emacs-en/DotEmacsModular#LoadDirectory
;;
;; Recursively loads a directory. I use this for my modes directory. Note
;; that this is not safe if execution order matters.
;;
(defun recursive-subdirs (directory &optional withroot)
    "Return a unsorted list of names of directories in DIRECTORY recursively.
If WITHROOT is non-nil, also DIRECTORY will be include."
    (let (subdirs)
      (dolist (element (directory-files-and-attributes directory nil nil nil))
	(let* ((path (car element))
	       (isdir (car (cdr element)))
	       (ignore (or (string= path ".") (string= path ".."))))
	  (if (and (eq isdir t) (not ignore))
	      (let ((dir (concat directory "/" path)))
		(setq subdirs (append (cons dir subdirs)
				      (recursive-subdirs dir)))))))
      (if (not (eq withroot nil))
	  (add-to-list 'subdirs directory))
      subdirs))

(defun load-directory (directory)
  "Load recursively all `.el' files in DIRECTORY."
  (dolist (dir (recursive-subdirs directory t))
    (dolist (file (directory-files dir t "\.el$" nil))
            (load (file-name-sans-extension file)))))
