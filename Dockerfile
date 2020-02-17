FROM ubuntu

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    apt-get update && \
    \
    apt-get install -y sudo curl wget git autojump zsh vim && \
    chsh -s /bin/zsh && \
    \
    echo '--- set timezone ---' && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    \
    echo '--- install node ---' && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -y nodejs && \
    npm install -g yarn --registry=https://registry.npm.taobao.org && \
    apt-get clean && \
    \
    \
    adduser --gecos '' --disabled-password ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER ubuntu

WORKDIR /home/ubuntu

RUN echo '--- install nvm ---' && \
    cd ~ && git clone --depth=1 https://github.com/nvm-sh/nvm.git .nvm && \
    cd ~/.nvm && git fetch --tags && git checkout "$(git describe --tags `git rev-list --tags --max-count=1`)" && cd - \
    \
    echo '--- install zsh ---' && \
    sudo rm -rf /var/cache/apt/archives/lock /var/cache/apt/archives /var/lib/apt/lists/lock /var/lib/apt/lists && \
    curl -sL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sudo -E zsh || true && \
    \
    echo '--- config ---' && \
    yarn config set registry https://registry.npm.taobao.org && \
    npm config set registry https://registry.npm.taobao.org && \
    git config --global alias.co checkout && \
    git config --global alias.br branch && \
    git config --global alias.ci commit && \
    git config --global alias.st status && \
    echo 'set number' > ~/.vimrc && \
    \
    \
    echo 'cd ~ \n\
zsh -c ". ~/.zshrc" \n\
cd ~/.nvm && git fetch --tags && git checkout "$(git describe --tags `git rev-list --tags --max-count=1`)" && cd - \n\
sudo npm install -g yarn --registry=https://registry.npm.taobao.org \n\
rm -rf ~/.zcompdump* && sudo npm cache verify && sudo apt-get clean && yarn cache clean'> ~/.upgrade_system.sh && \
    \
    \
zsh ~/.upgrade_system.sh && \
sudo chown -R ubuntu:ubuntu ~

COPY --chown=ubuntu:ubuntu ./.zshrc /home/ubuntu/.zshrc

LABEL name='ubuntu' version='1.0' description='Ubuntu 浅度定制版' by='haozi'

CMD ["/bin/zsh"]
