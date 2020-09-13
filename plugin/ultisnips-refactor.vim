" ultisnips-refactor.vim - A plugin which adds easy refactoring and nice documentation to snippet files
" Version: 0.1
" Maintainer: Brandon Conway <https://brandoncc.dev>


if exists("g:loaded_ultisnips_refactor")
  finish
endif
let g:loaded_ultisnips_refactor = 1
let s:plugin_directory = expand("<sfile>:p:h:h")

vnoremap <Plug>ultisnips-refactor :<C-U>call <SID>RefactorSelectionToSnippet()<CR>

augroup ultisnips_refactor
  autocmd!

  autocmd BufNewFile *.snippets call <SID>SetNewBufferContent()
augroup END

" Section: Utilities

function! s:LeadingWhiteSpaceCharacterCount(input, default_if_blank) abort
  let stripped = substitute(a:input, "^\\\s*", "", "")

  if (strlen(stripped) == 0)
    return a:default_if_blank
  else
    return strlen(a:input) - strlen(stripped)
  endif
endfunction

function! s:LeftStripNCharacters(input, count) abort
  return substitute(a:input, "^\\\s\\\{" . a:count . "}", "", "")
endfunction

function! s:SkeletonPath() abort
  return s:plugin_directory . "/templates/documentation.txt"
endfunction

function! s:SkeletonContents() abort
  return readfile(s:SkeletonPath())
endfunction

function! s:SetNewBufferContent() abort
  if !exists("g:ultisnips_refactor_no_documentation")
    call nvim_buf_set_lines(0, 0, 0, 0, s:SkeletonContents())
  end
endfunction

function! s:RefactorSelectionToSnippet() abort
  let lines = s:GetVisualSelection()

  let left_padding = 10000

  for line in lines
     let line_left_padding = s:LeadingWhiteSpaceCharacterCount(line, left_padding)

    if line_left_padding < left_padding
      let left_padding = line_left_padding
    endif
  endfor

  let stripped_lines = map(lines, {_, val -> s:LeftStripNCharacters(val, left_padding)})

  let closing_lines = ["endsnippet"]

  silent exe "UltiSnipsEdit " . split(&filetype, '\.')[0]

  let line_count = line('$')
  let last_line_is_blank = strlen(getline(line_count)) == 0

  if (last_line_is_blank)
    let line_count = line_count - 1
  endif

  let failed = append(line_count, [""] + stripped_lines + closing_lines)

  call setpos('.', [0, line_count + 2, 0, 0])
  silent exe "normal! O"
  silent exe "startinsert!"
  call feedkeys('snippet', 'n')
endfunction

" ref: https://stackoverflow.com/a/61486601
function! s:GetVisualSelection() abort
  let mode = visualmode()
  " call with visualmode() as the argument
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end]     = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if mode ==# 'v'
    " Must trim the end before the start, the beginning will shift left.
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
  elseif  mode ==# 'V'
    " Line mode no need to trim start or end
  elseif  mode == "\<c-v>"
    " Block mode, trim every line
    let new_lines = []
    let i = 0
    for line in lines
      let lines[i] = line[column_start - 1: column_end - (&selection == 'inclusive' ? 1 : 2)]
      let i = i + 1
    endfor
  else
    return ''
  endif

  return lines
endfunction
