FROM registry.access.redhat.com/ubi8/ubi

# Install required system packages
RUN dnf install -y \
    python3 \
    python3-pip \
    gcc \
    python3-devel \
    rust \
    cargo \
    openssl-devel \
    openssh-server \
    openssh-clients \
    sudo && \
    dnf clean all

# Upgrade pip, setuptools and install dependencies
RUN pip3 install --upgrade pip setuptools && \
    pip3 install setuptools-rust cryptography==39.0.1 && \
    pip3 install ansible

# Create ansible user with sudo rights
RUN useradd -m ansible && \
    echo 'ansible:ansible' | chpasswd && \
    usermod -aG wheel ansible

# Setup SSH
RUN mkdir -p /var/run/sshd && \
    ssh-keygen -A

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

