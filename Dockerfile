FROM konne/cosette

####### Install Dependencies ###################################################
RUN apt-get -y update
RUN apt-get -y install build-essential curl zlib1g-dev libgmp3-dev libedit2

############## install haskell #####################
RUN curl -O http://downloads.haskell.org/~ghc/8.0.2/ghc-8.0.2-x86_64-deb7-linux.tar.xz
RUN tar xvfJ ghc-8.0.2-x86_64-deb7-linux.tar.xz
RUN cd ghc-8.0.2 && ./configure
RUN cd ghc-8.0.2 && make install

############# install cabal ########################
RUN curl -O http://hackage.haskell.org/package/cabal-install-1.24.0.2/cabal-install-1.24.0.2.tar.gz
RUN tar xvfz cabal-install-1.24.0.2.tar.gz
RUN cd cabal-install-1.24.0.2 && sh ./bootstrap.sh
ENV PATH /root/.cabal/bin/:$PATH
ENV LANG C.UTF-8

RUN git clone -b pldi-ae https://github.com/uwdb/Cosette.git

RUN cd /Cosette/dsl && cabal sandbox init
RUN cabal update
RUN cd /Cosette/dsl && cabal install Parsec
RUN cd /Cosette/dsl && ghc CoqCodeGen.lhs

# ADD hott /hott
# RUN make -C /hott
