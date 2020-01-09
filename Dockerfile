FROM ubuntu

RUN apt-get update && \
    apt-get install -y curl wget zsh git autojump && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -y nodejs && \
    npm install -g yarn --registry=https://registry.npm.taobao.org && \
    yarn config set registry https://registry.npm.taobao.org && \
    curl -sL  https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | bash || true && \
    curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash && \
    git config --global alias.co checkout && \
    git config --global alias.br branch && \
    git config --global alias.ci commit && \
    git config --global alias.st status && \
    apt-get clean

COPY ./.zshrc /root/.zshrc
