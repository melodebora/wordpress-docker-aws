#!/bin/bash

# Atualiza o sistema e instala pacotes necessários
sudo yum update -y
sudo yum install -y docker wget amazon-efs-utils

# Inicia o serviço Docker e configura para iniciar automaticamente
sudo service docker start
sudo systemctl enable docker.service
sudo usermod -aG docker ec2-user

# Instala o Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Monta o Amazon EFS
sudo mkdir -p /wordpress
sudo mount -t efs -o tls fs-00d1605a6207546e8:/ /wordpress

# Verifica se a montagem foi bem-sucedida
if mountpoint -q /wordpress; then
    echo "EFS montado com sucesso em /wordpress"
else
    echo "Falha ao montar EFS"
fi

# Baixa o arquivo docker-compose.yml do seu repositório
wget -O /home/ec2-user/docker-compose.yml https://raw.githubusercontent.com/melodebora/wordpress-docker-aws/main/docker-compose.yml
sudo chown ec2-user:ec2-user /home/ec2-user/docker-compose.yml

# Inicia os containers definidos no docker-compose.yml
cd /home/ec2-user
sudo docker-compose -f /home/ec2-user/docker-compose.yml up -d
