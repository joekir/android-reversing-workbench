FROM ubuntu:18.04

# UTF8 needed for mitmproxy
ENV LANG=en_CA.UTF-8

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    openjdk-11-jdk \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    wget \
    git \
    vim \
    sudo \
    python \
    python-pip \
    python3-pip \
    xdg-utils \
    unzip \
    android-sdk

RUN cd `mktemp -d` \
    && wget -nv https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -O apktool \
    && wget -nv https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.3.3.jar -O apktool.jar \
    && sudo mv apktool* /usr/local/bin/ \
    && sudo chmod +x /usr/local/bin/apktool* \
    && git clone --recursive https://github.com/androguard/androguard.git \
    && cd androguard \
    && pip3 install --user .[magic] \
    && wget -nv https://github.com/java-decompiler/jd-gui/releases/download/v1.4.0/jd-gui_1.4.0-0_all.deb -O jdgui.deb \
    && sudo mkdir /usr/share/desktop-directories \
    && dpkg -i jdgui.deb \
    && echo "java --add-opens java.base/jdk.internal.loader=ALL-UNNAMED \
        --add-opens jdk.zipfs/jdk.nio.zipfs=ALL-UNNAMED \
        -jar /opt/jd-gui/jd-gui.jar" > /usr/local/bin/jd-gui \
    && chmod +x /usr/local/bin/jd-gui \
    && mkdir /opt/jadx \
    && cd /opt/jadx \
    && wget -nv https://github.com/skylot/jadx/releases/download/v0.8.0/jadx-0.8.0.zip \
    && unzip jadx-0.8.0.zip \
    && rm jadx-0.8.0.zip \
    && ln -s /opt/jadx/bin/jadx /usr/local/bin/jadx \
    && ln -s /opt/scripts/apex.sh /usr/local/bin/apex \
    && cd /opt \
    && wget -nv https://github.com/pxb1988/dex2jar/releases/download/2.0/dex-tools-2.0.zip \
    && unzip dex-tools-2.0.zip \
    && chmod +x /opt/dex2jar-2.0/* \
    && chmod 655 /opt/dex2jar-2.0 \
    && ln -s ${PWD}/dex2jar-2.0/d2j-dex2jar.sh /usr/local/bin/dex2jar \
	  && python3 -m pip install --upgrade trio \
    && sudo pip3 install mitmproxy \
    && mkdir -p /root/.vim/syntax

COPY vendored/smali.vim /root/.vim/syntax/smali.vim
RUN echo 'autocmd BufRead,BufNewFile *.smali set filetype=smali' >> /root/.vimrc

# Set up a baked-in way to know which commit this image came from:
ARG SOURCE_URL
RUN echo $SOURCE_URL > /source_url

WORKDIR /tmp/samples
CMD ["bash"]
