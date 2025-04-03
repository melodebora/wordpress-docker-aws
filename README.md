# 🚀 Implantação de WordPress na AWS  

## Introdução  

Este guia detalha o processo de implantação do **WordPress** em uma instância **EC2** na **AWS**, utilizando **Docker**. O objetivo é criar uma solução escalável, segura e de fácil manutenção, integrando diversos serviços da AWS.  

### **Vamos precisar configurar**  
- **EC2 + Docker** → Para hospedar o WordPress  
- **RDS (MySQL)** → Para armazenar os dados do site  
- **EFS (Elastic File System)** → Para manter arquivos compartilhados entre instâncias  
- **ALB (Application Load Balancer)** → Para distribuir o tráfego entre servidores  
- **ASG (Auto Scaling Group)** → Para escalabilidade automática  
- **CloudWatch** → Para monitoramento e logs  

### **Principais Etapas:**  
1. **Configuração da instância EC2** e instalação do Docker  
2. **Deploy do WordPress** com banco de dados RDS  
3. **Integração com EFS** para armazenamento de arquivos  
4. **Configuração do ALB** para balanceamento de carga  
5. **Automação do escalonamento** com ASG  

## Tecnologias Utilizadas  
- **GitHub** → Versionamento e documentação  
- **AWS** → Infraestrutura em nuvem  
- **Amazon Linux 2023 (AMI)** → Sistema operacional da instância  
- **Docker** → Contêinerização do WordPress  
- **EFS (Elastic File System)** → Armazenamento persistente  
- **RDS (MySQL)** → Banco de dados gerenciado  
- **Load Balancer (ALB)** → Distribuição de tráfego  
- **Auto Scaling Group (ASG)** → Escalabilidade automática  
- **CloudWatch** → Monitoramento e logs  

###  Linguagens: Bash e Markdown.

✅ Criar **VPC**

✅ Criar **Grupo de Segurança**

✅ Criar **Banco de Dados RDS**

✅ Criar **EC2**

✅ Instalar **Docker** na EC2  

✅ Rodar **WordPress** com banco **RDS (MySQL)**  

✅ Configurar **EFS** para armazenar arquivos estáticos  

✅ Criar **Load Balancer** e **Auto Scaling Group**  

✅ Implementar **CloudWatch** para monitoramento


## 🎯 Objetivo

Criar uma instância AWS EC2 com Docker, rodando WordPress, integrando serviços de armazenamento, banco de dados, balanceamento de carga e monitoramento.

## 🔹 Etapas do Projeto

✅ Criar **VPC**

