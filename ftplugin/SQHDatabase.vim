"Select * from the selected table
noremap <buffer> o :call sqhell#ShowTablesForDatabase(expand('<cword>'))<cr>
noremap <buffer> dd :call mysql#DropDatabase(expand('<cword>'), 1)<cr>
