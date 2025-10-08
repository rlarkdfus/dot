#!/bin/zsh

mkdir -p ~/.config

if [ $SHELL != "/bin/fish" ]; then
    if read -q '?Change shell to fish? (y/n) '; then
        echo
        chsh -s /bin/fish
    else
        echo
    fi
fi

link() {
    local source="$1"
    local target="$2"

    if [ ! -e "$target" ]; then
        mkdir -p "$(dirname "$target")"
        ln -fs "$source" "$target"
        echo "✅ Symbolic link created: $target -> $source"
    else
        echo "⚠️  Warning: Target file already exists. No symbolic link created: $target"
    fi
}

if read -q '?Install dotfile symlinks? (y/n) '; then
    echo
    if [ -f ~/sync/dot ]; then
        ln -fs ~/sync/dot ~
    fi

    link ~/dot/vimrc        		        ~/.vimrc
    link ~/dot/tmux.conf   		          ~/.tmux.conf
    link ~/dot/config/kitty/kitty.conf 	~/.config/kitty/kitty.conf
    link ~/dot/config/nvim             	~/.config/nvim
    link ~/dot/config/fish/config.fish 	~/.config/fish/config.fish
    link ~/dot/config/glide/glide.ts    ~/.config/glide/glide.ts
else
    echo
fi
