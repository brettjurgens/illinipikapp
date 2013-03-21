illinipikapp
============

Website for Pi Kappa Phi Upsilon Chapter (Illinois)

Some things
-----------
    head.haml
      > Doctype, HEAD, header, flag image

    foot.haml
      > footer... copyright & social networking
      
    page.haml
      > Sets up the page content (i.e. heading, <section>)
      > grabs the relevant content from pagename.haml

    other haml files
      > info to be displayed on pages
      > routing is /pages/pagename, which will grab info from pagename.haml
      > only files that need to be edited to add content