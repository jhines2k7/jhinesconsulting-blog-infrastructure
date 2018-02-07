FROM java:8
VOLUME /tmp
ADD jdbc-sink-kafka-10-1.3.1.RELEASE.jar app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar", "--server.host=0", "--spring.cloud.stream.bindings.input.destination=${HTTP_SOURCE_OUTPUT_CHANNEL}", "--spring.cloud.stream.kafka.binder.zkNodes=zookeeper", "--spring.cloud.stream.kafka.binder.brokers=kafka", "--spring.datasource.url=jdbc:mysql://mysql:3600/jhinesconsulting","--spring.datasource.username=${JHC_DB_USER}","--spring.datasource.password=${JHC_DB_PASS}","--spring.datasource.driver-class-name=org.mariadb.jdbc.Driver","--jdbc.table-name=contact","--jdbc.columns=id,name,email,message"]