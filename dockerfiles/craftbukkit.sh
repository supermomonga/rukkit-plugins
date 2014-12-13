#!/bin/bash
mkdir -p /data/world
mkdir -p /data/world_nether
mkdir -p /data/world_the_end
mkdir -p /data/dynmap
[ -f "/craftbukkit/plugins/rukkit/config.yml" ] || (cp ~/rukkit_files/config.yml.sample /craftbukkit/plugins/rukkit/config.yml)
cd /craftbukkit/
java -Xmx$1 -jar craftbukkit.jar -o true

