include .env

default-context := docker context use default;
ecs-context := docker use context ecscontext;
ecr-login := aws ecr get-login-password | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com;

push:
	$(default-context) \
	$(ecr-login) \
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml build;
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml push;

up:
	$(default-context) \
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up;

deploy:
	$(ecs-context) \
	docker compose -f docker-compose.yml up;
