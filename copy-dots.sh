#!/bin/bash
# backup-dotfiles.sh
# Copies fish, starship, and zed configs from ~/.config into ~/Desktop/work/dotfiles

# Fish
echo "Copying fish configs..."
rm -rf "./fish"
cp -r ~/.config/fish "./fish"

# Starship
echo "Copying starship.toml..."
cp ~/.config/starship.toml "./"

# Zed
echo "Copying zed configs..."
rm -rf "./zed" 
cp -r ~/.config/zed "./zed"
rm -rf "./zed/prompts" "./zed/conversations"

# Ghostty
echo "Copying ghostty configs..."
rm -rf "./zed" 
cp -r ~/.config/zed "./zed"
rm -rf "./zed/prompts" "./zed/conversations"

echo "Done! All configs copied to ."
