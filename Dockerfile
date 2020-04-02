FROM python:3.5.9-buster

# install Chrome Driver
RUN apt-get update && apt-get install -y unzip && \
    CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver && \
    chmod 755 ~/chromedriver && \
    mv ~/chromedriver /usr/bin/chromedriver && \
    sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

WORKDIR /

RUN git clone https://github.com/amu-kuroneko/K-AutoBook.git

RUN mkdir -p /data
COPY config.json /K-AutoBook/
COPY k_auto_book.py /K-AutoBook/
COPY ./ebookjapan /K-AutoBook/ebookjapan

WORKDIR /K-AutoBook

RUN pip install Cython 
RUN pip install -r requirements.txt

