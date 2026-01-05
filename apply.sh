if [ -f "/etc/nixos/.env" ]; then
    source /etc/nixos/.env
fi
sudo chown -R juanc /etc/nixos
if [[ -z "$server" ]]; then
  read -p 'server: ' server
fi
if [[ -z "$share" ]]; then
  read -p 'share: ' share
fi
if [ ! -f ~/.ssh/github ]; then
  gio copy smb://$server/$share/keys/github ~/.ssh/github
  chmod  400 ~/.ssh/github
fi
if [ ! -f ~/.ssh/github.pub ]; then
  gio copy smb://$server/$share/keys/github.pub ~/.ssh/github.pub
fi
if [ ! -f /etc/nixos/env.nix ]; then
  gio copy smb://$server/$share/keys/envs/env.nix /etc/nixos/env.nix
fi
if [ ! -f /etc/nixos/.env ]; then
  gio copy smb://$server/$share/keys/envs/.env /etc/nixos/.env
fi
curl https://raw.githubusercontent.com/juancolchete/nixos/refs/heads/main/configuration.nix -o /etc/nixos/configuration.nix 
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --update 
sudo nixos-rebuild switch
chmod  400 /home/juanc/.ssh/github
eval "$(ssh-agent -s)"
ssh-add /home/juanc/.ssh/github
