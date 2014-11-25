#!/bin/bash
mkdir -p /data/world
mkdir -p /data/world_nether
mkdir -p /data/world_the_end
mkdir -p /data/dynmap
cd /craftbukkit/
java -Xmx$1 -jar craftbukkit.jar -o true

