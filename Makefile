.PHONY: bootstrap deploy ping vault-encrypt vault-edit

# Переменные по умолчанию (можно переопределить: make deploy TAG=v1.0)
TAG ?= latest

ping:
	ansible all -m ping

# Первый запуск на чистом сервере (порт 22, пароль или root ключ)
# Пример: make bootstrap
bootstrap:
	ansible-playbook provisioning/bootstrap.yml

# Основной деплой инфраструктуры (порт 15022)
deploy:
	ansible-playbook provisioning/site.yml

# Обновление только конфигураций стеков (быстрый деплой)
deploy-stacks:
	ansible-playbook provisioning/site.yml --tags "stack"

# Утилиты для шифрования секретов (если понадобятся)
vault-encrypt:
	ansible-vault encrypt provisioning/inventory/group_vars/vault.yml

vault-edit:
	ansible-vault edit provisioning/inventory/group_vars/vault.yml
