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
    adduser --gecos '' --disabled-password ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd && \
    \
    echo '--- install ohmyzsh ---' && \
    cd /home/ubuntu && git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git .oh-my-zsh && \
    chown -R ubuntu:ubuntu . && \
    apt-get clean

USER ubuntu
WORKDIR /home/ubuntu

RUN curl https://get.volta.sh | bash && \
    \
    echo 'export PATH=$HOME/bin:/usr/local/bin:$PATH \n\
export ZSH="/home/ubuntu/.oh-my-zsh" \n\
\n\
ZSH_THEME="simple" \n\
DISABLE_AUTO_UPDATE="true" \n\
plugins=(git history autojump) \n\
\n\
export LANG=en_US.UTF-8 \n\
\n\
export VOLTA_HOME="$HOME/.volta" \n\
export NPM_CONFIG_UPDATE_NOTIFIER=false \n\
export PATH="$VOLTA_HOME/bin:$PATH" \n\
export PNPM_HOME="$HOME/.pnpm" \n\
export PATH="$PNPM_HOME:$PATH" \n\
\n\
source $ZSH/oh-my-zsh.sh \
' > ~/.zshrc && zsh -c '. ~/.zshrc' && \
    \
    \
    \
    \
    ~/.volta/bin/volta install node@lts pnpm yarn@1 && \
    \
    \
    echo '--- set config ---' && \
        ~/.volta/bin/npm config set registry https://registry.npmmirror.com/ && \
        ~/.volta/bin/yarn config set registry https://registry.npmmirror.com/ && \
        git config --global alias.co checkout && \
        git config --global alias.br branch && \
        git config --global alias.ci commit && \
        git config --global alias.st status && \
        echo 'set number' > ~/.vimrc && \
    \
    \
    \
    echo 'zsh -c ". ~/.zshrc" \nrm -rf ~/.zcompdump* && npm cache clean -f && npm cache verify && yarn cache clean && sudo apt-get clean'> ~/.upgrade_system.sh && \
    \
    \
    \
    rm -rf ~/.zcompdump* && \
    sudo chown -R ubuntu:ubuntu ~

LABEL name='ubuntu' version='1.0' description='Ubuntu 浅度定制版' by='haozi'

CMD ["/bin/zsh"]
