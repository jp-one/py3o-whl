FROM ubuntu:18.04
LABEL maintainer="release@xcg-consulting.fr"
ARG BUILD_DATE=""
ARG VCS_URL=""
ARG VCS_REF=""
ARG VERSION=""
LABEL org.opencontainers.image.revision=$VERSION
LABEL org.opencontainers.image.vendor="XCG"
LABEL org.opencontainers.image.version=$VCS_REF
LABEL org.opencontainers.image.authors="XCG"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.title="Libreoffice py3o"
LABEL org.opencontainers.image.description="A headless libreoffice py3o server"
LABEL org.opencontainers.image.source=$VCS_URL

ENV DEBIAN_FRONTEND noninteractive

RUN set -x ; \
	apt-get update \
	&& apt-get -y -q install \
		# Libreoffice
		libreoffice \
		libreoffice-writer \
		ure \
		libreoffice-java-common \
		libreoffice-core \
		libreoffice-common \
		openjdk-8-jre \
		fonts-opensymbol \
		hyphen-fr \
		hyphen-de \
		hyphen-en-us \
		hyphen-it \
		hyphen-ru \
		fonts-dejavu \
		fonts-dejavu-core \
		fonts-dejavu-extra \
		fonts-noto \
		fonts-dustin \
		fonts-f500 \
		fonts-fanwood \
		fonts-freefont-ttf \
		fonts-liberation \
		fonts-lmodern \
		fonts-lyx \
		fonts-sil-gentium \
		fonts-texgyre \
		fonts-tlwg-purisa \
		# py3o fusion
		locales \
		python-setuptools \
		python-pip \
		libxml2 \
		language-pack-fr \
		language-pack-en \
		language-pack-ru \
		language-pack-it \
		language-pack-de \
		language-pack-es \
		language-pack-pt \
		# py3o server
		libgoogle-gson-java \
		# Init system
		supervisor \
	&& apt-get -q -y remove libreoffice-gnome libreoffice-gtk3 \
	&& apt-get clean \
	&&  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# replace default setup with a one disabling logos by default
ADD overlay /

# Libreoffice
# EXPOSE 8997
# py3o fusion
EXPOSE 8765
# py3o server
# EXPOSE 8994

# Libreoffice
RUN adduser --system --disabled-password --gecos "" --shell=/bin/bash libreoffice

ADD wheelhouse /usr/local/wheelhouse

# py3o fusion / py3o server
RUN pip install \
	--upgrade \
	--use-wheel \
	--no-index \
	--find-links=file:///usr/local/wheelhouse/py3o/ \
	-r  /usr/local/src/pip_requirements.txt \
	--system

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/supervisord.conf", "-n"]
