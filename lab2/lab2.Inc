include WINDOWS.inc

include user32.inc
include kernel32.inc

includelib user32.lib
includelib kernel32.lib

include RADbg.inc

.data
FileName1 db "/home/_lazyelf/Main/Asembler/labs/lab2/files/file1.txt", 0
text1 db "text of first file", 0
FileName2 db "/home/_lazyelf/Main/Asembler/labs/lab2/files/file2.txt", 0
text2 db "text of second file", 0
FileName3 db "/home/_lazyelf/Main/Asembler/labs/lab2/files/file3.txt", 0
text3 db "text of third file", 0
FileName4 db "/home/_lazyelf/Main/Asembler/labs/lab2/files/file4.txt", 0
text4 db "text of fourth file", 0

directory db "/home/_lazyelf/Main/Asembler/labs/lab2/results/", 0
copiedFile db "CopiedFile.txt", 0

.data?
hFile HANDLE ?
