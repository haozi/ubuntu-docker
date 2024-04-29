FROM ubuntu:24.04
ENV LANG C.UTF-8

RUN apt-get update && \
    \
    apt-get install -y sudo curl wget unzip git autojump zsh vim locales && \
    chsh -s /bin/zsh && \
    \
    echo '--- set locale ---' && \
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8 && \
    echo 'export LANGUAGE=zh_CN.UTF-8' >> ~/.bashrc && \
    echo "export LANG=zh_CN.UTF-8" >> ~/.bashrc && \
    \
    echo '--- set timezone ---' && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    \
    echo '--- install ohmyzsh ---' && \
    cd /root && git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git .oh-my-zsh && \
    apt-get clean

USER root
WORKDIR /root
SHELL ["/bin/zsh", "-c"]

RUN echo 'export PATH=$HOME/bin:/usr/local/bin:$PATH \n\
export ZSH="/root/.oh-my-zsh" \n\
\n\
ZSH_THEME="simple" \n\
DISABLE_AUTO_UPDATE="true" \n\
plugins=(git history autojump) \n\
\n\
export PATH="$HOME.local/share/fnm:$PATH" \n\
export NPM_CONFIG_UPDATE_NOTIFIER=false \n\
export PNPM_HOME="$HOME/.pnpm" \n\
export PATH="$PNPM_HOME:$PATH" \n\
\n\
source $ZSH/oh-my-zsh.sh \
' > ~/.zshrc && zsh -c '. ~/.zshrc' && \
    \
    curl -fsSL https://fnm.vercel.app/install | bash && \
    . ~/.zshrc && \
    fnm install --lts && \
    \
    \
    npm install -g pnpm yarn@1 && \
    echo '--- set config ---1' && \
    git config --global alias.co checkout && \
    git config --global alias.br branch && \
    git config --global alias.ci commit && \
    git config --global alias.st status && \
    echo 'set number' > ~/.vimrc && \
    \
    echo 'zsh -c ". ~/.zshrc" \nrm -rf ~/.zcompdump* && npm cache clean -f && npm cache verify && yarn cache clean && sudo apt-get clean'> ~/.upgrade_system.sh && \
    zsh ~/.upgrade_system.sh

LABEL name='ubuntu' version='24.04' description='Ubuntu 浅度定制版' by='haozi'

CMD ["/bin/zsh"]
