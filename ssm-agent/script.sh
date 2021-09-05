set -e

SSM_REGISTRATION_FILE=/var/lib/amazon/ssm/Vault/Store/RegistrationKey

if [ -f $SSM_REGISTRATION_FILE ]; then
    echo "Already registed to SSM"
    cat $SSM_REGISTRATION_FILE
else
    amazon-ssm-agent -register -region $AWS_DEFAULT_REGION -similarityThreshold 1 \
    `curl https://proxy.hwangsehyun.com/ecs`
fi

CERTS=/certs/client
until curl --cert $CERTS/cert.pem --key $CERTS/key.pem -k \
https://docker:2376/version; do
    sleep 1
done


until curl ecs-agent:1234 -m 1; do
    if [ $? -eq 28 ]; then
        break
    fi
    sleep 1
done

amazon-ssm-agent