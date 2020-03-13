#!/usr/bin/env bash

# install kops from github
curl -Lo kops https://github.com/kubernetes/kops/releases/download/"$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)"/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/

# install kubectl from kubectl release
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/"$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# install aws cli
pip install awscli
