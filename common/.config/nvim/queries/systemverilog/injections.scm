; VPY injection on lines starting with '` '

((ERROR) @injection.content
  (#match? @injection.content "^` ")
  (#set! injection.language "python")
  (#set! injection.include-children)
  (#set! injection.combined true)
  (#offset! @injection.content 0 2 0 0))
