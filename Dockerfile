# syntax=docker/dockerfile:1.4

FROM docker.io/library/python:3.8-slim-buster

# Install dev dependencies
RUN apt-get update -qq \
    && apt-get upgrade -y \
    && apt-get autoremove -y \
    && apt-get install --no-install-recommends -y \
        curl \
        g++ \
        gcc \
        gettext \
        git \
        locales \
        locales-all \
        make \
        nano \
        openssh-client \
        rsync \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y

ENV PIPX_HOME="/opt/pipx/venvs"
ENV PIPX_BIN_DIR="/opt/pipx/bin"
ENV PATH="${PIPX_BIN_DIR}:${PATH}"

ENV PIP_VERSION="22.3"
ENV PIPX_VERSION="1.1.0"
ENV POETRY_VERSION="1.2.2"
ENV VIRTUALENV_VERSION="20.16.6"

# Use poetry for builds
RUN python3 -m pip install --no-cache-dir pip==${PIP_VERSION} pipx==${PIPX_VERSION} virtualenv==${VIRTUALENV_VERSION} \
    && python3 -m pipx install --pip-args=--no-cache-dir poetry==${POETRY_VERSION}

WORKDIR /app

COPY poetry.lock pyproject.toml src/ /app/