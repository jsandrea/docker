FROM --platform=linux/amd64 postgres:latest


ENV POSTGRES_USER=sonar \
    POSTGRES_PASSWORD=sonar \
    SONARQUBE_HOME=/opt/sonarqube \
    SONAR_VERSION=8.9.1.44547 \
    SQ_DATA_DIR=/opt/sonarqube/data \
    SQ_EXTENSIONS_DIR=/opt/sonarqube/extensions \
    SQ_LOGS_DIR=/opt/sonarqube/logs \
    SQ_TEMP_DIR=/opt/sonarqube/temp



SHELL [ "/bin/bash", "-l", "-c"]

RUN apt update

RUN apt install -y wget unzip procps default-jdk

RUN wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.1.44547.zip && \
    unzip sonarqube-8.9.1.44547.zip -d /opt && \
    mv /opt/sonarqube-8.9.1.44547 /opt/sonarqube

RUN echo "sonar.jdbc.username=sonar"  >> /opt/sonarqube/conf/sonar.properties && \
    echo "sonar.jdbc.password=sonar"  >> /opt/sonarqube/conf/sonar.properties && \
    echo "sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonar"  >> /opt/sonarqube/conf/sonar.properties

RUN addgroup --system --gid 1001 sonarqube && \
    adduser sonarqube --system --uid 1001 --gid 1001 && \
    chown -R sonarqube:sonarqube ${SONARQUBE_HOME} && \
    chmod -R 777 "${SQ_DATA_DIR}" "${SQ_EXTENSIONS_DIR}" "${SQ_LOGS_DIR}" "${SQ_TEMP_DIR}"


WORKDIR /opt/sonarqube

EXPOSE 9000