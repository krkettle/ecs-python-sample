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
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d;

deploy:
	$(ecs-context) \
	docker compose -f docker-compose.yml up;

setup:
	docker context create ecs ecscontext; \
	aws s3 mb s3://docker-python-sample-bucket; \
	curl http://worldtimeapi.org/api/timezone/Asia/Tokyo > sample.json; \
	aws s3 cp sample.json s3://docker-python-sample-bucket/sample.json; \
	rm sample.json;