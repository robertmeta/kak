## Sources.
source "%val{config}/plugins/kakoune-buffers/buffers.kak"
source "%val{config}/plugins/kakoune-find/find.kak"
source "%val{config}/plugins/kakoune-phantom-selection/phantom-selection.kak"
#source "%val{config}/plugins/search-highlighting.kak/rc/search-highlighting.kak"
#source "%val{config}/plugins/volatile-highlighting.kak/rc/volatile-highlighting.kak"

source "%val{config}/scripts/select-block.kak"
source "%val{config}/scripts/colorscheme-browser.kak"
source "%val{config}/scripts/snippet.kak"
#source "%val{config}/scripts/tabs.kak"
source "%val{config}/scripts/char-input.kak"

## General settings.
set global ui_options ncurses_assistant=off
set global startup_info_version 20180413
set global termcmd 'gnome-terminal -e'

set global indentwidth 2
set global tabstop 8

# None of these colorschemes do what I want: Dark background, bright colors,
# lots of contrast, easy to distinguish faces, easy to read comments... It
# doesn't seem so unreasonable.
colorscheme desertex; face global comment rgb:7ccd7c

hook global WinCreate .* %{
  addhl window wrap
  addhl window number_lines -relative -hlcursor
  addhl window show_whitespaces -tab '‣' -tabpad '―' -lf ' ' -spc ' ' -nbsp '⍽'
  face window Whitespace cyan
  addhl-named window/VisibleWords regex \b(?:TODO|FIXME|XXX)\b 0:default+rb

  smarttab-enable
  tab-completion-enable
  show-trailing-whitespace-enable; face window TrailingWhitespace default,magenta
  search-highlighting-enable; face window Search +bi
  volatile-highlighting-enable; face window Volatile +bi
  #tex-completion-enable

  addhl-named window/SnippetHole \
    regex (¹)|(²)|(³)|(⁴)|(⁵)|(⁶)|(⁷) \
    1:default,red \
    2:default,rgb:FF8000 \
    3:default,yellow \
    4:default,green \
    5:default,blue \
    6:default,rgb:6F00FF \
    7:default,rgb:9F00FF
}

## Maps.
map global normal <%> '<c-s>%' # Save position before %

map global normal    <'> ': select-word-better<ret>*'
map global normal  <a-'> ': select-WORD-better<ret>*'

map global normal <x> <a-x>

map global normal      <=> ': phantom-sel-add-selection<ret>'
map global normal    <a-=> ': phantom-sel-select-all; phantom-sel-clear<ret>'
map global normal <a-plus> ': phantom-sel-clear<ret>'
map global normal    <a-9> ': phantom-sel-iterate-prev<ret>'
map global normal    <a-0> ': phantom-sel-iterate-next<ret>'

# Can't emulate ^E/^Y perfectly. This is close, but maybe I should just use V.
#map global normal <c-e> 'vj'; map global normal <c-y> 'vk'
map global normal <c-e> 'jvj'; map global normal <c-y> 'kvk'

map global normal <minus> 'ga' # I can probably find a better use for <minus>.

map global normal <f1> ':new '
map global normal <f2> ': new exec :<ret>'

map global normal   <f12> ': select-word-better<ret>'
map global normal <s-f12> ': select-WORD-better<ret>'

map global normal <a-]> ': select-word-better; ctags-search<ret>'

map global normal   <#> ': comment-line-better<ret>'
map global normal <a-#> ': comment-block<ret>'

map global normal <c-v> ': select-block<ret>'

map global normal <c-p>   ': lint<ret>'

map global normal <c-n>   ': next<ret>'
map global normal <c-a-n> ': prev<ret>'

