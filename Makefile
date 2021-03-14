include .env

# params
e	= dev

ENV					= ${e}
ECS_CTX			= ecscontext
DEV_CTX_CMD	= docker context use default;
STG_CTX_CMD = docker context use $(ECS_CTX);

ENV_SET := \
	export ENV=$(ENV); \
	export COMPOSE_PATH_SEPARATOR=:; \
	export COMPOSE_FILE=docker-compose.yml:docker-compose.$(ENV).yml; \
	echo ENV is $(ENV);

.PHONY:	setup
setup:
	@docker context create ecs ecscontext; \
	aws s3 mb s3://docker-python-sample-bucket; \
	curl http://worldtimeapi.org/api/timezone/Asia/Tokyo > sample.json; \
	aws s3 cp sample.json s3://docker-python-sample-bucket/sample.json; \
	rm sample.json;

.PHONY:	build
build:
	@$(ENV_SET) \
	$(DEV_CTX_CMD) \
	docker-compose build --no-cache; \

.PHONY:	push
push:
	@$(ENV_SET) \
	$(DEV_CTX_CMD) \
	aws ecr get-login-password | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com; \
	docker-compose build --no-cache; \
	docker-compose push

.PHONY:	up
up:
ifeq ($(ENV), dev)
	@$(ENV_SET) \
	$(DEV_CTX_CMD) \
	docker-compose up -d
else
	@$(ENV_SET) \
	$(STG_CTX_CMD) \
	docker compose up
endif

.PHONY:	down
down:
ifeq ($(ENV), dev)
	@$(ENV_SET) \
	$(DEV_CTX_CMD) \
	docker-compose down
else
	@$(ENV_SET) \
	$(STG_CTX_CMD) \
	docker compose down
endif