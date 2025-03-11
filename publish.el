;; Explicitly load packages for Doom Emacs
(add-to-list 'load-path "~/.config/emacs/.local/straight/repos/emacs-htmlize")
(add-to-list 'load-path "~/.config/emacs/.local/straight/repos/weblorg")
(add-to-list 'load-path "~/.config/emacs/.local/straight/repos/templatel")

(require 'htmlize)
(require 'weblorg)

;; Set default URL for Weblorg
(if (string= (getenv "ENV") "prod")
    (setq weblorg-default-url "https://cmc.pub"))

;; Define site configuration
(weblorg-site
 :theme nil
  :template-vars `(("site_name" . "cmc.pub")
                  ("site_owner" . "Christian Cleberg <hello@cmc.pub>")
                  ("site_description" . "Just a blip of ones and zeroes.")))

;; Define routes for rendering content

;; Index page route
(weblorg-route
 :name "index"
 :input-pattern "content/index.org"
 :template "index.html"
 :output ".build/index.html"
 :url "/")

;; Blog post route
(weblorg-route
 :name "blog"
 :input-pattern "content/blog/*.org"
 :template "post.html"
 :output ".build/blog/{{ slug }}.html"
 :url "/blog/{{ slug }}.html")

;; Blog index page route
(weblorg-route
 :name "blog-index"
 :input-pattern "content/blog/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "blog.html"
 :output ".build/blog/index.html"
 :url "/blog/")

;; Wiki post route
(weblorg-route
 :name "wiki"
 :input-pattern "content/wiki/*.org"
 :template "post.html"
 :output ".build/wiki/{{ slug }}.html"
 :url "/wiki/{{ slug }}.html")

;; Wiki index page route
(weblorg-route
 :name "wiki-index"
 :input-pattern "content/wiki/*.org"
 :input-aggregate #'weblorg-input-aggregate-all
 :template "wiki.html"
 :output ".build/wiki/index.html"
 :url "/wiki/")

;; Page post route
(weblorg-route
 :name "pages"
 :input-pattern "content/*.org"
 :template "page.html"
 :output ".build/{{ slug }}.html"
 :url "/{{ slug }}.html")

;; Salary page route
(weblorg-route
 :name "salary"
 :input-pattern "content/salary/*.org"
 :template "page.html"
 :output ".build/salary/{{ slug }}.html"
 :url "/salary/{{ slug }}.html")

;; Services page route
(weblorg-route
 :name "services"
 :input-pattern "content/services/*.org"
 :template "page.html"
 :output ".build/services/{{ slug }}.html"
 :url "/services/{{ slug }}.html")

;; RSS feed route
(weblorg-route
 :name "rss"
 :input-pattern "content/blog/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "feed.xml"
 :output ".build/feed.xml"
 :url "/feed.xml")

;; Copy static assets and output to .build directory
(weblorg-copy-static
 :output ".build/{{ file }}"
 :url "/{{ file }}")

;; Export all content using Weblorg engine
(weblorg-export)
