FROM ubuntu
LABEL name='ubuntu' version='1.0' description='Ubuntu 浅度定制版' by='haozi'

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y sudo curl wget git autojump && \
    echo '--- set timezone ---' && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apt-get clean

RUN adduser --gecos '' --disabled-password ubuntu && \
	echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER ubuntu

WORKDIR /home/ubuntu

RUN echo '--- install node ---' && \
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash && \
    sudo apt-get install -y nodejs && \
    sudo npm install -g yarn --registry=https://registry.npm.taobao.org && \
    sudo chown -R ubuntu:ubuntu $HOME/.* && \
    yarn config set registry https://registry.npm.taobao.org && \
    curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash && \
    echo '--- install zsh ---' && \
    sudo apt-get install -y zsh && \
    sudo chsh -s /bin/zsh && \
    sudo rm -rf /var/cache/apt/archives/lock /var/cache/apt/archives /var/lib/apt/lists/lock /var/lib/apt/lists && \
    curl -sL https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sudo -E zsh || true && \
    echo '--- config ---' && \
    git config --global alias.co checkout && \
    git config --global alias.br branch && \
    git config --global alias.ci commit && \
    git config --global alias.st status && \
    sudo apt-get clean

COPY ./.zshrc /home/ubuntu/.zshrc
RUN sudo chown -R ubuntu:ubuntu $HOME/.*
