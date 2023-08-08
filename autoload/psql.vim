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


function! psql#DescribeTable(table)
  " echom 'Fazer detalhamento das tabelas'
    let t:table = a:table
    let l:query_estrutura = psql#GetDatailsQuery(psql#GetDatabase(), a:table)
    let l:query_fks = psql#GetForeingKeysQuery(a:table)
    let l:query_selects = ' select col_2 as FKs_e_Colunas, col'

    let l:query = l:query_estrutura . ' UNION ' . l:query_fks
    let l:query .= ' order by col_10 '
    " let l:query = l:query_estrutura
    call sqhell#ExecuteCommand(l:query)
endfunction

function! psql#GetDatailsQuery(database, table)
    " let l:query = 'SELECT table_name, column_name, data_type FROM  information_schema.columns WHERE table_name = '''.a:table.''';'
    let l:selects = 'SELECT '
    let l:selects .= 'table_name as col_1'
    let l:selects .= ', column_name as col_2 '
    let l:selects .= ', data_type as col_4 '
    let l:selects .= ', '' '' as col_3, '' '' as col_5, '' '' as col_6, '' '' as col_7 '
    let l:selects .= ', ''tipo_detalhe'' as col_10 '

    let l:from = ' FROM  information_schema.columns '
    let l:where = ' WHERE table_name = '''.a:table.''''

    let l:query = l:selects . l:from . l:where
    return l:query
endfunction

function! psql#GetForeingKeysQuery(table)
    let l:selects = ' SELECT '
    let l:selects .= 'tc.table_schema as col_1 '
    " let l:selects .= ',tc.constraint_name as col_8 '
    let l:selects .= ',tc.table_name as col_3 '
    let l:selects .= ',kcu.column_name as col_2 '
    let l:selects .= ',ccu.table_schema AS col_5 '
    let l:selects .= ',ccu.table_name AS col_6 ' " FK Table"
    let l:selects .= ',ccu.column_name AS col_7 ' " FK Column"
    let l:selects .= ',concat(''TABELA_id: '' , ccu.table_name, '' --> '', ccu.column_name) as col_4 '
    let l:selects .= ', ''a_tipo_fks'' as col_10 '

    let l:from = ' FROM information_schema.table_constraints AS tc '

    let l:join = ' JOIN information_schema.key_column_usage AS kcu '
    let l:join .= ' ON tc.constraint_name = kcu.constraint_name '
    let l:join .= ' AND tc.table_schema = kcu.table_schema '

    let l:join .= ' JOIN information_schema.constraint_column_usage AS ccu '
    let l:join .= ' ON ccu.constraint_name = tc.constraint_name '
    let l:join .= ' AND ccu.table_schema = tc.table_schema '

    let l:where = ' WHERE tc.constraint_type = ''FOREIGN KEY'' '
    let l:where .= ' AND tc.table_name = '''.a:table.''' '

    let l:query = l:selects . l:from . l:join . l:where

    return l:query
endfunction
