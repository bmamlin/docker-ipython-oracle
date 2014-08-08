FROM ubuntu:14.04
MAINTAINER Burke Mamlin

# Build: docker build -t ipython .
# Run:   docker run -d -p 80:8080 --name ipython ipython

RUN apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes \
    git wget build-essential libaio1 libaio-dev alien python-dev \
    ipython ipython-notebook python-pip python-numpy python-scipy \
    python-matplotlib python-pandas python-sympy python-nose  \
    python-sklearn libsndfile-dev; \
  wget --no-check-certificate -q https://replace/with/link/to/oracle-instantclient11.2-basiclite-11.2.0.4.0-1.x86_64.rpm; \
  wget --no-check-certificate -q https://replace/with/link/to/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm; \
  alien -d *.rpm; \
  dpkg -i *.deb; \
  echo "/usr/lib/oracle/11.2/client64/lib" > /etc/ld.so.conf.d/oracle.conf; \
  pip install scikits.audiolab

ENV ORACLE_HOME /usr/lib/oracle/11.2/client64

ENV LD_LIBRARY_PATH /usr/lib/oracle/11.2/client64/lib

RUN ldconfig; \
  pip install cx_oracle; \
  pip install ipython-sql

ADD ./notebook/ /tmp/notebook/

EXPOSE 8080
ADD ./run.sh /run.sh
CMD /run.sh