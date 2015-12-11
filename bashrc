#
# pooters - production
# nodog
# 2004-06-04
#
# .bashrc
#
# revisions
# ---------

# this is here because of path_helper on macs and tmux calling a login shell :P
if [ -f /etc/profile ] && [ -x /usr/libexec/path_helper ]; then
  PATH=""
  source /etc/profile
fi

# I'd like to add some directories to my path if they exist and aren't there already
myAddToPath="/usr/local/sbin /opt/local/bin /opt/local/sbin \
   /opt/local/libexec/gnubin/ /usr/local/processing $HOME/bin /sbin /usr/sbin \
   /opt/local/lib/postgresql94/bin"
for myDir in $myAddToPath; do
   if [ -d $myDir ] && echo $PATH | grep -v $myDir > /dev/null; then
      export PATH=$myDir:$PATH
   fi
done

# adding to the man path
myAddToManPath=/opt/local/share/man
for myManDir in $myAddToManPath; do
   if [ -d $myManDir ] && echo $PATH | grep -v $myManDir > /dev/null; then
      export MANPATH=$myManDir:$MANPATH
   fi
done

# interactive shell
if ( echo $- | grep i ) > /dev/null ; then

   # enable completion in interactive shells
   if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
     . /opt/local/etc/profile.d/bash_completion.sh
   fi
   if [ -f /opt/local/share/git/contrib/completion/git-completion.bash ]; then
     . /opt/local/share/git/contrib/completion/git-completion.bash
   fi

   # prompt
   source $HOME/.mypromptcolors
   MYPS1LEFT="\n\h:${IBlue?}\w${Color_Off?} "
   #MYPS1LEFT="\n\h:\w "
   # color on the second line is causing character erasing problems :(
   #MYPS1NEXT="\n${White?}>${Color_Off?} "
   MYPS1NEXT="\n$ "
   MYPS1RIGHT=""
   if [ -f /opt/local/share/git/contrib/completion/git-prompt.sh ]; then
     . /opt/local/share/git/contrib/completion/git-prompt.sh
     MYPS1RIGHT=${White?}'$(__git_ps1 "(%s)")'${Color_Off?}${MYPS1RIGHT?}
   fi

   export PS1=${MYPS1LEFT?}${MYPS1RIGHT?}${MYPS1NEXT?}

   # personalization
   export LANG=en_US.UTF-8
   export LC_ALL=en_US.UTF-8
   stty erase "^?" kill "^U" intr "^C" eof "^D" susp "^Z" hupcl ixon ixoff
   set -o notify -o ignoreeof
   shopt -u cdspell
   umask 022
   export LESS="-i -M -j2"
   export TOP=all
   export PAGER="less -R"
   export EDITOR=vim
   export BLOCKSIZE=K
   export RSYNC_RSH=/usr/bin/ssh
   export REPOS=file:///$HOME/repository/

   alias grep="grep --color=auto"
   alias fgrep="fgrep --color=auto"
   alias gzip="gzip -v"
   alias dc="dc -e 5k -"
   eval `dircolors $HOME/.dir_colors`
   alias ls="ls -FNv --dereference-command-line-symlink-to-dir --color=auto -T 0 --time-style=long-iso"
   alias mySuggestMusic="( cd $HOME/PERILO/music; find . -mindepth 2 -maxdepth 2 ) | unsort 2>/dev/null | head -20"
   alias rspec="rspec --color"

   # history control
   shopt -s histappend                   # append to the history file instead of rewriting it
   export HISTFILESIZE=100000            # number of size file to store
   export HISTSIZE=100000                # number ol lines to store
   export HISTCONTROL=ignoreboth         # ignore commands starting with spaces and dups
   export HISTIGNORE='ls:bg:fg:history'  # ignore these commands
   export HISTTIMEFORMAT='%F %T '        # add date and time
   shopt -s cmdhist                      # one command per line, even if entered on separate lines
   export PROMPT_COMMAND='history -a'    # store stuff immediately

   # keychains -- add in selection of id_rsa or id_dsa depending on existence
