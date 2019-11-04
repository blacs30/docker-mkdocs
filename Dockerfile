FROM alpine:3.10

ENV LIVE_RELOAD_SUPPORT="" \
DEV_MODE=""
ARG MKDOCS_VERSION="1.0.4"
ARG PLUGINS='mkdocs-material mkdocs-wavedrom-plugin mkdocs-exclude mkdocs-monorepo-plugin'

RUN \
apk add --update \
ca-certificates \
bash  \
python3 \
git  && \
if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
\
echo "**** install pip ****" && \
python3 -m ensurepip && \
rm -r /usr/lib/python*/ensurepip && \
pip3 install --no-cache --upgrade pip setuptools wheel && \
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
pip install mkdocs==${MKDOCS_VERSION} && \
pip install ${PLUGINS} && \
rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*; \
pip install git+https://gitlab.com/blacs30/mkdocs-edit-url.git
COPY container-files /
RUN chmod +x /bootstrap.sh && mkdir /workdir

WORKDIR /workdir

USER 1000
ENTRYPOINT ["/bootstrap.sh"]
