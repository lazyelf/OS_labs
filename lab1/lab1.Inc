    include windows.inc
    include user32.inc
    include kernel32.inc
    includelib kernel32.lib
    includelib user32.lib

.data
  buf_len			dd 256
  name_title		db 'Computer Name: ' , 0
  user_name		db 256 dup (0)
  directory_title		db 'Curent directory: ', 0
  directory 		db 256 dup(0)
  enter_			db 13, 0
  title_			db ' ', 0
  format_			db '%hs%hs%hs%hs%hs', 0
  
  span	db 512 dup(0)
  result	db 512 dup(0)
 
