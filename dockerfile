
FROM ubuntu:20.04

# 新建用户
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list \
&& apt update \
&& useradd --create-home --no-log-init --shell /bin/bash docker \
&& adduser docker sudo \
&& echo 'docker:docker' | chpasswd \
&& apt install git \
&& wget https://golang.google.cn/dl/go1.18.10.linux-amd64.tar.gz \
&& tar -xzvf go1.18.10.linux-amd64.tar.gz \
&& mv go /usr/local/lib/ \
&& ln -s /usr/local/lib/go/bin/* /usr/bin/\
&& go env -w GO111MODULE=on \
&& go env -w GOPROXY=https://goproxy.cn,direct


# 安装配置 fixuid
RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://foruda.gitee.com/attach_file/1680331824410440400/fixuid-0.5.1.tar.gz?token=db4a58f7ce660e4aa5bedfa98396d103&ts=1680331835&attname=fixuid-0.5.1.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml


USER docker:docker
ENTRYPOINT ["fixuid"]

WORKDIR /home/docker
VOLUME $HOME:/home/docker
