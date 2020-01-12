FROM ubuntu

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y sudo curl wget git autojump zsh vim && \
    chsh -s /bin/zsh && \
    echo '--- set timezone ---' && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo '--- install node ---' && \
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash && \
    apt-get install -y nodejs && \
    npm install -g yarn --registry=https://registry.npm.taobao.org && \
    apt-get clean

RUN adduser --gecos '' --disabled-password ubuntu && \
	echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER ubuntu

WORKDIR /home/ubuntu

RUN curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash && \
    echo '--- install zsh ---' && \
    sudo rm -rf /var/cache/apt/archives/lock /var/cache/apt/archives /var/lib/apt/lists/lock /var/lib/apt/lists && \
    curl -sL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sudo -E zsh || true && \
    echo '--- config ---' && \
    yarn config set registry https://registry.npm.taobao.org && \
    npm config set registry https://registry.npm.taobao.org && \
    git config --global alias.co checkout && \
    git config --global alias.br branch && \
    git config --global alias.ci commit && \
    git config --global alias.st status && \
    sudo chown -R ubuntu:ubuntu ~ && \
    echo 'set number' > ~/.vimrc && \
    echo '--- clean ---' && \
    sudo npm cache verify && sudo apt-get clean && yarn cache clean


COPY --chown=ubuntu:ubuntu ./.zshrc /home/ubuntu/.zshrc

LABEL name='ubuntu' version='1.0' description='Ubuntu 浅度定制版' by='haozi'
