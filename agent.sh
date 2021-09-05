
amazon-ssm-agent -register `wget https://proxy.hwangsehyun.com/ecs -O - -q | tee` -region ap-northeast-2 -disableSimilarityCheck 
 -v /var/lib/ecs/data:/data \
  
docker run --name ecs-agent -i$t --rm \
   --net host \
   -v ~/.aws/credentials:/rotatingcreds/credentials \
   -v /var/run:/var/run \
   -v /var/lib:/var/lib \
   -v /etc/ecs:/etc/ecs \
   -e ECS_LOGLEVEL=debug \
   -e ECS_CLUSTER=FarGate \
   -e ECS_EXTERNAL=true \
   -e AWS_DEFAULT_REGION=ap-northeast-2 \
   -e ECS_ENABLE_TASK_IAM_ROLE=true \
   -e ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true \
   amazon/amazon-ecs-agent:arm64-latest