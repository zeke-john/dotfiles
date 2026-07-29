if exists('b:current_syntax')
    finish
endif

syn case match

" Comments
syn keyword bamlTodo TODO FIXME NOTE XXX contained
syn match bamlComment "//.*$" contains=bamlTodo
syn region bamlBlockComment start="/\*" end="\*/" contains=bamlTodo

" Keywords
syn keyword bamlKeyword class enum function generator client test retry_policy template_string
syn keyword bamlKeyword override impl map

" Block-level properties
syn keyword bamlProperty provider model options retry_policy prompt
syn keyword bamlProperty output_type output_dir version default_client_mode module_format
syn keyword bamlProperty strategy max_retries delay_ms multiplier max_delay_ms

" Built-in types
syn keyword bamlType string int float bool null image audio
syn match bamlType "\<string\[\]"
syn match bamlType "\<int\[\]"
syn match bamlType "\<float\[\]"
syn match bamlType "\<bool\[\]"

" Type parameters (client<llm>, etc.)
syn match bamlTypeParam "<[a-zA-Z_]\+>" contained
syn match bamlClientDecl "client<[a-zA-Z_]\+>" contains=bamlTypeParam

" Decorators / annotations
syn match bamlDecorator "@[a-zA-Z_]\+\>"
syn region bamlDecoratorArgs start="@[a-zA-Z_]\+(" end=")" contains=bamlDecorator,bamlString,bamlNumber,bamlBoolean transparent

" Arrows in function signatures
syn match bamlArrow "->"
syn match bamlArrow "→"

" Strings
syn region bamlString start=/"/ skip=/\\"/ end=/"/ contains=bamlEscape
syn match bamlEscape "\\." contained

" Raw string prompts #"..."#
syn region bamlRawString start='#"' end='"#' contains=bamlTemplateVar

" Template variables {{ ... }}
syn region bamlTemplateVar start="{{" end="}}" contained containedin=bamlRawString

" Numbers
syn match bamlNumber "\<\d\+\>"
syn match bamlNumber "\<\d\+\.\d\+\>"

" Booleans
syn keyword bamlBoolean true false

" Optional marker
syn match bamlOptional "?"

" Identifiers after class/enum/function keywords
syn match bamlTypeName "\<\(class\|enum\)\s\+\zs[A-Za-z_][A-Za-z0-9_]*"
syn match bamlFuncName "\<function\s\+\zs[A-Za-z_][A-Za-z0-9_]*"

" Highlight links
hi def link bamlComment Comment
hi def link bamlBlockComment Comment
hi def link bamlTodo Todo
hi def link bamlKeyword Keyword
hi def link bamlProperty Identifier
hi def link bamlType Type
hi def link bamlTypeParam Type
hi def link bamlClientDecl Keyword
hi def link bamlDecorator PreProc
hi def link bamlString String
hi def link bamlRawString String
hi def link bamlEscape SpecialChar
hi def link bamlTemplateVar Special
hi def link bamlNumber Number
hi def link bamlBoolean Boolean
hi def link bamlArrow Operator
hi def link bamlOptional Operator
hi def link bamlTypeName Type
hi def link bamlFuncName Function

let b:current_syntax = 'baml'
