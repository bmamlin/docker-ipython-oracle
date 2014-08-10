FROM ubuntu:14.04
MAINTAINER Burke Mamlin

# Build: docker build -t ipython .
# Run:   docker run -d -p 80:8080 --name ipython ipython

ENV ORACLE_HOME /usr/lib/oracle/11.2/client64

ENV LD_LIBRARY_PATH /usr/lib/oracle/11.2/client64/lib

ADD ./rpms/ /tmp/rpms/

RUN apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes \
    git wget build-essential libaio1 libaio-dev alien python-dev \
    ipython ipython-notebook python-pip python-numpy python-scipy \
    python-matplotlib python-pandas python-sympy python-nose  \
    python-sklearn libsndfile-dev openssh-server; \
  alien -d /tmp/rpms/*.rpm; \
  dpkg -i *.deb; \
  rm -rf /tmp/rpms/ ; \
  rm *.deb; \
  echo "/usr/lib/oracle/11.2/client64/lib" > /etc/ld.so.conf.d/oracle.conf; \
  pip install scikits.audiolab; \
  ldconfig; \
  pip install cx_oracle; \
  pip install ipython-sql ; \
  mkdir /var/run/sshd; \
  echo 'root:ipython' | chpasswd; \
  sed --in-place=.bak 's/without-password/yes/' /etc/ssh/sshd_config; \
  /usr/sbin/sshd

ADD ./notebook/ /tmp/notebook/

EXPOSE 22
EXPOSE 8080
ADD ./run.sh /run.sh
CMD /run.sh