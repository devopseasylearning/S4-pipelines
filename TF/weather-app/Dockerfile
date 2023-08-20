FROM ubuntu:22.04
RUN  apt update 
WORKDIR /a
RUN apt install -y  curl software-properties-common wget vim unzip
RUN wget -O- https://apt.releases.hashicorp.com/gpg |  gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg 
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |  tee /etc/apt/sources.list.d/hashicorp.list 
RUN  apt update &&  apt install terraform  -y
RUN terraform version 
CMD ["bash"] 
