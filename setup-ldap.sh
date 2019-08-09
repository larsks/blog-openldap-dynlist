#!/bin/sh

while !  ldapsearch -H ldapi:/// -Y EXTERNAL -b cn=config -s one; do
	echo "waiting for ldap server..."
	sleep 1
done

set -e

for config in schema.ldif modules.ldif dynlist-config.ldif; do
	echo "loading $config"
	ldapadd -H ldapi:/// -Y EXTERNAL -f /data/$config
done

for data in namingcontext.ldif userdata.ldif; do
	echo "loading $data"
	ldapadd -H ldapi:/// -D cn=admin,dc=example,dc=com \
		-w admin -f /data/$data
done

ldapsearch -H ldapi:/// -D cn=admin,dc=example,dc=com \
        -w admin -b ou=people,dc=example,dc=com cn=user1
