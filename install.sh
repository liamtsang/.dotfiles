sudo apt install i3 kitty stow git gh kitty picom curl nodejs npm bat dmenu &&
cd ~ &&
git clone https://github.com/liamtsang/.dotfiles &&
curl -L https://github.com/nushell/nushell/releases/download/0.100.0/nu-0.100.0-x86_64-unknown-linux-gnu.tar.gz -o nu.tar.gz &&
tar xzf nu.tar.gz &&
sudo mv nu/* /usr/local/bin/ &&
curl -L https://github.com/biomejs/biome/releases/download/cli%2Fv1.9.4/biome-linux-x64 -o biome &&
chmod +x biome &&
mv biome /usr/local/biome &&
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