map global insert <a-[> '<esc>: try replace-next-hole catch snippet-word<ret>'

map global insert <c-k>   '<a-;>: char-input-begin "%val{config}/scripts/char-input-digraph.txt"<ret>'
map global insert <a-k>   '<a-;>: char-input-begin "%val{config}/scripts/char-input-tex.txt"<ret>'
map global insert <a-K>   '<a-;>: char-input-begin "%val{config}/scripts/char-input-unicode.txt"<ret>'
map global insert <c-a-k> '<a-;>: char-input-begin "%val{config}/local/char-input-extra.txt"<ret>'
map global insert        '\<a-;>: char-input-begin "%val{config}/scripts/char-input-tex.txt" h<ret>' # <c-\>

map global insert <c-w> '<a-;>: exec -draft b<lt>a-d<gt><ret>'

# Available normal keys:
# D + ^ <ret> <del> <ins> <f4>-<f11> 0 <backspace> (with :zero/:backspace)
# <a-[1-8,\\]> <a-ret>
# <c-[acgkmqrtwx]> <c-space> (\0) <c-]> () <c-/> () <c-\> ()

# User map.
map global user m       -docstring 'make'                   ': make<ret>'
map global user a       -docstring 'select all occurrences' ': select-all-occurrences<ret>'
map global user =       -docstring 'format text'            ': format-text<ret>'
map global user w       -docstring 'write'                  ': w<ret>'
map global user q       -docstring 'quit'                   ': q<ret>'
map global user n       -docstring 'next lint error'        ': lint-next-error<ret>'
map global user <a-n>   -docstring 'prev lint error'        ': lint-previous-error<ret>'
map global user e       -docstring 'eval selection'         ': eval %val{selection}<ret>'
map global user c       -docstring 'char info'              ': show-char-info<ret>'
map global user h       -docstring 'selection hull'         ': hull<ret>'
map global user K       -docstring 'man'                    ': man<ret>'
map global user g       -docstring 'git'                    ': enter-user-mode git<ret>'
map global user b       -docstring 'buffers…'               ': enter-buffers-mode<ret>'
map global user B       -docstring 'buffers (lock)…'        ': enter-user-mode -lock buffers<ret>'
map global user P       -docstring 'paste primary before'   ': exec        "!xsel -op<lt>ret>"<ret>'
map global user p       -docstring 'paste primary after'    ': exec "<lt>a-!>xsel -op<lt>ret>"<ret>'
map global user O       -docstring 'paste clipboard before' ': exec        "!xsel -ob<lt>ret>"<ret>'
map global user o       -docstring 'paste clipboard after'  ': exec "<lt>a-!>xsel -ob<lt>ret>"<ret>'
map global user y       -docstring 'yank primary'           ': exec "<lt>a-|>xsel -ip<lt>ret>"<ret>'
map global user Y       -docstring 'yank clipboard'         ': exec "<lt>a-|>xsel -ib<lt>ret>"<ret>'
map global user <minus> -docstring '.c <-> .h'              ': c-family-alternative-file<ret>'
map global user <plus>  -docstring 'switch to [+] buffer'   ': switch-to-modified-buffer<ret>'
map global user s       -docstring 'set option'             ': enter-user-mode set<ret>'

## Configure plugins.
# snippet.kak
set global snippet_program "%val{config}/scripts/snippet"
set global snippet_file "%val{config}/local/snippets.yaml"
set global snippet_hole_pattern %{%%%\{\w+\}%%%|[⁰¹²³⁴⁵⁶⁷💙💚💛💜💝💟🧡]}
## char-input-mode.kak
set global char_input_auto_data "%val{config}/scripts/char-input-tex.txt"

## Hooks.
# I've moved most of this section elsewhere -- it's probably superfluous now.
hook global BufOpenFifo '\*make\*' %{ alias global next make-next-error; alias global prev make-previous-error }
hook global BufOpenFifo '\*grep\*' %{ alias global next grep-next-match; alias global prev grep-previous-match }
hook global BufCreate   '\*find\*' %{ alias global next find-next-match; alias global prev find-previous-match }
hook global BufSetOption 'spell_tmp_file=.+' %{ alias global next spell-next; unalias global prev }

## File types.
def filetype-hook -params 2 %{ hook global WinSetOption "filetype=(%arg{1})" %arg{2} }

filetype-hook man %{ rmhl window/number_lines }
filetype-hook makefile|go %{
  try smarttab-disable
  set window indentwidth 0
}
filetype-hook c|cpp %{
  clang-enable-autocomplete; clang-enable-diagnostics
  alias window lint clang-parse
  alias window lint-next-error clang-diagnostics-next
}

## Defs.
def Main  %{     rename-client Main;  set global jumpclient  Main  }
def Tools %{ new rename-client Tools; set global toolsclient Tools }
def Docs  %{ new rename-client Docs;  set global docsclient  Docs  }
def IDE   %{ Main; Tools; Docs }

# Bind things that do't take numeric arguments to the keys 0/<backspace>.
# Usage: map global normal 0 ': zero "exec gh"<ret>'
#        map global normal <backspace> ': backspace "exec h"<ret>'
def zero      -params 1 %{ eval %sh{[ "$kak_count" = 0 ] && echo "$1" || echo "exec '${kak_count}0'"} }
def backspace -params 1 %{ eval %sh{[ "$kak_count" = 0 ] && echo "$1" || echo "exec '${kak_count%?}'"} }

# Sort of a replacement for gq.
#def format-text %{ exec '|fmt<ret>' }
def format-text %{ exec '|par -w%opt{autowrap_column}<a-!><ret>' }

def select-word-better %{
  # Note: \w doesn't use extra_word_chars.
  eval -itersel %{
    try %{ exec '<a-i>w' } catch %{ exec '<a-l>s\w<ret>) <a-i>w' } catch %{}
  }
  exec '<a-k>\w<ret>'
}
def select-WORD-better %{
  eval -itersel %{
    try %{ exec '<a-i><a-w>' } catch %{ exec '<a-l>s\S<ret>) <a-i><a-w>' } catch %{}
  }
  exec '<a-k>\S<ret>'
}

def select-all-occurrences \
  -docstring 'select all occurrences of the current selection' \
  %{
  # Should this use * or <a-*>? * adds \b on word boundaries.
  #exec -save-regs 'ab/' %{*"aZ%s<ret>"bZ"az"b<a-z>a}
  exec -save-regs 'ab/' %{<a-*>"aZ%s<ret>"bZ"az"b<a-z>a}
  echo
}

def switch-to-modified-buffer %{
  eval -save-regs a %{
    reg a ''
    try %{
      eval -buffer * %{
        eval %sh{[ "$kak_modified" = true ] && echo "reg a %{$kak_bufname}; fail"}
      }
    }
    eval %sh{[ -z "$kak_main_reg_a" ] && echo "fail 'No modified buffers!'"}
    buffer %reg{a}
  }
}

# To comment/uncomment a selection containing multiple lines:
# Drop blank lines, unless any line contains unindented text.
# Find the leftmost non-whitespace column among all lines.
# If every line has a comment string starting at this column, delete them.
#   (Optional: Among the lines not ending at the comment string,
#    find the smallest number of spaces shared by all of them
#    immediately after the comment string, and delete that as well.)
# Otherwise insert a comment string before this column.
def comment-line-better %{
  eval %sh{[ -z "$kak_opt_comment_line" ] && echo "fail '%opt{comment_line} not set!"}
  eval -draft -itersel -save-regs '/"a' %{
    exec '<a-x><a-s>gi"aZ'
    try %{
      exec -itersel 'gh<a-K>\S<ret>' # Fail if any line is unindented.
      exec '"az<a-K>^$<ret>"aZ' # Drop blank lines.
    } catch %{
      exec '"az'
    }
    align-cursors-left
    exec '"aZ<a-l>'
    try %{
      reg / "\A\Q%opt{comment_line}\E"
      exec -itersel 's<ret>' # Fail if if any line fails to match.
      exec '<a-d>'
      try %{ # Optional: Remove common whitespace.
        exec '<a-l><a-K>\A$<ret><a-;>;"aZ<a-l>s\A +<ret>'
        align-cursors-left
        exec '"a<a-z>u<a-d>'
      }
    } catch %{
      exec '"az'
      reg '"' %opt{comment_line}
      exec P
    }
  }
  # Maybe instead of maintaining the existing selection, this should select the
  # comment column or the following whitespace, so that you can insert/delete
  # whitespace yourself if you want, <a-J>-style.
}

def align-cursors-left \
  -docstring 'set all cursor (and anchor) columns to the column of the leftmost cursor' \
  %{ eval %sh{
  col=$(echo "$kak_selections_desc" | tr ' ' '\n' | sed 's/^[0-9]\+\.[0-9]\+,[0-9]\+\.//' | sort -n | head -n1)
  sels=$(echo "$kak_selections_desc" | sed "s/\.[0-9]\+/.$col/g")
  echo "select $sels"
}}

def selection-hull \
  -docstring 'The smallest single selection containing every selection.' \
  %{
  eval -save-regs 'ab' %{
    exec '"aZ' '<space>"bZ'
    try %{ exec '"az<a-space>' }
    exec -itersel '"b<a-Z>u'
    exec '"bz'
    echo
  }
}
alias global hull selection-hull

def show-char-info \
  -docstring 'show information about character under cursor' \
  %{
  # This is easy, but it's not a great way of getting Unicode data (doesn't have
  # names for control characters, isn't up to date).
  echo %sh{
  python3 <<-'EOF'
import os, unicodedata
char = chr(int(os.environ['kak_cursor_char_value']))
try:
  info = '{} [{}]'.format(unicodedata.name(char), unicodedata.category(char))
except ValueError as e:
  info = str(e)
print('U+{:x}: {}'.format(ord(char), info))
EOF
  }
}

# This is kind of silly.
def addhl-named -params 2.. \
  -docstring %{
    addhl-named <scope>/<name> <type> <type params>...:
      add a highlighter with a given name} \
  %{
  eval %sh{echo "addhl '$(dirname "$1")/' group '$(basename "$1")'"}
  addhl %arg{@}
}

## More:
# Git extras.
def git-show-blamed-commit %{
  git show %sh{git blame -L "$kak_cursor_line,$kak_cursor_line" "$kak_buffile" | awk '{print $1}'}
}
def git-log-lines %{
  git log -L %sh{
    anchor="${kak_selection_desc%,*}"
    anchor_line="${anchor%.*}"
    echo "$anchor_line,$kak_cursor_line:$kak_buffile"
  }
}
def git-toggle-blame %{
  try %{
    addhl window group hlflags_git_blame_flags
    rmhl window/hlflags_git_blame_flags
    git blame
  } catch %{
    git hide-blame
  }
}
def git-hide-diff %{ rmhl window/hlflags_git_diff_flags }

declare-user-mode git
map global git b ': git-toggle-blame<ret>'       -docstring 'blame (toggle)'
map global git l ': git log<ret>'                -docstring 'log'
map global git c ': git commit<ret>'             -docstring 'commit'
map global git d ': git diff<ret>'               -docstring 'diff'
map global git s ': git status<ret>'             -docstring 'status'
map global git h ': git show-diff<ret>'          -docstring 'show diff'
map global git H ': git-hide-diff<ret>'          -docstring 'hide diff'
map global git w ': git-show-blamed-commit<ret>' -docstring 'show blamed commit'
map global git L ': git-log-lines<ret>'          -docstring 'log blame'


# smarttab.kak?
# Emulate expandtab smarttab, kind of.
# Due to #2122 this can only be done as a hook, not a map.
def smarttab-enable %{
  hook -group smarttab window InsertChar \t %{ exec -draft -itersel "h%opt{indentwidth}@" }
  hook -group smarttab window InsertDelete ' ' %{
    eval -draft -itersel %{ try %{
      exec 'hGh' "s\A((.{%opt{indentwidth}})*[^ ]*) *\z<ret>" '"1R'
    }}
  }
}
def smarttab-disable %{ rmhooks window smarttab }


# Highlight trailing whitespace in normal mode, with the TrailingWhitespace face.
# What I really want is to only not highlight trailing whitespace as I'm
# inserting it, but that doesn't seem possible right now.
def show-trailing-whitespace-enable %{
  addhl-named window/TrailingWhitespace regex \h+$ 0:TrailingWhitespaceActive
  face window TrailingWhitespaceActive TrailingWhitespace
  hook -group trailing-whitespace window ModeChange 'normal:insert' \
    %{ face window TrailingWhitespaceActive '' }
  hook -group trailing-whitespace window ModeChange 'insert:normal' \
    %{ face window TrailingWhitespaceActive TrailingWhitespace }
}
def show-trailing-whitespace-disable %{
  rmhl window/TrailingWhitespace
  rmhooks window trailing-whitespace
}
face global TrailingWhitespace ''


# Tab completion.
def tab-completion-enable %{
  hook -group tab-completion window InsertCompletionShow .* %{
    try %{
      exec -draft 'h<a-K>\s<ret>'
      map window insert <tab> <c-n>
      map window insert <s-tab> <c-p>
    }
  }
  hook -group tab-completion window InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
  }
}
def tab-completion-disable %{ rmhooks window tab-completion }


