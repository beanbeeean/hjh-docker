FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noniteractive

ENV TZ Asia/Seoul
ENV PYTHONIOENCODING UTF-8
ENV LC_CTYPE C.UTF-8

WORKDIR /root

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN apt-get install -y  unzip
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm awscliv2.zip && \
    rm -rf aws

RUN apt-get install cron
RUN apt-get install -y vim
RUN apt-get install -qq -y init systemd
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y  python3.7
RUN apt-get install -y  fontconfig openjdk-17-jre
RUN wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian/jenkins.io-2023.key
RUN echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ |  tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
RUN echo "Acquire::Check-Valid-Until \"false\";\nAcquire::Check-Date \"false\";" | cat > /etc/apt/apt.conf.d/10no--check-valid-until
RUN apt-get update
RUN apt-get install -y jenkins
RUN apt-get install -qq -y init systemd
RUN systemctl mask systemd

COPY run_check.sh /root/run_check.sh
RUN chmod 0777 /root/run_check.sh
COPY crontab /etc/crontab

RUN curl -s https://get.docker.com | sh

RUN usermod -aG docker jenkins

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/sbin/init"]
ENTRYPOINT service jenkins start && service cron start && service docker start && bash
