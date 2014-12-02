FROM momonga/rukkit
MAINTAINER supermomonga


RUN curl http://dev.bukkit.org/media/files/817/822/dynmap-2.0.0.jar -s -L -o /craftbukkit/plugins/dynmap.jar
ADD craftbukkit.sh /usr/local/bin/craftbukkit
RUN chmod +x /usr/local/bin/craftbukkit

RUN mkdir -p /root/.ssh/
ADD id_rsa_github /root/.ssh/id_rsa_github
RUN chmod 600 /root/.ssh/id_rsa_github
ADD ssh_config /root/.ssh/config
RUN git clone git@github.com:supermomonga/akechi.rukkit.git /craftbukkit/plugins/rukkit/repository
RUN cd /craftbukkit/plugins/rukkit/repository && java -jar ~/.m2/repository/org/jruby/jruby-complete/1.7.16.1/jruby-complete-1.7.16.1.jar -S \
 $GEM_HOME/gems/bundler-*/bin/bundle install --path /bundler

RUN ln -s -f /data/world /craftbukkit/world
RUN ln -s -f /data/world_nether /craftbukkit/world_nether
RUN ln -s -f /data/world_the_end /craftbukkit/world_the_end
RUN ln -s -f /data/world_the_end /craftbukkit/world_the_end
RUN ln -s -f /data/rukkit/config.yml /craftbukkit/plugins/rukkit/config.yml
RUN ln -s -f /data/dynmap /craftbukkit/plugins/dynmap

VOLUME ["/craftbukkit/plugins/rukkit/config.yml"]
VOLUME ["/craftbukkit/plugins/rukkit/repository"]
VOLUME ["/data"]

EXPOSE 8081:8081
EXPOSE 8082:8082

ENTRYPOINT ["/bin/bash", "/usr/local/bin/craftbukkit"]
CMD ["2048M"]
