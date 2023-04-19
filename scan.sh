#!/bin/bash

rm -rf node_modules

rm yarn.lock

yarn install

nexus-iq-cli -s http://localhost:8070 -a admin:admin123 -i juiceshop_yarn_dir_nodemods .

nexus-iq-cli -s http://localhost:8070 -a admin:admin123 -i juiceshop_yarn_lockfile_nodemods yarn.lock

rm -rf node_modules

nexus-iq-cli -s http://localhost:8070 -a admin:admin123 -i juiceshop_yarn_dir_nonodemods .

nexus-iq-cli -s http://localhost:8070 -a admin:admin123 -i juiceshop_yarn_lockfile_nonodemods yarn.lock
