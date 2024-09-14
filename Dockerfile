ARG IMAGE_URL=ubuntu
ARG IMAGE_TAG=22.04

FROM ${IMAGE_URL}:${IMAGE_TAG}

ENV IN_CONTAINER=1

RUN apt-get -qy update && \
    apt-get -qy upgrade && \
    apt-get -qy install \
    locales \
    software-properties-common \
    sudo
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    tzdata && \
    apt-get clean
RUN locale-gen en_US.UTF-8

ARG GID=1000
ARG GROUPNAME=dev
RUN groupadd --gid ${GID} ${GROUPNAME}

ARG UID=1000
ARG USERNAME=dev
RUN adduser --system --gid ${GID} --uid ${UID} --disabled-password ${USERNAME}
RUN passwd -d ${USERNAME}
RUN usermod -aG sudo ${USERNAME}

ARG INSTALL_LOCATION=bootstrap
WORKDIR /home/${USERNAME}

COPY . ./${INSTALL_LOCATION}
WORKDIR /home/${USERNAME}/${INSTALL_LOCATION}
USER root
RUN chown -R ${UID}:${GID} /home/${USERNAME}/bootstrap
USER ${USERNAME}
RUN ./bootstrap \
    curl \
    git
RUN ./bootstrap \
    apt \
    brew
RUN ./bootstrap \
    bat \
    cl \
	gf2 \
    gh \
    golang \
    guile \
    npm \
    rust \
    ssh \
    tmux \
    tree \
	vim \
    zsh
RUN ./bootstrap \
    emacs
RUN sudo usermod --shell zsh ${USERNAME}
RUN /home/${USERNAME}/.local/brew/bin/brew cleanup --prune=all

USER root
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /home/${USERNAME}/.ssh
RUN chown -R ${UID}:${GID} /home/${USERNAME}/.ssh
USER ${USERNAME}

WORKDIR /home/${USERNAME}

CMD [ "zsh" ]

