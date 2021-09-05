FROM busybox as busybox
FROM amazon/amazon-ecs-agent
COPY --from=busybox /bin/busybox /bin/busybox