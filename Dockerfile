FROM asciidoctor/docker-asciidoctor:1.3.0

LABEL Maintainer="Masafumi Harada"

ENV COMPASS_VERSION=0.12.7
ENV ZURB_FOUNDATION_VERSION=4.3.2
ENV ADOCTOR_DIAGRAM_VERSION=1.5.15
ENV IPAEXFONT_VERSION=00401

ENV IPAEXFONT_URL=https://moji.or.jp/wp-content/ipafont/IPAexfont/IPAexfont${IPAEXFONT_VERSION}.zip
ENV ADOCTOR_STYLESHEET_FACTORY_URL=https://github.com/asciidoctor/asciidoctor-stylesheet-factory.git

WORKDIR /tmp

COPY default-theme.patch /tmp/

RUN gem install -v ${COMPASS_VERSION} compass -N && \
    gem install -v ${ZURB_FOUNDATION_VERSION} zurb-foundation -N && \
    gem install bundler -N && \
    gem install -v ${ADOCTOR_DIAGRAM_VERSION} asciidoctor-diagram -N && \
    ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    wget ${IPAEXFONT_URL} && \
    unzip IPAexfont${IPAEXFONT_VERSION}.zip && \
    mv IPAexfont${IPAEXFONT_VERSION}/*.ttf /usr/lib/ruby/gems/2.7.0/gems/asciidoctor-pdf-1.5.4/data/fonts/ && \
    fc-cache -fv && \
    apk add --no-cache nodejs nodejs-npm ca-certificates openssl grep patch && \
    patch -c -u /usr/lib/ruby/gems/2.7.0/gems/asciidoctor-pdf-1.5.4/data/themes/default-theme.yml < /tmp/default-theme.patch && \
    git clone --depth 1 -b master --single-branch ${ADOCTOR_STYLESHEET_FACTORY_URL} && \
    cd asciidoctor-stylesheet-factory && \
    npm i && \
    ./build-stylesheet.sh && \
    rm -rf /tmp/*

WORKDIR /documents