" Trigger configuration. <Tab> 을 쓴다면 ycm 과 키가 중복되어 제대로 기능하지 않을 수 있다. 둘 중 하나의 설정을 바꿔준다.
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Right>"
let g:UltiSnipsJumpBackwardTrigger="<Left>"
let g:UltiSnipsEditSplit="vertical"     " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips']
let g:UltiSnipsSnippetDirectories = ['UltiSnips']

call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
    \ 'name': 'ultisnips',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
    \ }))
