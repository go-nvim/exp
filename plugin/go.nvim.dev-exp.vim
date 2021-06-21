" SPDX-FileCopyrightText: 2021 The Go Nvim Authors
" SPDX-License-Identifier: BSD-3-Clause

if !exists('g:go_nvim_dev_exp')  " TODO(zchee): flip if condition
  finish
endif
let g:go_nvim_dev_exp = 1

" -----------------------------------------------------------------------------
" register remote plugin

let s:plugin_root     = expand('<sfile>:p:h')
let s:plugin_name     = expand('<sfile>:t:r')
" let s:plugin_channel  = 0

" function! s:echo_debug(message) abort
"   if !exists('g:go_nvim_dev_exp_log_level')
"     return
"   endif
" 
"   if g:go_nvim_dev_exp_log_level ==? 'info' || g:nvim_lsp_log_level ==? 'debug'
"     call nvim_echo([[a:message]], v:true, {})
"   endif
" endfunction
" 
" function! s:handle_message(job, lines, event) abort
"   if a:event ==# 'stderr'
"     call writefile(a:lines, '/tmp/nvim-lsp.log')
"   elseif a:event ==# 'exit'
"     if type(a:lines) == type(0) && (a:lines == 0 || a:lines == 143)
"       return
"     endif
"     call s:echo_debug('lsp exited with: ' . string(a:lines))
"   else
"     call s:echo_debug('lsp unknown event: ' . a:event)
"   endif
" endfunction
" 
" function! s:get_channel()
"   if s:plugin_channel != 0
"     return s:plugin_channel
"   endif
" 
"   let l:argv = [s:plugin_root . '/bin/' . s:plugin_name, v:servername]
"   let l:job = {
"       \ 'rpc': v:true,
"       \ 'stderr_buffered': v:false,
"       \ 'on_stderr': function('s:handle_message'),
"       \ }
" 
"   if get(g:, 'go_nvim_dev_exp_debug', v:false)
"     let l:job['env'] = { 'go_nvim_dev_exp_debug': 'true' } 
"   endif
" 
"   if get(g:, 'go_nvim_dev_exp_enable_datadog', v:false)
"     " set datadog environment variables
"     call extend(l:job['env'], {
"         \ 'NVIM_LSP_ENABLE_DATADOG': v:true,
"         \ 'DD_ENV': 'local',
"         \ 'DD_SERVICE': s:plugin_name,
"         \ 'DD_VERSION': 'v0.0.0',
"         \ 'DD_PROFILING_WAIT_PROFILE': '1',
"         \ 'DD_PROPAGATION_STYLE_INJECT': 'B3,Datadog',
"         \ 'DD_PROPAGATION_STYLE_EXTRACT': 'B3,Datadog'
"         \ })
"   endif
" 
"   let s:plugin_channel = jobstart(l:argv, l:job)
"   return s:plugin_channel
" endfunction
" 
" function! s:provider_poll(orig_name, log_env) abort
"   if s:plugin_channel != 0
"     return s:plugin_channel
"   endif
" 
"   try
"     let s:plugin_channel = s:get_channel()
"     if s:plugin_channel > 0
"       return s:plugin_channel
"     endif
"   catch
"     echomsg v:throwpoint
"     echomsg v:exception
"     for row in get(l:job, 'stderr', [])
"       echomsg row
"     endfor
"   endtry
" 
"   throw remote#host#LoadErrorForHost(a:orig_name, a:log_env)
" endfunction
" 
" function! s:provider_go_nvim_dev_exp_require(host) abort
"   return s:provider_poll(a:host.orig_name, '$NVIM_LSP_LOG_FILE')
" endfunction

" -----------------------------------------------------------------------------
" manifest

call remote#host#RegisterPlugin('go.nvim.dev-exp', '0', [])
call remote#host#Register(s:plugin_name, '*', function('s:provider_go_nvim_dev_exp_require'))
