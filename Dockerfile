FROM sgrio/ubuntu-python:2
MAINTAINER SgrAlpha <admin@mail.sgr.io>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

ADD files/xvfb_init /etc/init.d/xvfb_init
ADD files/xvfb-daemon-run /usr/bin/xvfb-daemon-run

ENV CHROME_VERSION "google-chrome-stable"
ENV CHROME_DRIVER_VERSION "2.28"

RUN \
	apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install \
		unzip \
		xvfb \
		--no-install-recommends -y && \
	apt-key adv --fetch-keys http://dl.google.com/linux/linux_signing_key.pub && \
	echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
	apt-get update && apt-get install ${CHROME_VERSION} -y && \
	apt-get autoclean && apt-get autoremove --purge -y && \
	chmod a+x /etc/init.d/xvfb_init /usr/bin/xvfb-daemon-run && \
	pip install pyvirtualdisplay selenium && \
	curl --silent https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip -o /tmp/chromedriver_linux64.zip && \
	unzip /tmp/chromedriver_linux64.zip -d /usr/local/share/ && \
	ln -s /usr/local/share/chromedriver /usr/bin/ && \
	ln -s /usr/local/share/chromedriver /usr/local/bin/ && \
	rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/* /var/tmp/*
