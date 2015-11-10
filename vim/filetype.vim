if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
    au! BufNewFile,BufRead *.uxt setf nodoguxt
    au! BufNewFile,BufRead *.ino setf cpp
    au! BufNewFile,BufRead *.md  setf markdown
    au! BufNewFile,BufRead *.pde setf java
augroup END
