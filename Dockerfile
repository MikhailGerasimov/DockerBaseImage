FROM microsoft/dotnet:2-aspnetcore-runtime

RUN apt-get update && apt-get -y install openssh-server unzip && apt-get install net-tools

RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd 
RUN echo 'root:dev' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/#StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir /root/.vs-debugger && chmod 0755 /root/.vs-debugger
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v "latest" -l /root/.vs-debugger/

EXPOSE 22  

ENTRYPOINT service ssh restart && bash

CMD service ssh status