# This is also kind of silly.
declare-user-mode set
map global set g ':set global ' -docstring 'global'
map global set b ':set buffer ' -docstring 'buffer'
map global set w ':set window ' -docstring 'window'


# volatile-highlighting.kak with some changes. Mainly:
# * Match more keys in the disable hook
# * Remove the disable hook when not active, to clean up debug hook log
face global VolatileHighlighting white,yellow
def volatile-highlighting-enable %{
  hook window -group volatile-highlighting NormalKey [ydcpP] %{ try %{
    addhl window/ group VolatileHighlighting
    addhl window/VolatileHighlighting dynregex '\Q%reg{"}\E' 0:Volatile
    hook window -group volatile-highlighting-active NormalKey [^ydcpP]|..+ %{
      rmhl window/VolatileHighlighting
      rmhooks window volatile-highlighting-active
    }
  }}
}
def volatile-highlighting-disable %{
  rmhl window/VolatileHighlighting
  rmhooks window volatile-highlighting-active
  rmhooks window volatile-highlighting
}


# search-highlighting.kak, simplified
face global Search white,yellow
def search-highlighting-enable %{
  hook window -group search-highlighting NormalKey [/?*nN]|<a-[/?*nN]> %{ try %{
    addhl window/ group SearchHighlighting
    addhl window/SearchHighlighting dynregex '%reg{/}' 0:Search
  }}
  hook window -group search-highlighting NormalKey <esc> %{ rmhl window/SearchHighlighting }
}
def search-highlighting-disable %{
  rmhl window/SearchHighlighting
  rmhooks window search-highlighting
}


# More things.
eval %sh{[ -r "$kak_config/local/kakrc" ] && echo 'source "%val{config}/local/kakrc"' || echo 'echo -debug "no local kakrc"' }
