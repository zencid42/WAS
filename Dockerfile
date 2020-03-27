FROM ibmcom/websphere-traditional:latest
USER root

RUN alias ll="ls -l"

COPY --chown=was:root EnterpriseHelloWorld.ear /work/app/
COPY --chown=was:root welcome.war /work/app/

USER was

RUN wsadmin.sh -lang jython -conntype NONE -c "AdminConfig.modify(AdminConfig.list('JavaVirtualMachine', \
AdminConfig.list('Server')), [['genericJvmArguments', \
'-Xshareclasses:none -javaagent:/contrast/contrast.jar -Dcontrast.dir=/contrast -Dcontrast.config.path=/contrast/contrast_security.yaml']])"
RUN /work/configure.sh




