function! psql#GetResultsFromQuery(command)
    let l:user = g:sqh_connections[g:sqh_connection]['user']
    let l:password = g:sqh_connections[g:sqh_connection]['password']
    let l:host = g:sqh_connections[g:sqh_connection]['host']
    let l:database = g:sqh_connections[g:sqh_connection]['database']

    if l:database !=? ''
        let l:database = '-d' . l:database . ' '
    endif

    let l:connection_details = 'PGPASSWORD='. l:password . ' psql -U' . l:user . ' -h ' . l:host . ' '. l:database. ' --pset footer'
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

function! psql#FunctionsAndProcedures(command)
  " let l:command = 'SELECT n.nspname, p.proname, p.prokind FROM pg_catalog.pg_namespace n JOIN pg_catalog.pg_proc p ON p.pronamespace = n.oid WHERE p.prokind in('p','f') AND n.nspname in ('public', 'codhab');'

    let l:user = g:sqh_connections[g:sqh_connection]['user']
    let l:password = g:sqh_connections[g:sqh_connection]['password']
    let l:host = g:sqh_connections[g:sqh_connection]['host']
    let l:database = g:sqh_connections[g:sqh_connection]['database']

    if l:database !=? ''
        let l:database = '-d' . l:database . ' '
    endif

    let l:connection_details = 'PGPASSWORD='. l:password . ' psql -U' . l:user . ' -h ' . l:host . ' '. l:database. ' --pset footer'
    " endif
    let l:system_command = 'echo ' . shellescape(join(split(a:command, "\n"))) . ' | ' . l:connection_details
    let l:query_results = system(l:system_command)
    return l:query_results
    " return l:system_command
endfunction

function! psql#GetFnSpQuery(database, table)
    let l:select = 'routine_name'
    let l:dt_from = 'information_schema'
    let l:dt_table = 'routines'
    let l:schema = 'public'
    let l:where = 'routine_type IN ("FUNCTION","PROCEDURE")'
    let l:where_and = 'routine_schema = '
    let l:schema = 'public'
    let l:query = 'SELECT '.l:select.' FROM ' . l:dt_from . '.' . l:dt_table . ' WHERE ' . l:where . ' ' . l:where_and . ' '. l:schema
    return l:query
endfunction

function! psql#ShowRecordsInTable(table)
    let t:table = a:table
    let l:query = psql#GetSelectQuery(psql#GetDatabase(), a:table)
    call sqhell#ExecuteCommand(l:query)
endfunction

function! psql#GetSelectQuery(database, table)
    let l:query = 'SELECT * FROM ' . a:table . ' LIMIT ' . g:sqh_results_limit
    return l:query
endfunction


function! psql#ShowTableDetails(table)
  echom 'Fazer detalhamento das tabelas'
    let t:table = a:table
    let l:query = psql#GetDatailsQuery(psql#GetDatabase(), a:table)
    call sqhell#ExecuteCommand(l:query)
endfunction

function! psql#GetDatailsQuery(database, table)
    let l:query = 'SELECT table_name, column_name, data_type FROM  information_schema.columns WHERE table_name = '''.a:table.''';'

    return l:query
endfunction
