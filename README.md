# SQHell.vim

An SQL wrapper for Vim.
Currently you can:

- View tables
- View databases
- Describe tables
- Execute arbitrary commands
- View records from a table interactively

NOTE:
MySql has the most features, there is basic support for Postgres which is being worked on...

## Examples

(Gifs are using the data from my punk rock band [bogans](http://bogans.uk))
### Execute a command using `SQHExecute!`

(Gif is outdated, new one coming soon)

![](https://i.imgur.com/AUEhN2C.gif)

### Execute a file using `SQHExecuteFile`

![](https://i.imgur.com/67nONqC.gif)

### Execute a line using `SQHExecute`

(Gif is outdated, new one coming soon)

![](https://i.imgur.com/j3m62am.gif)

### Execute a block using `SQHExecute` over a visual selection

(Gif is outdated, new one coming soon)

![](https://i.imgur.com/40uCqVI.gif)

### Explore the database with buffer aware mappings

![](https://i.imgur.com/E12LHnA.gif)

## Installation


### Vim Plug

```
Plug 'joereynolds/SQHell.vim'
```

## Configuration

Connection details will need to be supplied in order for SQHell.vim to connect
to your DBMS of choice. The connections are in a dictionary to let you manage
multiple hosts. By default SQHell uses the 'default' key details (no surprise there)

Example:

```
let g:sqh_connections = {
    \ 'default': {
    \   'user': 'root',
    \   'password': 'testing345',
    \   'host': 'localhost'
    \},
    \ 'live': {
    \   'user': 'root',
    \   'password': 'jerw5Y^$Hdfj',
    \   'host': '46.121.44.392'
    \}
\}
```

You can use the `SQHSwitchConnection` function to change hosts.
i.e. `SQHSwitchConnection live`

I **strongly** suggest that the above configuration details are kept *outside*
of version control and gitignored in your global gitignore.

## Default Keybindings

Press `s` to sort results by the column the cursor is on
Press `S` to sort results by the column the cursor is on (in reverse)

For more sorting options, you can use `:SQHSortResults` with extra arguments for the unix sort command, a la `:SQHSortResults -rn`. It will always sort by the column the cursor is located on.

## Contributing

Please see the [Contributing guidelines](CONTRIBUTING.md) if you would like to make SQHell even better!

## Tests

Tests are housed in the `test` directory and can be ran by
`vim`ing into the test file and then sourcing the file

i.e.

```
vim test/test_results_buffer.vim
:so %
```

If all tests pass, the `v:errors` array will be empty.
And yes, I plan to improve this.

## What about dbext, vim-sql-workbench and others?

DBExt is very featureful (and very good) but comes in at a whopping 12000 lines
of code. By contrast SQHell.vim is a mere ~100 lines

The setup and installation process for vim-sql-workbench is something that I
aim to avoid with SQHell.vim, ideally a 'set and forget' plugin.

There are no clever inferences inside SQHell.vim.
