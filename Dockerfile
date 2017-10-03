FROM buildpack-deps:stretch-scm
MAINTAINER Alexander Merkulov <sasha@merqlove.ru>

ENV DEBIAN_FRONTEND noninteractive

ENV LIBBOOST "1.62"
ENV LIBBOOST_DEP "$LIBBOOST.0"
ENV LIBICU 57
ENV LIBICU_DEP "$LIBICU.0"
ENV VERSION "4.0"

RUN apt-get -qq update

# Language setup
RUN apt-get -qqy install locales && \
# Configure timezone and locale
    echo "Europe/Moscow" > /etc/timezone; dpkg-reconfigure locales && \
    sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=ru_RU.UTF-8 && \
    echo "LANGUAGE=ru_RU.UTF-8" >> /etc/default/locale && \
    echo "LC_ALL=ru_RU.UTF-8" >> /etc/default/locale

ENV BUILD_DEV libicu-dev libboost-regex-dev libboost-system-dev \
                   libboost-program-options-dev libboost-thread-dev \
                   zlib1g-dev

# Freeling Deps
RUN apt-get install -qqy automake autoconf libtool make checkinstall g++ wget swig \
                       libicu$LIBICU libboost-regex$LIBBOOST_DEP \
                       libboost-system$LIBBOOST_DEP libboost-program-options$LIBBOOST_DEP \
                       libboost-thread$LIBBOOST_DEP libboost-filesystem$LIBBOOST_DEP && \
    apt-get install -qqy $BUILD_DEV

# Install Freeling
ENV FREELING_SRC_FILE "$VERSION.tar.gz"
ENV FREELING_SRC "archive/$FREELING_SRC_FILE"
WORKDIR /tmp
RUN wget -q --progress=dot:giga https://github.com/TALP-UPC/FreeLing/$FREELING_SRC
ENV FREELING_ARCHIVE "FreeLing-$VERSION"
RUN tar -xzf "$VERSION.tar.gz"

WORKDIR /tmp/$FREELING_ARCHIVE

RUN autoreconf --install && \
    ./configure --prefix=/usr

RUN rm -f /tmp/$FREELING_SRC_FILE && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    apt-get purge
