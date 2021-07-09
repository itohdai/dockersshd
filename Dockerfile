FROM ubi8
USER root

ENV \
    APP_ROOT=/opt/app-root \
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    PLATFORM="el8"
    
# OpenSSH サーバをインストールする
RUN dnf update -y && dnf clean all -y
RUN dng install -y openssh-server && dnf clean all -y

# sshでログインできるようにする 
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# root のパスワードを 設定
RUN echo 'root:rootpass' | chpasswd

# 使わないにしてもここに公開鍵を登録しておかないとログインできない 
RUN ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key

# sshd の使うポートを公開する
EXPOSE 22

# sshd を起動する
CMD ["/usr/sbin/sshd", "-D"]
