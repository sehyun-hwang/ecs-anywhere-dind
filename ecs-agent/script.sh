set -e

echo "ecs-agent started waiting for ssm-agent"
nc -l 1234
echo 'ecs-agent detedted ssm-agent is running'

[ -t 0 ] && t=t
[ `uname -m` == aarch64 ] && TAG=:arm64-latest


docker rm -f ecs-agent || true

docker run --name ecs-agent -i$t \
--restart unless-stopped \
--net host \
-v ~/.aws/credentials:/rotatingcreds/credentials \
-v /var/run:/var/run \
-v /var/lib:/var/lib \
-v /etc/ecs:/etc/ecs \
-e ECS_CLUSTER=FarGate \
-e ECS_EXTERNAL=true \
-e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
-e ECS_ENABLE_TASK_IAM_ROLE=true \
-e ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true \
amazon/amazon-ecs-agent$TAG