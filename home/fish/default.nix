{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      alias ide="tmux new-session -d lazygit \; split-window -h \; resize-pane -R 75 \; swap-pane -D \; split-window -v -d nvim -c "NvimTreeToggle" \; resize-pane -D 15 \; swap-pane -D \; attach"
    '';
  };
}
