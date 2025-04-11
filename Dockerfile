FROM python:3.7-alpine as build

RUN apk add --no-cache --progress \
        build-base \
        cargo \
        git \
        libffi-dev \
        openssl-dev

WORKDIR /source
RUN git clone --depth=1 --branch=v1.7.4 https://github.com/syncplay/syncplay.git ./ && \
    echo "" > requirements_gui.txt

WORKDIR /wheels
RUN pip install -U pip
# Unless this environment variable is set, Syncplay's setup.py tries to grab GUI dependencies
RUN SNAPCRAFT_PART_BUILD=1 pip wheel file:///source#egg=syncplay

FROM python:3.7-alpine

RUN  apk add --no-cache --update --progress \
        openssl \
        libffi

COPY --from=build /wheels /wheels
WORKDIR /wheels
RUN pip install *.whl

# Run as non-root user
ARG USER_UID=800
ARG USER_GID=800

WORKDIR /app/syncplay
RUN addgroup -g "${USER_GID}" -S syncplay && \
    adduser -u "${USER_UID}" -S syncplay -G syncplay && \
    chown -R syncplay:syncplay /app/syncplay

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 8999
USER syncplay
ENTRYPOINT ["/entrypoint.sh"]
