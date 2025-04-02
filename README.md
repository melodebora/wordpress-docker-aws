# 🚀 Implantação de WordPress na AWS

Este projeto utiliza GitHub, AWS e Docker para implantar um ambiente WordPress escalável e monitorado na AWS, rodando sobre **Amazon Linux 2023 (AMI)**.

## 📌 Tecnologias Utilizadas

- **GitHub** → Documentação e versionamento
- **AWS** → Infraestrutura na nuvem
- **Amazon Linux 2023 (AMI)** → Sistema operacional da instância
- **Docker** → Contêiner do WordPress como servidor web
- **EFS (Elastic File System)** → Armazenamento de arquivos estáticos
- **RDS (MySQL)** → Banco de dados do WordPress
- **Load Balancer (ALB)** → Distribuição de tráfego
- **Auto Scaling Group (ASG)** → Escalabilidade automática
- **CloudWatch** → Monitoramento e logs

###  Linguagens: Bash e Markdown.

## 🎯 Objetivo

Criar uma instância AWS EC2 com Docker, rodando WordPress, integrando serviços de armazenamento, banco de dados, balanceamento de carga e monitoramento.

## 🔹 Etapas do Projeto

✅ Criar **VPC** e **EC2** com **Amazon Linux 2023**  
✅ Instalar **Docker** na EC2  
✅ Rodar **WordPress** com banco **RDS (MySQL)**  
✅ Configurar **EFS** para armazenar arquivos estáticos  
✅ Criar **Load Balancer** e **Auto Scaling Group**  
✅ Implementar **CloudWatch** para monitoramento  

---

## 🛠 1. Instalação e Configuração do Docker no EC2

### **Passo 1: Criar a Instância EC2**
- Criar uma instância **Amazon Linux 2023**
- Configurar **Security Groups**:
  - Porta **8080** → Acesso ao WordPress
  - Porta **3306** → Acesso ao MySQL (opcional, pode ser limitado ao Security Group)
  - Porta **2049** → Acesso ao EFS
  - Porta **22** → Acesso SSH

### **Passo 2: Instalar Docker e Docker Compose**

```sh
sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
```

Instalar **Docker Compose**:
```sh
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Verificar instalação:
```sh
docker --version
docker-compose --version
```

---

## 🏗 2. Deploy do WordPress e RDS (MySQL)

### **Passo 1: Criar um Banco de Dados RDS**
- Criar um banco **MySQL RDS**
- Definir um nome (ex: `db_wordpress`)
- Criar um usuário e senha (ex: `wordpress_user` / `senha123`)
- Configurar Security Group permitindo conexão da EC2

### **Passo 2: Criar um Arquivo `.env` para Credenciais**
Criar um arquivo `.env` para armazenar as credenciais do banco de dados de forma segura:
```sh
echo "DB_HOST=seu-endereco-rds.amazonaws.com" > .env
echo "DB_USER=wordpress_user" >> .env
echo "DB_PASSWORD=senha123" >> .env
echo "DB_NAME=db_wordpress" >> .env
```

### **Passo 3: Criar o Arquivo `docker-compose.yml`**

```yaml
version: '3.8'
services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress_app
    restart: always
    ports:
      - "8080:80"
    env_file:
      - .env
    environment:
      WORDPRESS_DB_HOST: $DB_HOST
      WORDPRESS_DB_USER: $DB_USER
      WORDPRESS_DB_PASSWORD: $DB_PASSWORD
      WORDPRESS_DB_NAME: $DB_NAME
    volumes:
      - wp-data:/var/www/html
      - efs:/var/www/html/wp-content/uploads

volumes:
  wp-data:
  efs:
    driver: local
    driver_opts:
      type: "nfs"
      o: "addr=seu-efs.amazonaws.com,nfsvers=4.1"
      device: ":/"
```

### **Passo 4: Subir os Containers**
```sh
docker-compose up -d
```

Verificar se o container está rodando:
```sh
docker ps
```

---

## 📂 3. Configurar AWS EFS para Armazenamento Estático

### **Passo 1: Criar um EFS (Elastic File System)**
- Criar um **EFS** na AWS
- Anexar ao **Security Group** da EC2
- Pegar o endpoint (ex: `fs-xxxxxx.efs.us-east-1.amazonaws.com`)

### **Passo 2: Montar o EFS na Instância EC2**
```sh
sudo yum install -y amazon-efs-utils
sudo mkdir -p /mnt/efs
sudo mount -t efs fs-xxxxxx:/ /mnt/efs
```

Adicionar ao `/etc/fstab` para montagem automática:
```sh
echo "fs-xxxxxx:/ /mnt/efs efs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
```

Reiniciar para testar:
```sh
sudo reboot
```

---

## 🌍 4. Configuração do Load Balancer

### **Passo 1: Criar um Application Load Balancer (ALB)**
- Criar um **ALB** na AWS
- Criar um **Target Group** apontando para a EC2 na porta **8080**
- Configurar **Regras do Listener** para encaminhar tráfego HTTP para o Target Group

### **Passo 2: Testar o Acesso**
Acesse pelo navegador usando o DNS do Load Balancer:
```
http://SEU-LOAD-BALANCER-DNS
```

---

## 🚀 5. Automação com `user_data.sh`
Para provisionamento automático ao iniciar a instância, adicionar este script no **User Data**:

```sh
#!/bin/bash
yum update -y
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

docker run -d --name wordpress -p 8080:80 \
  --env-file .env \
  wordpress:latest
```

---

## ✅ **Conclusão**
Agora, temos uma aplicação WordPress rodando em **Docker**, conectada ao **RDS (MySQL)**, armazenando arquivos estáticos no **EFS** e distribuindo tráfego via **Load Balancer**. 🎉

---

✍ **Criado por:** Débora de Melo Silva
