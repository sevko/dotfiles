UltiSnipsAddFiletypes htmldjango.html

setlocal iskeyword+=@

syn region djangoTagBlock start="\(^[\t ]*\)=" end="$"
	\ contains=djangoStatement,djangoFilter,djangoArgument,djangoTagError
	\ display containedin=ALLBUT,@djangoBlocks

inorem <buffer> % %<Space><space>%<left><Left>
inorem <buffer> { {{  }}<left><left><left>
inorem <buffer> = <c-r>=(getline(".")[:col(".") - 2] =~ "^[ \t]*$")?"= ":"="<cr>
inorem <buffer> \| <space>\| 
