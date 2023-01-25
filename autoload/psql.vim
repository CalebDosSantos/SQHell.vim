function! psql#GetResultsFromQuery(command)
    let l:user = g:sqh_connections[g:sqh_connection]['user']
    let l:password = g:sqh_connections[g:sqh_connection]['password']
    let l:host = g:sqh_connections[g:sqh_connection]['host']
    " if l:db
    "   let l:db = g:sqh_connections[g:sqh_connection]['database']

    " if l:db
      " let l:connection_details = 'PGPASSWORD='. l:password . ' psql -U' . l:user . ' -h ' . l:host . ' -d ' . l:db . ' --pset footer'
    " else
    let l:connection_details = 'PGPASSWORD='. l:password . ' psql -U' . l:user . ' -h ' . l:host . ' --pset footer'
    " endif
    let l:system_command = 'echo ' . shellescape(join(split(a:command, "\n"))) . ' | ' . l:connection_details
    let l:query_results = system(l:system_command)
    return l:query_results
    " return l:system_command
endfunction


function! psql#ShowDatabases()
    let db_query = 'SELECT datname "Databases" FROM pg_database WHERE datistemplate = false;'
    " return psql#GetResultsFromQuery(db_query)
    call sqhell#InsertResultsToNewBuffer('SQHDatabase', psql#GetResultsFromQuery(db_query), 0)
endfunction

function! psql#SortResults(sort_options)
    let cursor_pos = getpos('.')
    let line_until_cursor = getline('.')[:cursor_pos[2]]
    let sort_column = len(substitute(line_until_cursor, '[^|]', '', 'g')) + 1
    exec '3,$!sort -k ' . sort_column . ' -t \| ' . a:sort_options
    call setpos('.', cursor_pos)
endfunction

function! psql#PostBufferFormat()
    keepjumps normal! ggdd
    keepjumps normal! Gdkgg
endfunction

"Shows all tables for a given database
"Can also be ran by pressing 'e' in
"an SQHDatabase buffer
function! psql#ShowTablesForDatabase(database)
    "The entry point and ONLY place w:database should be set"
    let g:sqh_database = a:database
    let l:query = psql#GetShowTablesQuery(psql#GetDatabase())
    call sqhell#InsertResultsToNewBuffer('SQHTable', psql#GetResultsFromQuery(l:query), 1)
endfunction


"====================== Query functions ==============================
function! psql#GetShowTablesQuery(database)
    " let l:query = 'SHOW TABLES FROM ' . a:database
    let l:query = '\dt'
    return l:query
endfunction


"Returns the last selected database"
function! psql#GetDatabase()
    return sqhell#TrimString(g:sqh_database)
endfunction
