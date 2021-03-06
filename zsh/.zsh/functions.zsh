# launch an app
function launch {
    type $1 >/dev/null || { print "$1 not found" && return 1 }
    $@ &>/dev/null &|
}

# Pretty print specified PATH.
# If no argument is supplied use $PATH.
function print_path() {
    if [ ! $1 ] ;then
    1=$PATH
    fi
    echo $1 | tr ":" "\n" | \
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
           sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
           sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
           sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
           sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
           sub(\"/share\", \"$fg_no_bold[red]/share$reset_color\"); \
           print }"
}

function swap_2_files(){
    local TMPFILE="tmp.$(basename $1)$(basename $2)"
    mv $1 $TMPFILE && mv $2 $1 && mv $TMPFILE $2
}

function rec_fix_trailing_whitespace(){
    find . -name '.git' -prune -o -type f -name "$1" -exec sed --in-place 's/[[:space:]]\+$//' {} \+
}

# colored man
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/colored-man-pages/colored-man-pages.plugin.zsh
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        PAGER="${commands[less]:-$PAGER}" \
        _NROFF_U=1 \
        PATH="$HOME/bin:$PATH" \
            man "$@"
}

# most recent items at bottom, replace recent w/ TODAY-YESTERDAY
# https://www.reddit.com/r/archlinux/comments/41s1w4/what_is_your_favorite_one_liner_to_use/cz50y1m
r (){
    ls -vAFq --color=yes -got --si --time-style=long-iso "$@" | sed "s/$(date +%Y-%m-%d)/\x1b[32m     TODAY\x1b[m/;s/$(date +'%Y-%m-%d' -d yesterday)/\x1b[33m YESTERDAY\x1b[m/" | tac
}

function color_to_greyscale_pdf(){
    if [ ! $2 ] ;then
        2=$(basename $1 .pdf)
        2+="-greyscale.pdf"
    fi
    gs \
        -sOutputFile=$2 \
        -sDEVICE=pdfwrite \
        -sColorConversionStrategy=Gray \
        -dProcessColorModel=/DeviceGray \
        -dCompatibilityLevel=1.4 \
        -dNOPAUSE \
        -dBATCH \
        $1
}

function pdfa4(){
    if [ ! $1 ] ;then
        return 1
    fi
    if [ ! $2 ] ;then
        2=$(basename $1 .pdf)
        2+="-a4.pdf"
    fi
    gs -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dAutoRotatePages=/All -dFIXEDMEDIA -dPDFFitPage -dCompatibilityLevel=1.4 -o $2 $1
}

function venv() {
    [[ ! $1 ]] && echo 'This function needs an argument' && return 1
    [[ $2 ]] && echo 'This function takes exactly one argument' && return 1

    local dir="$HOME/.cache/myenvs/$1"
    [[ -d "$dir" ]] && source "$dir/bin/activate" && return 0

    python3 -m venv "$dir"
    source "$dir/bin/activate"
    pip install -U pip
    pip install black ipdb ipython loguru pylint tqdm
}

# Count lines from git repo
function gloc(){
    local dest=$(mktemp -d)
    git clone --depth 1 "$1" "$dest" &> /dev/null &&
      cloc "$dest" &&
      rm -rf "$dest"
}

slash-backward-kill-word() {
    local WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"
    zle backward-kill-word
}
zle -N slash-backward-kill-word
