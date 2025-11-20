FROM tomcat:8.0-alpine

RUN rm -r /usr/local/tomcat/webapps/ROOT

COPY target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8081
CMD ["catalina.sh", "run"]
