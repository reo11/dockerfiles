FROM continuumio/anaconda3

RUN apt update && \
    apt install -y --no-install-recommends build-essential sudo file

# Create Jupyter Notebook config file
RUN mkdir -p /root/.jupyter && \
    echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

EXPOSE 8888

# Install gensim
RUN conda install -y gensim

# Install MeCab
RUN apt install -y --no-install-recommends mecab libmecab-dev mecab-ipadic-utf8 && \
    pip install mecab-python3

# Install mecab-ipadic-NEologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git /tmp/neologd && \
    /tmp/neologd/bin/install-mecab-ipadic-neologd -n -a -y && \
    sed -i -e "s|^dicdir.*$|dicdir = /usr/lib/mecab/dic/mecab-ipadic-neologd|" /etc/mecabrc && \
    rm -rf /tmp/neologd

# Install neologdn
RUN pip install neologdn

# Install CRF++
RUN wget -O /tmp/CRF++-0.58.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ" && \
    cd /tmp && \
    tar zxf CRF++-0.58.tar.gz && \
    cd CRF++-0.58 && \
    ./configure && \
    make && \
    make install && \
    cd / && \
    rm /tmp/CRF++-0.58.tar.gz && \
    rm -rf /tmp/CRF++-0.58 && \
    ldconfig

# Install CaboCha
RUN cd /tmp \
    && DOWNLOAD_URL="https://drive.google.com`curl -c cookies.txt 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7SDd1Q1dUQkZQaUU' | sed -r 's/"/\n/g' |grep id=0B4y35FiV1wh7SDd1Q1dUQkZQaUU |grep confirm |sed 's/&amp;/\&/g'`" \
    && curl -L -b cookies.txt -o /tmp/cabocha-0.69.tar.bz2 "$DOWNLOAD_URL" \
    && tar jxf cabocha-0.69.tar.bz2 \
    && cd cabocha-0.69 \
    && ./configure --with-mecab-config=`which mecab-config` --with-charset=utf8 \
    && make \
    && make install \
    && cd python \
    && python setup.py build \
    && python setup.py install

# Install fastText
RUN pip install git+https://github.com/facebookresearch/fastText.git

# Install Janome
RUN pip install janome

# Install spaCy
RUN pip install spacy

# Install pykakasi
RUN pip install pykakasi
