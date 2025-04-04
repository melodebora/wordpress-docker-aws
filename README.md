# 🚀 Implantação de WordPress com Docker na AWS  

## Introdução  

Este projeto tem como intuito detalhar o processo de implantação do **WordPress** em uma instância **EC2** na **AWS**, utilizando **Docker**. O objetivo é criar uma solução escalável, segura e de fácil manutenção, integrando diversos serviços da AWS.  

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

### **Tecnologias Utilizadas**

- **GitHub** → Versionamento e documentação  
- **AWS** → Infraestrutura em nuvem  
- **Amazon Linux 2023 (AMI)** → Sistema operacional da instância  
- **Docker** → Contêinerização do WordPress  
- **EFS (Elastic File System)** → Armazenamento persistente  
- **RDS (MySQL)** → Banco de dados gerenciado  
- **Load Balancer (ALB)** → Distribuição de tráfego  
- **Auto Scaling Group (ASG)** → Escalabilidade automática  
- **CloudWatch** → Monitoramento e logs  

### **Linguagens:**

- **Bash**  
- **Markdown**

### **Passos a seguir:**

1. Criar **VPC**  
2. Criar **Grupo de Segurança**  
3. Criar **Banco de Dados RDS**  
4. Criar **EC2**  
5. Instalar **Docker** na EC2  
6. Rodar **WordPress** com banco **RDS (MySQL)**  
7. Configurar **EFS** para armazenar arquivos estáticos  
8. Criar **Load Balancer** e **Auto Scaling Group**  
9. Implementar **CloudWatch** para monitoramento



## 🎯 Objetivo

Criar uma instância AWS EC2 com Docker, rodando WordPress, integrando serviços de armazenamento, banco de dados, balanceamento de carga e monitoramento.

## 🔹 Etapas do Projeto

✅ Criar **VPC**

