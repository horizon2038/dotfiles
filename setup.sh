CURRENT=$(cd $(dirname $0);pwd)
cd $CURRENT

#backup
mkdir -p backup/
cp ~/.wezterm.lua backup/
cp ~/.tmux.conf backup/
cp -r ~/.config/nvim/ backup/

# shell
cp .zshrc ~/

# terminal
cp .wezterm.lua ~/

# utilities
cp .tmux.conf ~/

# editor
mkdir -p ~/.config
cp nvim/init.vim ~/.config/nvim/init.vim
cp nvim/coc-settings.json ~/.config/nvim/coc-settings.json

