FROM maven:3.9.6-eclipse-temurin-17
COPY keycloak-user-creation-events /app
WORKDIR /app
RUN mvn clean compile package

FROM quay.io/keycloak/keycloak:23.0

WORKDIR /app/misarch/template
COPY keycloak-realm-template.json .
COPY --from=0 /app/target/keycloak-dapr-events.jar /opt/keycloak/providers/keycloak-dapr-events.jar

ENV KC_DB="postgres"
ENV KC_DB_URL="jdbc:postgresql://keycloak-db:5432/postgres"
ENV KC_DB_USERNAME="postgres"
ENV KC_DB_PASSWORD="postgres"
ENV KC_HOSTNAME_STRICT="false"
ENV KC_HTTP_PORT="80"
ENV KC_HTTP_RELATIVE_PATH="/keycloak"
ENV KC_PROXY="edge"
# If the following is not set or true, the Misarch realm will be dropped whenever you start the container. Only recommended for development
ENV KC_OVERRIDE="false"

ENV SKIP_IMPORT=false

RUN /opt/keycloak/bin/kc.sh build

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "start" ]
