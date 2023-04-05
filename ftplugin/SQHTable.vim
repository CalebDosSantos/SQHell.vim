"Select * from the selected table
noremap <buffer> o :call sqhell#ShowRecordsInTable(expand('<cword>'))<cr>
noremap <buffer> K :call sqhell#DescribeTable(expand('<cword>'))<cr>
noremap <buffer> dd :call mysql#DropTableSQHTableBuf(expand('<cword>'), 1)<cr>

"Back to the SQHDatabase
noremap <buffer> q :execute "call " . g:sqh_provider . "#ShowDatabases()"<cr>
" TODO
noremap <buffer> d :execute "call " . g:sqh_provider . "#ShowTableDetails(expand('<cword>'))"<cr>