![Image](https://github.com/user-attachments/assets/c052653c-2e60-4652-9574-b7ba04ec3a65)

✅ Criar **Os Grupos de Segurança**

Aqui temos uma visão geral dos grupos utilizados no proceso:

![Image](https://github.com/user-attachments/assets/f424115b-24c6-4dc0-9bc3-7a66e48269d3)


✅ Criação do grupo de segurança do load balncer - suas entradas
![Image](https://github.com/user-attachments/assets/f41c08f4-8538-401e-92a9-a294ba013322)

✅ Criação do grupo de segurança do load balncer - suas saidas

![Image](https://github.com/user-attachments/assets/129c68ca-7b66-4ef0-b3b9-a63a42a34123)

✅ Criação do grupo de segurança das intancias EC2 - suas entradas

![Image](https://github.com/user-attachments/assets/e2490cd8-9545-4ca6-956c-cc248ec6c0b9)

✅ Criação do grupo de segurança das intancias EC2 - suas saidas

![Image](https://github.com/user-attachments/assets/32af0a44-06f2-4f36-8176-0d520d83c7b2)

✅ Criação do grupo de segurança do EFS - suas entradas
![Image](https://github.com/user-attachments/assets/dccfe48b-acf6-4635-b41a-5334f4cae97f)

✅ Criação do grupo de segurança do EFS - suas saidas

![Image](https://github.com/user-attachments/assets/ebc37f1b-029d-40b7-8fbc-98eef473e956)

✅ Criação do grupo de segurança do RDS - suas entradas

![Image](https://github.com/user-attachments/assets/830214e3-04a3-484d-8a68-67fe77868378)

✅ Criação do grupo de segurança do RDS - suas saidas

![Image](https://github.com/user-attachments/assets/8d842805-f266-464f-b9e7-ae28ffec38d2)

✅ Criar **Banco de Dados RDS**

![Image](https://github.com/user-attachments/assets/ad37ef0e-b70d-4ad9-89cd-620e988421b1)

![Image](https://github.com/user-attachments/assets/881e48af-cfce-4399-821e-213efef9ee49)

![Image](https://github.com/user-attachments/assets/66e87221-9ad7-4dbd-b31d-8c379cdbb920)

![Image](https://github.com/user-attachments/assets/cbcd5d59-c896-4392-a4a7-3cf2b27f5b65)

✅ Criar **EC2** com **Amazon Linux 2023**  
![Image](https://github.com/user-attachments/assets/d4196bca-b512-4d36-8a9e-f1bb3876d0e1)

---

# Acessando a nossa EC2 via SSH e Instalar Docker e Docker Compose Manualmente

Após criar a instância EC2, siga os passos abaixo para acessar a instância via SSH e instalar o Docker e o Docker Compose manualmente, caso você não tenha utilizado o `userdata` para automatizar a instalação.

## Passo 1: Acessar a instância EC2 via SSH

1. Abra o terminal ou prompt de comando no seu computador.
2. Conecte-se à instância EC2 utilizando o comando SSH, substituindo `seu-arquivo.pem` pela chave privada que você gerou ao criar a instância e `ec2-user@seu-ip-publico` pelo usuário e IP público da sua instância EC2:

   ```bash
   ssh -i /caminho/para/seu-arquivo.pem ec2-user@seu-ip-publico
   ```

## Passo 2: Instalar Docker e Docker Compose Manualmente

Caso você não tenha utilizado o `userdata` para automatizar a instalação, siga os passos abaixo:

1. Atualize os pacotes da instância EC2:

   ```bash
   sudo yum update -y
   ```

2. Instale o Docker:

   ```bash
   sudo yum install docker -y
   ```

3. Habilite o Docker para iniciar automaticamente no boot:

   ```bash
   sudo systemctl enable docker
   ```

4. Inicie o serviço Docker:

   ```bash
   sudo systemctl start docker
   ```

5. Adicione o usuário `ec2-user` ao grupo `docker` para permitir que o usuário execute comandos Docker sem precisar de privilégios de root:

   ```bash
   sudo usermod -aG docker ec2-user
   ```

6. Instale o Docker Compose:

   ```bash
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

## Passo 3: Verificar a instalação

Verifique se o Docker foi instalado corretamente:

   ```bash
   docker --version
   ```

Verifique a versão do Docker Compose:

   ```bash
   docker-compose --version
   ```

Agora você terá o Docker e o Docker Compose instalados na sua instância EC2, prontos para serem usados!


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
services:
  web:
    image: wordpress
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db-wordpress.c3mg2isyqjgp.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: demelo
      WORDPRESS_DB_PASSWORD: w38389938
      WORDPRESS_DB_NAME: banco_wordpress_db
    volumes:
      - /wordpress:/var/www/html
    networks:
      - tunel

networks:
  tunel:
    driver: bridge
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

Eu configurei um sistema de arquivos Amazon EFS com o ID fs-0fc75c2af2c0ecf97 na minha VPC wordpress-vpc. Criei dois destinos de montagem, um para cada zona de disponibilidade (us-east-1a e us-east-1b), e conectei minhas instâncias EC2 através de sub-redes específicas e o grupo de segurança EC2-sg. Assim, garanti que minhas instâncias EC2 possam acessar o EFS de forma segura e redundante.

![Image](https://github.com/user-attachments/assets/42d42cb5-34bc-4a4f-9e82-d8bda48311e9)

### **Passo 1: Criar um EFS (Elastic File System)**
- Criar um **EFS** na AWS
- Anexar ao **Security Group** da EC2
- Pegar o endpoint (ex: `fs-xxxxxx.efs.us-east-1.amazonaws.com`)


### **Passo 2: Montar o EFS na Instância EC2 em um cenario feito manualmente**
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

## 4. Configuração do Load Balancer

![Image](https://github.com/user-attachments/assets/f11ec79e-c862-46be-a341-b97de33c0619)

### **Passo 2: Testar o Acesso**
Acesse pelo navegador usando o DNS do Load Balancer:

```
http://SEU-LOAD-BALANCER-DNS
```

![Image](https://github.com/user-attachments/assets/9f7a9fba-7750-4f3a-b437-b17f37a2ebea)

![Image](https://github.com/user-attachments/assets/015dc5ff-b949-4cb8-8a87-a1f128b47f6a)

![Image](https://github.com/user-attachments/assets/fba80f14-e7d7-4699-a583-1ccfee30d597)

![Image](https://github.com/user-attachments/assets/ac806a4f-72fc-4f61-bafd-f03db82eff94)

![Image](https://github.com/user-attachments/assets/b292e7e8-1378-4779-8273-6a8cd3573694)

![Image](https://github.com/user-attachments/assets/dd46c125-5622-49de-8a2e-adce05ccb4ad)



## Etapas de Configuração do Auto Scaling

1. **Escolher o modelo de execução**  
   Defina o nome do grupo (ex.: `APRESENTAR-ASG`) e escolha um modelo de execução com configurações como AMI, tipo de instância, par de chaves e grupos de segurança.

![Image](https://github.com/user-attachments/assets/8b88b607-e5a7-4621-9559-13bfbfafa541)

2. **Opções de execução de instância**  
   Selecione as opções adequadas para as instâncias EC2 do Auto Scaling.
   
![Image](https://github.com/user-attachments/assets/ab99f874-1da7-42c4-a419-61fcc090fb34)

3. **Integrar com outros serviços**  
   
![Image](https://github.com/user-attachments/assets/aecf2f76-ac9f-4443-a4bc-725bdec0cd85)
![Image](https://github.com/user-attachments/assets/9378d042-bd68-45c6-a75a-9627598fd8b4)
4. **(Opcional) Configurar ajuste de escala**  
   Defina o número mínimo, máximo e desejado de instâncias.
![Image](https://github.com/user-attachments/assets/639effdd-dc49-4c34-8f96-ae98e629b4a9)
![Image](https://github.com/user-attachments/assets/af32dc31-f227-48e2-b11b-f30f65a57f16)
5. **(Opcional) Adicionar notificações**  
   Configure alertas sobre eventos de Auto Scaling.

6. **(Opcional) Adicionar etiquetas**  
   Organize os recursos com etiquetas.
![Image](https://github.com/user-attachments/assets/96babdb2-c69b-4440-a5d6-630fd6e80447)
7. **Análise**  
   Revise as configurações antes de criar o grupo.
![Image](https://github.com/user-attachments/assets/3db35fc1-6337-4c77-9432-96eb2a7fdcda)
![Image](https://github.com/user-attachments/assets/e8c9d819-1770-4587-89af-f1e705a0830b)

---

### Modelo de Execução

- **Modelo de execução**: Selecione um modelo (ex.: `modelo-base`).
- **Versão**: Escolha a versão (ex.: `Latest (3)`).
- **Criar nova versão**: Adicione uma descrição se necessário.
![Image](https://github.com/user-attachments/assets/0920be09-ac79-488b-9e60-b35855609aa3)

![Image](https://github.com/user-attachments/assets/ba6e6a15-a272-4a73-af55-9e685751d677)

Criar um CloudWatch baseado em um Auto Scaling Group envolve configurar o monitoramento das instâncias EC2 usando o CloudWatch, que coleta métricas como utilização de CPU. Alarmes podem ser criados para disparar ações, como adicionar ou remover instâncias, com base nessas métricas. Isso permite que o Auto Scaling Group ajuste automaticamente a escala de instâncias para atender à demanda, garantindo eficiência e otimização de recursos.

![Image](https://github.com/user-attachments/assets/c3606c79-8e45-48a7-9347-ea2e4d737b4b)

![Image](https://github.com/user-attachments/assets/f796df9d-6393-4f8e-bedc-dd4e06ebb691)

![Image](https://github.com/user-attachments/assets/cf859d34-62e1-4264-9bc8-2bbaf0eba1c0)

![Image](https://github.com/user-attachments/assets/5435e22e-0565-4a30-bc85-87d2bdd3d24b)

---

## 5. Automação com `user_data.sh`
Para provisionamento automático ao iniciar a instância, adicionar este script no **User Data**:

```sh
#!/bin/bash

# Atualiza o sistema e instala pacotes necessários
sudo yum update -y
sudo yum install -y docker wget amazon-efs-utils

# Inicia o serviço Docker e configura para iniciar automaticamente
sudo service docker start
sudo systemctl enable docker.service
sudo usermod -aG docker ec2-user

# aqui eu instalo o Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# faço a montagem no Amazon EFS
sudo mkdir -p /wordpress
sudo mount -t efs -o tls fs-00d1605a6207546e8:/ /wordpress

# Baixa o arquivo docker-compose.yml do seu repositório
wget -O /home/ec2-user/docker-compose.yml https://raw.githubusercontent.com/melodebora/wordpress-docker-aws/main/docker-compose.yml
sudo chown ec2-user:ec2-user /home/ec2-user/docker-compose.yml

# Inicia os containers definidos no docker-compose.yml
cd /home/ec2-user
sudo docker-compose -f /home/ec2-user/docker-compose.yml up -d

```

---

## 📌 Conclusão  

Essa proposta de projeto apresenta a implantação do **WordPress** na **AWS** utilizando **Docker** e serviços gerenciados, oferecendo uma infraestrutura altamente escalável, segura e resiliente.

- O **RDS (MySQL)** garante um banco de dados otimizado.
- O **EFS** permite o armazenamento centralizado de arquivos, assegurando que múltiplas instâncias compartilhem os mesmos dados.
- O **ALB (Application Load Balancer)** melhora a disponibilidade e o desempenho da aplicação, distribuindo o tráfego de forma eficiente.
- O **Auto Scaling Group** ajusta automaticamente os recursos conforme a demanda.

Além disso, com a monitoração via **CloudWatch**, conseguimos acompanhar o desempenho do ambiente e responder rapidamente a qualquer necessidade de ajuste.

O que aprendemos ao longo da trilha é que essa abordagem não apenas melhora a confiabilidade da aplicação, mas também otimiza custos ao escalar os recursos conforme o tráfego real, ou seja, as necessidades de um possível ambiente existente no cenário tecnológico.

Com essa infraestrutura, o **WordPress** está pronto para operar conforme as necessidades do projeto, garantindo alto desempenho, estabilidade e facilidade de gerenciamento. 🚀
