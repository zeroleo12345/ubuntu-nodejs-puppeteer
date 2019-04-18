FROM ubuntu:18.04

ADD . /app/docker

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && cp /app/docker/sources.list.aliyun /etc/apt/sources.list \
    && apt-get update && apt-get install -y sudo gnupg2 \
    && cat /app/docker/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && cat /app/docker/setup_10.x | sudo -E bash -

RUN apt-get install -y nodejs \
    && apt-get install -y --no-install-recommends google-chrome-unstable \
    && apt-get purge --auto-remove \
    && rm -rf /tmp/* /var/lib/apt/lists/* \
    && rm -rf /usr/bin/google-chrome* /opt/google/chrome-unstable \
    && apt-get clean -y

# 安装puppeteer, 需要打开全局翻墙!
ADD package.json package-lock.json /
RUN npm install
