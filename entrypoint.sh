set -e

AWS_DEFAULT_REGION=ap-northeast-2
SSM_REGISTRATION_FILE=/var/lib/amazon/ssm/Vault/Store/RegistrationKey

if [ -f $SSM_REGISTRATION_FILE ]; then
    echo "Already registed to SSM"
    cat $SSM_REGISTRATION_FILE
else
    amazon-ssm-agent -register `wget https://proxy.hwangsehyun.com/ecs -O - -q | tee` -region ap-northeast-2 -disableSimilarityCheck #$AWS_DEFAULT_REGION
    echo "Registed"
    systemctl enable --now amazon-ssm-agent
fi


systemctl &

rm /var/run/docker.pid || true
dockerd &

until docker version; do
  sleep 1
done

[ -t 0 ] && t=t
[ `uname -m` == aarch64 ] && TAG=:arm64-latest


docker run --name ecs-agent -i$t --rm \
   --net host \
   -v ~/.aws/credentials:/rotatingcreds/credentials \
   -v /var/run:/var/run \
   -v /var/lib/ecs/data:/data \
   -v /etc/ecs:/etc/ecs \
   -e ECS_CLUSTER=FarGate \
   -e ECS_EXTERNAL=true \
   -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
   -e ECS_ENABLE_TASK_IAM_ROLE=true \
   -e ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true \
   amazon/amazon-ecs-agent$TAG