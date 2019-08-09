LDIF data to accompany
http://blog.oddbit.com/post/2013-07-22-generating-a-membero/

- `modules.ldif` -- configures `slapd` to load the `dynlist` overlay.
- `schema.ldif` -- introduces are custom objects and attributes.
- `obperson-dynlist-config.ldif` -- configures `dynlist` overlay.
- `namingcontext.ldif` -- Sets up base DN and organizationalUnits.
- `data.ldif` -- Users and groups.

## Ansible playbook

The file `playbook.yml` is an [Ansible][] playbook that will spawn an LDAP server in a Docker container and populate it with the example data included in this repository. In order to run the playbook you will need to have Ansible, Docker, and the appropriate Python modules installed.

Assuming the prerequisites are in place, running it looks like this:

```
ansible-playbook playbook.yml
```

You should see output that looks like:

```
PLAY [localhost] *********************************************************************

TASK [docker_container] **************************************************************
changed: [localhost]

TASK [add_host] **********************************************************************
changed: [localhost]

PLAY [ldap] **************************************************************************

TASK [set up ldap server] ************************************************************
changed: [ldap]

TASK [get user1 information] *********************************************************
changed: [ldap]

TASK [show user1 information] ********************************************************
ok: [ldap] => {
    "msg": [
        "# extended LDIF",
        "#",
        "# LDAPv3",
        "# base <ou=people,dc=example,dc=com> with scope subtree",
        "# filter: cn=user1",
        "# requesting: ALL",
        "#",
        "",
        "# user1, people, example.com",
        "dn: cn=user1,ou=people,dc=example,dc=com",
        "cn: user1",
        "sn: testuser",
        "uid: user1",
        "uidNumber: 1001",
        "gidNumber: 1001",
        "homeDirectory: /home/user1",
        "labeledURI: ldap:///ou=groups,dc=example,dc=com??sub?(&(objectclass=posixgroup",
        " )(memberuid=user1))",
        "objectClass: inetOrgPerson",
        "objectClass: obPerson",
        "objectClass: posixAccount",
        "obMemberOf: cn=user1,ou=groups,dc=example,dc=com",
        "obMemberOf: cn=staff,ou=groups,dc=example,dc=com",
        "",
        "# search result",
        "search: 2",
        "result: 0 Success",
        "",
        "# numResponses: 2",
        "# numEntries: 1"
    ]
}

PLAY RECAP ***************************************************************************
ldap                       : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Even if you are unable to run the playbook, you can inspect the `setup-ldap.sh` script to the commands used to configure the LDAP server.

[ansible]: https://ansible.com/
