;; explicity load packages since I'm using Doom Emacs
(add-to-list 'load-path "~/.emacs.d/.local/straight/repos/emacs-htmlize")
(add-to-list 'load-path "~/.emacs.d/.local/straight/repos/weblorg")
(add-to-list 'load-path "~/.emacs.d/.local/straight/repos/templatel")
(require 'htmlize)
(require 'weblorg)

;; defaults to http://localhost:8000
;; ENV=prod emacs --script publish.el
(if (string= (getenv "ENV") "prod")
    (setq weblorg-default-url "https://cleberg.net"))

(weblorg-site
 :theme nil
 :template-vars '(("site_name" . "cleberg.net")
                  ("site_owner" . "Christian Cleberg <hello@cleberg.net>")
                  ("site_description" . "Just a blip of ones and zeroes.")))

;; route for rendering the index page of the website
(weblorg-route
 :name "index"
 :input-pattern "content/index.org"
 :template "index.html"
 :output ".build/index.html"
 :url "/")

;; route for rendering each post
(weblorg-route
 :name "blog"
 :input-pattern "content/blog/*.org"
 :template "post.html"
 :output ".build/blog/{{ slug }}.html"
 :url "/blog/{{ slug }}.html")

;; route for rendering the index page of the blog
(weblorg-route
 :name "blog-index"
 :input-pattern "content/blog/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "blog.html"
 :output ".build/blog/index.html"
 :url "/blog/")

;; route for rendering each wiki post
(weblorg-route
 :name "wiki"
 :input-pattern "content/wiki/*.org"
 :template "post.html"
 :output ".build/wiki/{{ slug }}.html"
 :url "/wiki/{{ slug }}.html")

;; route for rendering the index page of the wiki
(weblorg-route
 :name "wiki-index"
 :input-pattern "content/wiki/*.org"
 :input-aggregate #'weblorg-input-aggregate-all
 :template "wiki.html"
 :output ".build/wiki/index.html"
 :url "/wiki/")

;; route for rendering each page
(weblorg-route
 :name "pages"
 :input-pattern "content/*.org"
 :template "page.html"
 :output ".build/{{ slug }}.html"
 :url "/{{ slug }}.html")

(weblorg-route
 :name "salary"
 :input-pattern "content/salary/*.org"
 :template "page.html"
 :output ".build/salary/{{ slug }}.html"
 :url "/salary/{{ slug }}.html")

(weblorg-route
 :name "services"
 :input-pattern "content/services/*.org"
 :template "page.html"
 :output ".build/services/{{ slug }}.html"
 :url "/services/{{ slug }}.html")

;; RSS Feed
(weblorg-route
 :name "rss"
 :input-pattern "content/blog/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "feed.xml"
 :output ".build/feed.xml"
 :url "/feed.xml")

;; route for static assets that also copies files to .build directory
(weblorg-copy-static
 :output ".build/{{ file }}"
 :url "/{{ file }}")

;; fire the engine and export all the files declared in the routes above
(weblorg-export)
