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
    curl -sL https://deb.nodesource.com/setup_14.x | bash && \
    apt-get install -y nodejs && \
    npm install -g yarn --registry=https://registry.npm.taobao.org && \
    npm install -g pnpm --registry=https://registry.npm.taobao.org && \
    \
    \
    adduser --gecos '' --disabled-password ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd && \
    \
    echo '--- install nvm ---' && \
    cd /home/ubuntu && git clone --depth=1 https://github.com/nvm-sh/nvm.git .nvm && \
    cd .nvm && git fetch --tags && git checkout "$(git describe --tags `git rev-list --tags --max-count=1`)" && rm -rf .git && cd - \
    echo '--- install ohmyzsh ---' && \
    cd /home/ubuntu && git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git .oh-my-zsh && \
    chown -R ubuntu:ubuntu . && \
    apt-get clean && npm cache clean -f && npm cache verify && yarn cache clean

USER ubuntu

WORKDIR /home/ubuntu

RUN echo 'export PATH=$HOME/bin:/usr/local/bin:$PATH \n\
export ZSH="/home/ubuntu/.oh-my-zsh" \n\
\n\
ZSH_THEME="simple" \n\
DISABLE_AUTO_UPDATE="true" \n\
plugins=(git history autojump) \n\
\n\
export LANG=en_US.UTF-8 \n\
\n\
export NVM_DIR="$HOME/.nvm" \n\
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \n\
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \n\
\n\
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH" \n\
source $ZSH/oh-my-zsh.sh \n' > ~/.zshrc && zsh -c '. ~/.zshrc' && \
    \
    \
    echo 'export NVM_DIR="$HOME/.nvm" \n\
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \n\
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \n\
\n\
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH" \n\
/bin/zsh' >> ~/.bashrc && sudo rm -rf /bin/sh && sudo ln -s /bin/bash /bin/sh && \
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
sudo npm install -g npm yarn --registry=https://registry.npm.taobao.org \n\
rm -rf ~/.zcompdump* && sudo npm cache clean -f && sudo npm cache verify && sudo apt-get clean && yarn cache clean'> ~/.upgrade_system.sh && \
    \
    \
sudo chown -R ubuntu:ubuntu ~

LABEL name='ubuntu' version='1.0' description='Ubuntu 浅度定制版' by='haozi'

CMD ["/bin/zsh"]
