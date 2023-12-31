FROM ubuntu:18.04

# Install several additional components and Python libs:
#  - Py3o Fusion server,
#  - Py3o render server,
#  - a Java Runtime Environment (JRE), which can be OpenJDK,
#  - Libreoffice started in the background in headless mode,
#  - the Java driver for Libreoffice (Juno).
# https://apps.odoo.com/apps/modules/16.0/report_py3o_fusion_server/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
		# Installation of Libreoffice, JRE and required Java libs on Debian/Ubuntu:
		# default-jre \
		openjdk-8-jre \
		ure \
		libgoogle-gson-java \
		libreoffice-java-common \
		libreoffice-writer \
		# Init system
 		locales \
 		language-pack-en \
		python-pip \
		supervisor \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

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

# py3o fusion / py3o server
ADD wheelhouse /usr/local/wheelhouse
RUN pip install \
	--upgrade \
	--use-wheel \
	--no-index \
	--find-links=file:///usr/local/wheelhouse/py3o/ \
	-r  /usr/local/src/pip_requirements.txt \
	--system

# Install fonts
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
		# Google Fonts - https://fonts.google.com/noto
		fonts-noto-cjk \
		# To have the special unicode symbols for phone/fax/email in the PDF reports generated by Py3o.
		fonts-symbola \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Install msttcorefonts
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
	# =================================================
	# END-USER LICENSE AGREEMENT FOR MICROSOFT SOFTWARE
	#        https://corefonts.sourceforge.net/eula.htm
	# =================================================
	# https://askubuntu.com/questions/16225/how-can-i-accept-the-microsoft-eula-agreement-for-ttf-mscorefonts-installer#answer-25614
	&& echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
    && apt-get -y install --no-install-recommends \
		# If your document template uses the Arial font, you should install that font on your Odoo server.
		msttcorefonts \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Japanese fonts
# ###################################
#   IPA FONT LICENSE AGREEMENT V1.0
# https://moji.or.jp/ipafont/license/
# ###################################
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
		unzip \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*
ADD archiveipa /usr/local/archiveipa
RUN cd /usr/local/archiveipa \
	# IPAmj Mincho Font
    && unzip ipamjm00601.zip -d /usr/share/fonts/truetype/ipamjm0601 \
    # IPAex Font（2 fonts）
    && unzip IPAexfont00401.zip -d /usr/share/fonts/truetype/ipaexfont00401 \
    # IPA Font（4 fonts）
    && unzip IPAfont00303.zip -d /usr/share/fonts/truetype/ipafont00303 \
    # Build font information cache files
    && fc-cache -vf

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/supervisord.conf", "-n"]
