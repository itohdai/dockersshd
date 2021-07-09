# sshd
#
# VERSION               0.0.2

FROM ubuntu:14.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN groupadd -g 1000 developer && \
    useradd  -g      developer -m -s /bin/bash devuser && \
    echo 'devuser:devdevdev12' | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

