;; Publish org files to HTML

;; Functions
(defun org-rss-publish-to-rss (plist filename pub-dir)
  "Publish RSS with PLIST, only when FILENAME is 'rss.org'.
PUB-DIR is when the output will be placed."
  (if (equal "rss.org" (file-name-nondirectory filename))
      (org-rss-export-to-rss plist filename pub-dir)))

;; Project publishing settings
(setq org-publish-project-alist
      '(("cleberg.net"
	:base-directory "~/Source/cleberg.net/"
	:publishing-function org-html-publish-to-html
	:publishing-directory "~/Source/cleberg.net/public/"
	:auto-sitemap t
	:recursive t
	:section-numbers nil
	:with-author nil
	:html-validation-link nil
	:with-tags t
	:html-htmlize-output-type 'inline-css
        :html-head-include-default-style nil
        :html-head-include-scripts nil
	:html-head "<link rel=stylesheet href=/static/styles.min.css>"
	:html-preamble "<nav><a href=/>Home</a><a href=/blog/>Blog</a><a href=/services/>Services</a><a href=/wiki/>Wiki</a></nav>")

	("rss"
	 :base-directory "~/Source/cleberg.net/blog/"
	 :base-extension "org"
	 :html-link-home "https://cleberg.net/"
	 :html-link-use-abs-url t
	 :rss-extension "xml"
	 :publishing-directory "~/Source/cleberg.net/public/blog/"
	 :publishing-function org-rss-publish-to-rss
	 :section-numbers nil
	 :exclude "index.org"
	 :author "cmc"
	 :email ""
	 ;; test
	 :html-link-org-files-as-html t
	 :auto-sitemap t
         :sitemap-filename "rss.org"
         :sitemap-title "cleberg.net"
         :sitemap-style list
         :sitemap-sort-files anti-chronologically
         ;;:sitemap-function 'rw/format-rss-feed
         ;;:sitemap-format-entry 'rw/format-rss-feed-entry
	 ;; end test
	 )

	("static"
	:base-directory "~/Source/cleberg.net/static/"
	:base-extension "css\\|txt"
	:publishing-directory "~/Source/cleberg.net/public/static/"
        :publishing-function org-publish-attachment)
	("website" :components ("cleberg.net" "rss" "static"))))

(provide 'publish)
