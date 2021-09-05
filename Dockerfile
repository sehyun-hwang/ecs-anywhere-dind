FROM docker:dind

RUN apk add gcompat python3 bash && rm /bin/sh && ln -s /bin/bash /bin/sh


#RUN cd /usr/bin \
#&& wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py -O systemctl \
#&& chmod +x systemctl


ARG ARCH=arm64
ENV ARCH=$ARCH

RUN apk add rpm && wget https://s3.ap-northeast-2.amazonaws.com/amazon-ssm-ap-northeast-2/latest/linux_$ARCH/amazon-ssm-agent.rpm \
&& rpm -i --nodeps amazon-ssm-agent.rpm \
&& apk del rpm && rm amazon-ssm-agent.rpm

#COPY entrypoint.sh /
#CMD ["bash", "entrypoint.sh"]
CMD ["bash"]