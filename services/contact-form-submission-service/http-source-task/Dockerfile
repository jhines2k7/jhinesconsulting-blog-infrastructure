FROM java:8

VOLUME /tmp

ADD http-source-kafka-10-1.3.1.RELEASE.jar app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar","--spring.cloud.stream.kafka.binder.autoAddPartitions=true","--spring.cloud.stream.instanceCount=5","--spring.cloud.stream.instanceIndex=0","--spring.cloud.stream.kafka.bindings.input.consumer.enableDlq=true","--spring.cloud.stream.kafka.bindings.input.consumer.dlqName=httpsourceerrors","--http.pathPattern=/contact","--server.port=3000","--spring.cloud.stream.kafka.binder.brokers=${KAFKA_HOST}","--spring.cloud.stream.kafka.binder.zkNodes=${ZOOKEEPER_HOST}","--spring.cloud.stream.bindings.output.destination=sendemailnotification"]
