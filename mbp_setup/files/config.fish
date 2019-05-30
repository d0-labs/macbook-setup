set -g -x PATH /usr/local/bin $PATH
set -g theme_display_ruby no        # Disables displaying the current ruby version
set -g theme_display_virtualenv no  # Disables displaying the current virtualenv name

# Go settings
set -g -x GOPATH "$HOME/.go"
set -g -x GOROOT (brew --prefix golang)/libexec
set -g -x PATH "$PATH:$GOPATH/bin:$GOROOT/bin"

# Aliases
alias ll='ls -lh'
alias la='ls -alh'

#Git Add
function ga
    if [ -z "$argv" ]
        git add .
    else
        git add $argv
    end
end

#Git Add & Commit
function gac
	git add .
    git commit -m "$argv"
end

function gst
	git status
end

function gco
	git checkout $argv
end

function gcb
  git pull
  git checkout -b "$argv"
end

function gpush
	git push
end

function gpull
	git pull
end

function gprune
    git remote update origin --prune
end

#$ git checkout -b razzi/ticket-1
#$ gcr Blah
#[razzi/ticket-1 25719b6] [TICKET-1] Blah
function gcr
	set ref (git current | cut -d / -f 2 | tr '[:lower:]' '[:upper:]')
    git commit -m "[$ref] $argv"
end

function clear-dns
	sudo killall -HUP mDNSResponder
end

function git_version_tags -d "Lists all tags that look like a version: X.Y.Z or vX.Y.Z"

  git for-each-ref \
    --sort=-taggerdate \
    --format='%(refname:short)' \
    'refs/tags/*' | grep '^v\?\d\+\.\d\+\.\d\+'

end

function git_changelog
  --argument range \
  --description "Prints git log in a way convenient for writing release notes"

  # default range is since the last version
  test -n "$range"; or set range (git_last_version)".."

  git --no-pager log --reverse --format="* %s" $range

end

function _common_section
    printf $c1
    printf $argv[1]
    printf $c0
    printf ":"
    printf $c2
    printf $argv[2]
    printf $argv[3]
    printf $c0
    printf ", "
end

function section
    _common_section $argv[1] $c3 $argv[2] $ce
end

function error
    _common_section $argv[1] $ce $argv[2] $ce
end

function git_branch
    set inside_git_repo (git rev-parse --is-inside-work-tree 2>/dev/null)
    if test "$inside_git_repo"
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    else
        echo " "
    end
end

# git-clean-branches
#
# * Will delete all fully merged local branches
#   and any closed remote branches.
# * User is prompted to continue before deleting.
# * Pass in -d or --dry-run to see what would happen without changing anything
# 
# Credit to Rob Miller <rob@bigfish.co.uk>
# Adapted from the original by Yorick Sijsling
# See: https://gist.github.com/robmiller/5133264
# Author John Schank
# Errors are mine, use at your own risk.

function git-clean-branches --description="Delete all fully merged local and remote branches"
    for option in $argv
        switch "$option"
            case -d --dry-run
                set DRY_RUN true                
            case \*
                printf "Error: unknown option %s\n" $option
        end
    end

    #  Make sure we're on develop first
    git checkout develop > /dev/null ^&1

    # Make sure we're working with the most up-to-date version of develop.
    git fetch

    # Prune obsolete remote tracking branches. These are branches that we
    # once tracked, but have since been deleted on the remote.
    git remote prune origin

    # List all the branches that have been merged fully into develop, and
    # then delete them. We use the remote develop here, just in case our
    # local develop is out of date.
    set -l MERGED_LOCAL (git branch --merged origin/develop | grep -v 'develop$' | string trim)
    if test -n "$MERGED_LOCAL"
        echo
        echo "The following local branches are fully merged and will be removed:"
        echo $MERGED_LOCAL
        read --local --prompt-str "Continue (y/N)? " REPLY
        if test "$REPLY" = "y"
            for branch in $MERGED_LOCAL
                if test $DRY_RUN
                    echo "Would delete local branch: '$branch'"
                else
                    echo "Deleting local branch: '$branch'"
                    git branch --quiet --delete $branch 
                end
            end
        end        
    end

    # Now the same, but including remote branches.
    set -l MERGED_ON_REMOTE (git branch -r --merged origin/develop | sed 's/ *origin\///' | grep -v 'develop$')

    if test -n "$MERGED_ON_REMOTE"
        echo
        echo "The following remote branches are fully merged and will be removed:"
        echo $MERGED_ON_REMOTE
        read --local --prompt-str "Continue (y/N)? " REPLY
        if test "$REPLY" = "y"
            for branch in $MERGED_ON_REMOTE
                if test $DRY_RUN
                    echo "Would delete remote branch: '$branch'"
                else
                    echo "Deleting remote branch: '$branch'"
                    git push --quiet origin :$branch 
                end
            end
        end
    end

    echo "Done!"
end


function fish_prompt
    # $status gets nuked as soon as something else is run, e.g. set_color
    # so it has to be saved asap.
    set -l last_status $status

    # c0 to c4 progress from dark to bright
    # ce is the error colour
    set -g c0 (set_color 005284)
    set -g c1 (set_color 0075cd)
    set -g c2 (set_color 009eff)
    set -g c3 (set_color 6dc7ff)
    set -g c4 (set_color ffffff)
    set -g ce (set_color $fish_color_error)
    set -g magenta (set_color ff00ff)
    set -g green (set_color 66CD00)
    set -g yellow (set_color ffff00)
    set -g white (set_color ffffff)
    

    # Clear the line because fish seems to emit the prompt twice. The initial
    # display, then when you press enter.
    printf "\033[K"

    # Current Directory
    # 1st sed for colourising forward slashes
    # 2nd sed for colourising the deepest path (the 'm' is the last char in the
    # ANSI colour code that needs to be stripped)
    printf $white
    printf $yellow(whoami)@$yellow(hostname)' '(pwd | sed "s,/,$c0/$c1,g" | sed "s,\(.*\)/[^m]*m,\1/$c3,")' '$magenta(git_branch)

    # Prompt on a new line
    printf "\n$green»❯ "

end
