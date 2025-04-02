#!/bin/bash

# Atualiza os pacotes do sistema
sudo yum update -y

# Instala pacotes necessários
sudo yum install -y ca-certificates wget amazon-efs-utils docker

# Inicia e habilita o serviço do Docker
sudo systemctl enable --now docker

# Adiciona o usuário ec2-user ao grupo docker (evita precisar de sudo)
sudo usermod -aG docker ec2-user

# Instala o Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Cria o diretório de montagem do EFS
sudo mkdir -p /data

# Monta o sistema de arquivos EFS (substitua pelo seu ID)
sudo mount -t efs -o tls fs-0a5c59d97e99b5b1b:/ /data

# Garante que o diretório pertence ao usuário correto
sudo chown ec2-user:ec2-user /data

# Criar diretório do projeto
mkdir -p /home/ec2-user/wordpress-docker && cd /home/ec2-user/wordpress-docker

# Criar arquivo docker-compose.yml
cat <<EOT > docker-compose.yml
version: '3.8'
services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: banco-wordpress.c3mg2isyqjgp.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: demelo
      WORDPRESS_DB_PASSWORD: w38389938
      WORDPRESS_DB_NAME: db_wordpress
    volumes:
      - wordpress:/var/www/html
volumes:
  wordpress:
EOT

# Garantir permissões corretas
chmod 644 docker-compose.yml

# Subir os containers com Docker Compose
sudo -u ec2-user --preserve-env docker-compose up -d
