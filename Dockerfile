FROM buildpack-deps:stretch-scm
MAINTAINER Alexander Merkulov <sasha@merqlove.ru>

ENV DEBIAN_FRONTEND noninteractive

ENV LIBBOOST_DEP "1.62.0"
ENV LIBBOOST "1.62"
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
RUN apt-get install -qqy automake autoconf libtool make g++ wget swig \
                       libicu$LIBICU libboost-regex$LIBBOOST_DEP \
                       libboost-system$LIBBOOST_DEP libboost-program-options$LIBBOOST_DEP \
                       libboost-thread$LIBBOOST_DEP libboost-filesystem$LIBBOOST_DEP && \
    apt-get install -qqy $BUILD_DEV

# Install Freeling
ENV FREELING_SRC "archive/$VERSION.tar.gz"
WORKDIR /tmp
RUN wget -q --progress=dot:giga https://github.com/TALP-UPC/FreeLing/$FREELING_SRC
ENV FREELING_ARCHIVE "FreeLing-$VERSION"
RUN tar -xzf "$VERSION.tar.gz"

WORKDIR /tmp/$FREELING_ARCHIVE

ENV FREELING_SHARE data

ENV DATA_LANG_RM $FREELING_SHARE/as \
    $FREELING_SHARE/ca \
    $FREELING_SHARE/cs \
    $FREELING_SHARE/cy \
    $FREELING_SHARE/de \
    $FREELING_SHARE/es \
    $FREELING_SHARE/fr \
    $FREELING_SHARE/gl \
    $FREELING_SHARE/hr \
    $FREELING_SHARE/nb \
    $FREELING_SHARE/it \
    $FREELING_SHARE/pt \
    $FREELING_SHARE/sl

RUN rm -rf $DATA_LANG_RM

RUN autoreconf --install && \
    ./configure --prefix=/usr && \
    make

RUN rm -rf $DATA_LANG_RM

RUN apt-get install -qqy checkinstall

RUN make install

RUN checkinstall -y \
      --pkgsource="https://github.com/TALP-UPC/FreeLing/" \
      --pkglicense="GPL" \
      --deldesc=no \
      --backup=no \
      --nodoc \
      --addso \
      --install=no \
      --maintainer="Alexander Merkulov\\<api@cnsa.ru\\>" \
      --pkgarch=$(dpkg \
      --print-architecture) \
      --pkgname=freeling \
      --exclude="$DATA_LANG_RM" \
      --provides="freeling,libfreeling,libtreeler,libfoma" \
      --requires="libstdc++6 \(\>=4.6.3\),libgcc1 \(\>=4.6.3\),libc6 \(\>=2.13\),zlib1g \(\>=1.2.3\),libboost-program-options$LIBBOOST_DEP \(\>=$LIBBOOST\),libboost-regex$LIBBOOST_DEP \(\>=$LIBBOOST\),libboost-filesystem$LIBBOOST_DEP \(\>=$LIBBOOST\),libboost-system$LIBBOOST_DEP \(\>=$LIBBOOST\),libicu$LIBICU \(\>=$LIBICU_DEP\),zlib1g \(\>=1.2.3.4\)"
