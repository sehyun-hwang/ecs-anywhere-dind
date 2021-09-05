FROM amazonlinux

RUN yum install -y amazon-ssm-agent
COPY . /
CMD ["bash", "/script.sh"]
