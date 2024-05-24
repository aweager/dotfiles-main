let g:awe_config = fnamemodify(resolve(expand('<sfile>:p')), ':h')

for f in split(glob(g:awe_config . '/global/vim/*.vim'), '\n')
    execute 'source' f
endfor

for f in split(glob(g:awe_config . '/machine/vim/*.vim'), '\n')
    execute 'source' f
endfor
