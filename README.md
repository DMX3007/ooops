# Junior DevOps App

Небольшой инфраструктурный проект для демонстрации базовых DevOps-практик.

Проект включает:

* простое HTTP-приложение на Node.js / Express;
* Docker-контейнеризацию;
* запуск через Docker Compose;
* healthcheck приложения;
* backup конфигурации;
* Makefile для управления проектом;
* CI pipeline на GitHub Actions;
* мониторинг через Uptime Kuma.

## Requirements

Для запуска необходимы:

* Docker;
* Docker Compose v2;
* Make — опционально, для запуска команд через Makefile.

## Quick start

Самый простой способ запустить весь проект:

```bash
make build
make up
make ps
```

Проверить состояние контейнеров:

```bash
docker compose ps
```

или через также через Makefile (с полным перечнем команд можно ознакомится просто введя make в коммандной строке):

```bash
make ps
```

После запуска приложение доступно по адресу:

```text
http://localhost:8080
```

Health endpoint:

```text
http://localhost:8080/health
```

## Backup

В директории `config/` находится пример конфигурации приложения:

```text
config/app.conf
```

Скрипт резервного копирования архивирует директорию `config/` и сохраняет архивы в `backups/`.

Запустить backup:

```bash
./backup.sh
```

или:

```bash
make backup
```

Пример созданного файла:

```text
backups/config-2026-06-15-12-30-00.tar.gz
```

Скрипт:

* проверяет наличие директории `config`;
* создаёт `backups`, если она отсутствует;
* архивирует конфигурацию в `tar.gz`;
* добавляет дату и время в имя файла;
* сообщает об успешном завершении;
* возвращает ненулевой exit code при ошибке.

Созданные backup-файлы не добавляются в Git.

## Makefile

Для основных операций предусмотрен Makefile.

Посмотреть доступные команды:

```bash
make help
```

Основные команды:

```text
make build    Build Docker image
make up       Start services
make down     Stop services
make logs     Follow service logs
make ps       Show running services
make backup   Backup config directory
make hc       Check application health
```

## Monitoring

Для простого мониторинга используется Uptime Kuma.

После запуска Docker Compose веб-интерфейс доступен по адресу:

```text
http://localhost:3001
```

При первом запуске необходимо создать локального пользователя Uptime Kuma.

Затем можно добавить HTTP monitor со следующими параметрами:

```text
Monitor Type: HTTP(s)
Name: Junior DevOps App
URL: http://app:8080/health
```

Проверка позволяет отслеживать:

* доступность приложения;
* время ответа;
* историю успешных и неуспешных проверок;
* uptime HTTP endpoint `/health`.

## CI/CD

Pipeline расположен в:

```text
.github/workflows/ci.yml
```

CI запускается при push в `main` и при создании Pull Request.

Pipeline выполняет базовую проверку проекта:

1. получает исходный код;
2. собирает Docker image;
3. запускает контейнер;
4. ожидает запуска приложения;
5. проверяет `/health`;
6. завершает job с ошибкой, если приложение не отвечает.

## Reverse Proxy

Добавлен nginx, nginx.conf
