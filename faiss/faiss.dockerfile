FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm
ENV APP_ROOT=/var/www/app
ENV DEBIAN_FRONTEND=noninteractive
EXPOSE 80

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

RUN apt update -y \
  && apt install -y --no-install-recommends software-properties-common wget build-essential zlib1g-dev locales gcc g++ git curl file swig mecab libmecab-dev mecab-ipadic-utf8 jq \
  && apt clean autoclean \
  && apt autoremove -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/cache /var/lib/log

RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

# Create Jupyter Notebook config file
RUN mkdir -p /root/.jupyter && \
    echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

EXPOSE 8888

# Install Faiss
# https://github.com/kyamagu/faiss-wheels
RUN pip install faiss-cpu==1.7.2 faiss-gpu==1.7.2