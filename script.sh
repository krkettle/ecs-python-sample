#!/bin/zsh
project_name="ecs-python-sample"

setup() {
  # AWS認証情報を.envファイルへ出力
  cat <<EOF > .env
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
EOF
  # ECSコンテキストの作成
  docker context create ecs ecscontext --profile default

  # ECRの作成
  aws ecr create-repository --repository-name $project_name > /dev/null

  # サンプルファイルをS3へアップロード
	aws s3 mb s3://docker-python-sample-bucket
	curl http://worldtimeapi.org/api/timezone/Asia/Tokyo > sample.json
	aws s3 cp sample.json s3://docker-python-sample-bucket/sample.json
  echo Setup is done.
}

teardown() {
  docker context rm ecscontext
  aws ecr batch-delete-image --repository-name $project_name --image-ids imageTag=latest > /dev/null
  aws ecr delete-repository --repository-name $project_name
  aws s3 rm s3://docker-python-sample-bucket/sample.json
  aws s3 rb s3://docker-python-sample-bucket
  rm .env
  rm sample.json
  echo Teardown is done.
}

"$@"

