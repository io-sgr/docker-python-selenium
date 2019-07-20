FROM sgrio/ubuntu-python:3
MAINTAINER SgrAlpha <admin@mail.sgr.io>

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ADD files/xvfb_init /etc/init.d/xvfb_init
ADD files/xvfb-daemon-run /usr/bin/xvfb-daemon-run

RUN \
    CHROME_VERSION="google-chrome-stable" && \
    CHROME_DRIVER_VERSION="75.0.3770.140" && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install \
        gnupg2 \
        unzip \
        xvfb \
        --no-install-recommends -y && \
    curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install ${CHROME_VERSION} -y && \
    apt-get autoclean && apt-get autoremove --purge -y && \
    chmod a+x /etc/init.d/xvfb_init /usr/bin/xvfb-daemon-run && \
    pip install --upgrade pip && \
    pip install pyvirtualdisplay selenium && \
    curl --silent https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip -o /tmp/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver_linux64.zip -d /usr/local/share/ && \
    ln -s /usr/local/share/chromedriver /usr/bin/ && \
    ln -s /usr/local/share/chromedriver /usr/local/bin/ && \
    rm -rf ~/.cache/pip/* /var/lib/apt/lists/* /var/cache/apt/* /tmp/* /var/tmp/*