![Image](https://github.com/user-attachments/assets/c052653c-2e60-4652-9574-b7ba04ec3a65)

✅ Criar **Grupo de Segurança**

![Image](https://github.com/user-attachments/assets/89e903f3-8364-407c-a4a5-09d13e242bc1)

✅ Criar **Banco de Dados RDS**

![Image](https://github.com/user-attachments/assets/ad37ef0e-b70d-4ad9-89cd-620e988421b1)

![Image](https://github.com/user-attachments/assets/881e48af-cfce-4399-821e-213efef9ee49)

![Image](https://github.com/user-attachments/assets/66e87221-9ad7-4dbd-b31d-8c379cdbb920)

![Image](https://github.com/user-attachments/assets/cbcd5d59-c896-4392-a4a7-3cf2b27f5b65)

✅ Criar **EC2** com **Amazon Linux 2023**  
![Image](https://github.com/user-attachments/assets/d4196bca-b512-4d36-8a9e-f1bb3876d0e1)


## 1. Instalação e Configuração do Docker no EC2 - Manualmente 

### **Passo 1: Criar a Instância EC2**
- Criar uma instância **Amazon Linux 2023**
- Configurar **Security Groups**:
  - Porta **8080** → Acesso ao WordPress
  - Porta **3306** → Acesso ao MySQL (opcional, pode ser limitado ao Security Group)
  - Porta **2049** → Acesso ao EFS
  - Porta **22** → Acesso SSH
![Image](https://github.com/user-attachments/assets/dd8a7e6c-278a-4237-bf9a-d4dcd6fa1e0d)

### **Passo 2: Instalar Docker e Docker Compose manualmente no caso de não utilização do userdata**

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
Ao realizar o processo as saidas que teremos inicialmente do acesso ao wordpress pela ec2 pelo navegador:

![Image](https://github.com/user-attachments/assets/4332dd48-b119-4596-a196-92a39bc0f8c0)

![Image](https://github.com/user-attachments/assets/17e8d641-27e6-4859-ad70-e6f86532540a)

![Image](https://github.com/user-attachments/assets/5aaf2762-e377-45ff-a569-09da001625a3)

consultando a existencia do banco

![Image](https://github.com/user-attachments/assets/ee998f19-063e-4ade-b335-9f4c48b86a0e)
---

##  2. Deploy do WordPress e RDS (MySQL)

### **Passo 1: Criar um Banco de Dados RDS**
- Criar um banco **MySQL RDS**
- Definir um nome (ex: `db_wordpress`)
- Criar um usuário e senha (ex: `demelo` / `senha123`)
- Configurar Security Group permitindo conexão da EC2

### **Passo 2: Criar o Arquivo `docker-compose.yml`**

```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: "banco-wordpress.c3mg2isyqjgp.us-east-1.rds.amazonaws.com"
      WORDPRESS_DB_USER: "demelo"
      WORDPRESS_DB_PASSWORD: "w38389938"
      WORDPRESS_DB_NAME: "db_wordpress"
    volumes:
      - wordpress:/var/www/html

volumes:
  wordpress:
```

### **Passo 3: Subir os Containers**
```sh
docker-compose up -d
```

Verificar se o container está rodando:
```sh
docker ps
```

---

## 3. Configurar AWS EFS para Armazenamento Estático

### **Passo 1: Criar um EFS (Elastic File System)**
- Criar um **EFS** na AWS
- Anexar ao **Security Group** da EC2
- Pegar o endpoint (ex: `fs-xxxxxx.efs.us-east-1.amazonaws.com`)
![Image](https://github.com/user-attachments/assets/0751f2b1-d5b1-408b-9667-6b82024d2494)

![Image](https://github.com/user-attachments/assets/8ba87fa1-d38e-44da-bdfe-38a8432b2cfe)

### **Passo 2: Montar o EFS na Instância EC2**
```sh
sudo yum install -y amazon-efs-utils
sudo mkdir -p /mnt/efs
sudo mount -t efs fs-xxxxxx:/ /mnt/efs
```
![Image](https://github.com/user-attachments/assets/8ba87fa1-d38e-44da-bdfe-38a8432b2cfe)
Adicionar ao `/etc/fstab` para montagem automática:
```sh
echo "fs-xxxxxx:/ /mnt/efs efs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
```

Reiniciar para testar:
```sh
sudo reboot
```

![Image](https://github.com/user-attachments/assets/1e587cf0-4912-4e9c-91df-2fe8e247eee1)
---

## 4. Configuração do Load Balancer

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

## 5. Automação com `user_data.sh`
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

## 📌 Conclusão  
A implantação do **WordPress** na **AWS** utilizando **Docker** e serviços gerenciados proporciona uma infraestrutura altamente escalável, segura e resiliente. O **RDS (MySQL)** garante um banco de dados otimizado, enquanto o **EFS** permite o armazenamento centralizado de arquivos, assegurando que múltiplas instâncias compartilhem os mesmos dados. O **ALB** melhora a disponibilidade e o desempenho da aplicação, distribuindo o tráfego de forma eficiente, enquanto o **Auto Scaling Group** ajusta automaticamente os recursos conforme a demanda. 

Além disso, com a monitoração via **CloudWatch**, conseguimos acompanhar o desempenho do ambiente e responder rapidamente a qualquer necessidade de ajuste. Essa abordagem não apenas melhora a confiabilidade da aplicação, mas também otimiza custos ao escalar os recursos de acordo com o tráfego real. 

Com essa infraestrutura, o **WordPress** está pronto para crescer junto com o seu projeto, garantindo alto desempenho, estabilidade e facilidade de gerenciamento. Agora, sua aplicação pode operar com eficiência em qualquer cenário! 🚀


