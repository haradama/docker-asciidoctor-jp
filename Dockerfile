FROM asciidoctor/docker-asciidoctor
LABEL MAINTAINER Hitoshi TAKEUCHI <hitoshi@namaraii.com>

ENV COMPASS_VERSION 0.12.7
ENV ZURB_FOUNDATION_VERSION 4.3.2
WORKDIR /root

RUN gem install asciidoctor-pdf-cjk-kai_gen_gothic --no-ri --no-rdoc && \
    gem install --version ${COMPASS_VERSION} compass --no-ri --no-rdoc && \
    gem install --version ${ZURB_FOUNDATION_VERSION} zurb-foundation --no-ri --no-rdoc && \
    asciidoctor-pdf-cjk-kai_gen_gothic-install && \
    ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk add --no-cache \
        openssl && \
    rm -rf /tmp/* /var/tmp/* && \
    wget -O VLGothic.zip "http://osdn.jp/frs/redir.php?m=jaist&f=%2Fvlgothic%2F62375%2FVLGothic-20141206.zip" && \
    unzip VLGothic.zip && \
    mkdir -p /root/.fonts && \
    cp VLGothic/VL-Gothic-Regular.ttf /root/.fonts && \
    rm -rf /root/VLGothic* && \
    wget https://github.com/asciidoctor/asciidoctor-stylesheet-factory/archive/master.zip && \
    unzip master.zip && \
    cd asciidoctor-stylesheet-factory-master && \
    compass compile && \
    cp -pr stylesheets / && \
    apk del openssl
   
WORKDIR /documents