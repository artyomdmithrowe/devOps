# DevOps homework

## Структура проекта

```text
devOps/
├── ansible/
│   ├── roles/
│   │   └── common/
│   │       └── tasks/
│   │           └── main.yml
│   ├── inventory.ini
│   └── site.yml
├── compose/
│   ├── docker-compose.yml
│   ├── index.html
│   └── nginx.conf
├── scripts/
│   └── monitor.sh
├── terraform/
│   ├── .terraform.lock.hcl
│   └── main.tf
├── .gitignore
└── README.md
```

## Подготовка

Создать файл `.env` в корне проекта:

```bash
DEVOPS_SERVER_IP=адрес_сервера
```

Загрузить переменную в терминал:

```bash
set -a
source .env
set +a
```

## Запуск Ansible

```bash
ansible-playbook -i ansible/inventory.ini ansible/site.yml
```

## Запуск Terraform

```bash
terraform -chdir=terraform init
terraform -chdir=terraform apply -var="server_ip=$DEVOPS_SERVER_IP"

curl -i "http://$DEVOPS_SERVER_IP:8081"
```

## Запуск мониторинга

```bash
scp scripts/monitor.sh deployer@"$DEVOPS_SERVER_IP":/home/deployer/monitor.sh
ssh deployer@"$DEVOPS_SERVER_IP" "chmod +x /home/deployer/monitor.sh && /home/deployer/monitor.sh docker"
```

## Запуск Docker Compose на сервере

```bash
scp compose/* deployer@"$DEVOPS_SERVER_IP":/opt/app/
ssh deployer@"$DEVOPS_SERVER_IP" "cd /opt/app && docker compose up -d"

curl -i "http://$DEVOPS_SERVER_IP:8082"
```
