ultisnips-refactor.vim
---

Ultisnips is great, but lacks a nice way to create a snippet from existing content. I was using [coc-snippets](https://github.com/neoclide/coc-snippets) for a while, which added this functionality.

I had to stop using coc-snippets because of its lack of python support in snippets, and I missed the refactor functionality. I built as close to the same functionality as I could, and created this plugin from it.

### Usage
---

Add to your vim plugin manager:

```vim
Plug 'brandoncc/ultisnips-refactor.vim
```

Add a mapping to `<Plug>ultisnips-refactor`. I like the mnemonic "sc" for "snippet create":

```vim
nnoremap <Leader>sc <Plug>ultisnips-refactor
```

### Options
---

By default, snippet [documentation](templates/documentation) is added to the
top of any new `*.snippets` file. If you would like to disable this feature,
use `g:ultisnips_refactor_no_documentation`:

```vim
let g:ultisnips_refactor_no_documentation = 1
```

### Credits
---

The amazing documentation that is added to the top of new snippet files came from the coc-snippets plugin. Thank you @neoclide!

### Contributing
---

Feel free to open an issue if you have any feedback on the plugin. If you would like to contribute code, please create a pull request.

### License
---

MIT
