" let g:vrc_include_response_header = 1
let s:vrc_auto_format_response_patterns = {
            \   'json': "jq -R -r '. as $line | try fromjson catch $line'"
            \}

let g:vrc_response_default_content_type = 'application/json'
let g:vrc_show_command = 1

let g:vrc_debug = 0
let g:vrc_curl_opts = {
            \ '-s': '',
            \ '-D -': '',
            \}
