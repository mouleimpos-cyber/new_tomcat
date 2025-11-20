FROM tomcat:8.0-alpine

# remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat inside image listens on 8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