#   keychain -q $HOME/.ssh/id_rsa
#      [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && \
#         source $HOME/.keychain/$HOSTNAME-sh
#      [[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]] && \
#         source $HOME/.keychain/$HOSTNAME-sh-gpg

   # machine specific commands
   case ${HOSTNAME/.*/} in
      brebis|cheddar|roquefort)
         if ! [ -f $HOME/.myRsync-talkingbone-main ]; then
	   #echo Cet ordinateur n\'a PAS ta vérité.
	   echo Esta computadora no contiene su verdad.
	 fi
         # Terminal colours (after installing GNU coreutils)
         NM="\[\033[0;38m\]" #means no background and white lines
         HI="\[\033[0;37m\]" #change this for letter colors
         HII="\[\033[0;31m\]" #change this for letter colors
         SI="\[\033[0;33m\]" #this is for the current directory
         IN="\[\033[0m\]"

	 #Android SDK
	 export ANDROID_SDK=$HOME/src/java/android-sdk-macosx

	 EDITOR=/opt/local/bin/vim

         # Useful aliases
	 set mark-symlinked-directories

	 export LC_CTYPE=en_US.UTF-8
	 export LANG=en_US.UTF-8
         alias be="bundle exec"
	 alias myMountPERILO="hdiutil attach $HOME/shard/CAVE/loopback/PERILO.dmg -mountpoint $HOME/PERILO"
	 export VAGRANT_DEFAULT_PROVIDER=vmware_fusion
         alias ardu="/Applications/Arduino.app/Contents/MacOS/Arduino --verbose --upload"
         alias ardv="/Applications/Arduino.app/Contents/MacOS/Arduino --verbose --verify"
         alias postgres_start='sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql94-server/postgresql94-server.wrapper start';
         alias postgres_stop='sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql94-server/postgresql94-server.wrapper stop';
         alias postgres_restart='sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql94-server/postgresql94-server.wrapper restart';
         alias postgres_status='sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql94-server/postgresql94-server.wrapper status';
         export RBENV_ROOT="$HOME/.rbenv"

         if [ -d $RBENV_ROOT ]; then
             export PATH="$RBENV_ROOT/bin:$PATH"
             eval "$(rbenv init -)" 2>&-
             . /opt/local/etc/bash_completion.d/rbenv
         fi

         if [ -d $HOME/down/z ]; then
     .     $HOME/down/z/z.sh
         fi
      ;;
      lapaz)
         export PS1="\nkonfuzo:\w$ "
      ;;
      *)
   esac

#   # For different spoken languages
#
#   #esperanto
#   #alias akirupoŝton="fetchmail 2>/dev/null"
#   #alias fetchmailfpms="fetchmail -f $HOME/.fetchmailrc.fpms"
#   alias gnukontantaĵo=gnucash
#   alias miarsinkronigu=myrsync
#   alias klarigu=clear
#   alias ekrano=screen
#   alias haltu="sudo halt"
#   alias foriru=exit
#   alias tuŝu=touch
#
#   #french
#   #alias telnet="echo Est-ce que tu dois tenir la discipline?"
#   #alias JeNeTravaillesPasMaintenant="/usr/bin/telnet nethack.alt.org"
#   alias écran=screen
#   alias ecran=screen
#   alias vider=clear
#   alias sortir=exit
#   alias éteindre="sudo halt"
#   alias redémarrer="sudo reboot"
#   alias reconnecter="sudo restart network-manager && watch ifconfig"
#   #alias rapporterlesemails="fetchmail 2>/dev/null"
#   alias rapporterlesemails="echo Pas maintenant."
#   alias cabot=mutt
#   #alias rappeler="clear && fortune /usr/share/games/fortunes/fr && gcal && echo && rem -c+2 -m -b1"
#   alias rappeler="clear && gcal && echo && rem -c+2 -m -b1"
#   alias barrer=lock

fi
