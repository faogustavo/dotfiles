function fish_prompt
  set -l normal (set_color $fish_color_normal)
  set -l hostcolor (set_color $fish_color_host)
  set -l user_color (set_color $fish_color_user)
  set -l cwd_color (set_color $fish_color_cwd)

  set -g __fish_git_prompt_char_stateseparator ' '
  set -g __fish_git_prompt_color ea76cb
  set -g __fish_git_prompt_color_flags df5f00
  set -g __fish_git_prompt_color_prefix white
  set -g __fish_git_prompt_color_suffix white
  set -g __fish_git_prompt_showdirtystate true
  set -g __fish_git_prompt_showuntrackedfiles true
  set -g __fish_git_prompt_showstashstate true
  set -g __fish_git_prompt_show_informative_status true

  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
        set -g __fish_prompt_char '#'
      case '*'
        set -g __fish_prompt_char 'λ'
    end
  end

  set -l cwd (pwd | sed "s=$HOME=~=")
  set -l current_user (whoami)
  set -l machine_name (hostname -s)

  echo -n $hostcolor'╭─ '$user_color$current_user$normal'@'$hostcolor$machine_name$cwd_color' '$cwd
  __fish_git_prompt " (%s)"
  echo
  echo -n $hostcolor'╰─ '$normal$__fish_prompt_char

  echo -n -s " "
end
