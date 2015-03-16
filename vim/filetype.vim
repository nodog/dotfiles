if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
    au! BufNewFile,BufRead *.uxt setf nodoguxt
    au! BufNewFile,BufRead *.ino setf cpp
augroup END
