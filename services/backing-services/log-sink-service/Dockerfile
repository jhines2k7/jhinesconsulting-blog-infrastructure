FROM java:8

VOLUME /tmp

ADD log-sink-kafka-10-1.3.1.RELEASE.jar app.jar
RUN bash -c 'touch /app.jar'

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar","--spring.cloud.stream.kafka.binder.autoAddPartitions=true","--server.port=0","--spring.cloud.stream.kafka.binder.brokers=kafka","--spring.cloud.stream.kafka.binder.zkNodes=zookeeper","--spring.cloud.stream.bindings.input.destination=${LOGGING_INPUT_DESTINATION}"]
