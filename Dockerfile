FROM microsoft/dotnet:2-aspnetcore-runtime

RUN apt-get update && apt-get -y install openssh-server unzip && apt-get install net-tools

RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd 
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/#StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config
RUN  echo -e "dev\ndev\n" |passwd root


RUN mkdir /root/.vs-debugger && chmod 0755 /root/.vs-debugger
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v "latest" -l /root/.vs-debugger/

EXPOSE 22  

CMD ["/usr/sbin/sshd", "-D"]
