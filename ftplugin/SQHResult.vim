setlocal nostartofline

nnoremap <buffer> dd :call mysql#DeleteRow()<cr>
nnoremap <buffer> <silent> s :SQHSortResults -f<CR>
nnoremap <buffer> <silent> S :SQHSortResults -fr<CR>
nnoremap <buffer> <silent> e :call mysql#EditRow()<cr>

"Back to SQTables buffer
nnoremap <buffer> <silent> b :execute "call " . g:sqh_provider . "#ShowTablesForDatabase('" . g:sqh_database . "')"<cr>
