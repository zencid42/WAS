FROM ibmcom/websphere-traditional:latest
USER root

RUN alias ll="ls -l"

ENV PROFILE_NAME=$PROFILE_NAME \
  SERVER_NAME=$SERVER_NAME \
  ADMIN_USER_NAME=$ADMIN_USER_NAME

COPY create_profile configure.sh configure.py start_server_with_deploy_monitor deploy-monitor.sh /work/
RUN chown -R was:root /work  && \
  chmod u+x /work/configure.sh && \
  chmod u+x /work/configure.py && \
  chmod u+x /work/create_profile && \
  chmod u+x /work/start_server_with_deploy_monitor

USER was

ARG PROFILE_NAME=AppSrv01
ARG CELL_NAME=DefaultCell01
ARG NODE_NAME=DefaultNode01
ARG HOST_NAME=localhost
ARG SERVER_NAME=server1
ARG ADMIN_USER_NAME=wsadmin

ENV PROFILE_NAME=$PROFILE_NAME \
  SERVER_NAME=$SERVER_NAME \
  ADMIN_USER_NAME=$ADMIN_USER_NAME

RUN /work/create_profile
RUN mkdir -p /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/monitoredDeployableApps/servers/server1
RUN /work/configure.sh /work/configure.py

RUN wsadmin.sh -lang jython -conntype NONE -c "AdminConfig.modify(AdminConfig.list('JavaVirtualMachine', \
AdminConfig.list('Server')), [['genericJvmArguments', \
'-Xshareclasses:none -javaagent:/contrast/contrast.jar -Dcontrast.dir=/contrast -Dcontrast.config.path=/contrast/contrast_security.yaml']])"

CMD ["/work/start_server_with_deploy_monitor"]



