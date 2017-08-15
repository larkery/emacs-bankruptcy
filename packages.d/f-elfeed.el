(initsplit-this-file bos "elfeed-")

(req-package elfeed
  :commands elfeed
  :bind ("C-c f" . elfeed)
  :config
  (setq elfeed-feeds
        '(("http://www.antipope.org/charlie/blog-static/atom.xml" sf)
          ("http://www.rifters.com/crawl/?feed=rss2" sf)
          ("http://physics.ucsd.edu/do-the-math/feed/" climate econ sci)
          ("http://www.tyndall.ac.uk/rss.xml" climate)
          ("http://feeds.arstechnica.com/arstechnica/features" ars tech)
          ("http://www.daemonology.net/blog/index.rss" tech)
          ("http://feeds2.feedburner.com/typepad/krisdedecker/lowtechmagazineenglish" climate eco)
          ("http://feeds2.feedburner.com/NoTechMagazine" climate eco)
          ("http://cowlark.com/feed.rss" tech blog)
          ("http://cassettepunk.com/feed/" tech blog)
          ("http://idlewords.com/index.xml" tech)
          ("http://bristolcars.blogspot.com/feeds/posts/default" bristol bike blog)
          ("http://bristolcycling.org.uk/feed/" bristol bike)
          ("https://aseasyasridingabike.wordpress.com/feed/" bike blog)
          ("http://weputachipinit.tumblr.com/rss" iot stupid)
          ("https://mathbabe.org/feed" math data)
          ("http://www.formerdays.com/feeds/posts/default" pictures)
          ("http://planet.nixos.org/atom.xml" nixos)
          ;; ("http://www.world-nuclear-news.org/rss.aspx?fid=790" nuke)

          ;; ("https://www.iaea.org/feeds/topnews" nuke)

          ("http://www.newyorker.com/feed/articles" news)
          ("http://feeds.kottke.org/main" kottke)
          ("https://www.schneier.com/blog/atom.xml" crypto)
          ("https://www.getrevue.co/profile/azeem.rss" tech)
          ("http://tedium.co/rss" tech)

          ("https://nathaliesternmusic.bandcamp.com/feed" music)

          ("http://www.bentrideronline.com/?feed=rss2")
          )


        elfeed-use-curl t
        )
  )
