if exists('g:loaded_sqhell')
    finish
endif

let g:loaded_sqhell = 1
let g:sqh_provider = get(g:, 'sqh_provider', 'mysql')
let g:sqh_connection = get(g:, 'sqh_connection', 'default')
let g:sqh_results_limit = get(g:, 'sqh_results_limit', 100)
let g:i_like_to_live_life_dangerously = get(g:, 'i_like_to_live_life_dangerously', 0)

command! -nargs=0 SQHShowDatabases execute ":call " . g:sqh_provider . "#ShowDatabases()"
command! -nargs=1 SQHShowTablesForDatabase execute ":call " . g:sqh_provider . "#ShowTablesForDatabase(<q-args>)"
command! -nargs=? SQHExecuteFile execute ":call " . g:sqh_provider . "#ExecuteFile(<q-args>)"
command! -nargs=1 SQHExecuteCommand execute ":call " . g:sqh_provider . "#ExecuteCommand(<q-args>)"
command! -nargs=0 SQHExecuteLine execute ":call " . g:sqh_provider . "#ExecuteLine()"
command! -range -nargs=0 SQHExecuteBlock execute "<line1>,<line2>:call " . g:sqh_provider . "#ExecuteBlock()"
command! -nargs=1 SQHSwitchConnection :call sqhell#SwitchConnection(<q-args>)
command! -nargs=1 SQHDropDatabase execute ":call " . g:sqh_provider . "#DropDatabase(<q-args>, 0)"
command! -nargs=+ SQHDropTableFromDatabase execute ":call " . g:sqh_provider . "#DropTableFromDatabase(<f-args>, 0)""
