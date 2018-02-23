FROM openjdk:9.0.1-jre-slim

VOLUME /tmp

ADD jdbc-sink-kafka-10-1.3.1.RELEASE.jar app.jar
RUN bash -c 'touch /app.jar'

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar","--server.port=0","--spring.cloud.stream.bindings.input.destination=createproject","--spring.cloud.stream.kafka.binder.zkNodes=${ZOOKEEPER_HOST}","--spring.cloud.stream.kafka.binder.brokers=${KAFKA_HOST}","--spring.datasource.url=jdbc:mysql://${PROJECTS_DB_HOST}:3306/${PROJECTS_DB_NAME}","--spring.datasource.username=${JHC_DB_USER}","--spring.datasource.password=${JHC_DB_PASS}","--spring.datasource.driver-class-name=org.mariadb.jdbc.Driver","--jdbc.table-name=projects","--jdbc.columns=id,name,detail_image,home_image,description,solution,client_name,duration,date,budget"]
