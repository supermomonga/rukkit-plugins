#!/bin/bash
mkdir -p /data/world
mkdir -p /data/world_nether
mkdir -p /data/world_the_end
mkdir -p /data/dynmap
mkdir -p /data/rukkit
[ -f "/craftbukkit/plugins/rukkit/config.yml" ] || (cp /craftbukkit/plugins/rukkit/config.yml.sample /data/rukkit/config.yml)
cd /craftbukkit/
java -Xmx$1 -jar craftbukkit.jar -o true

