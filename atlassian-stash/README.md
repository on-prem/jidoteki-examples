# Atlassian Stash

These files can be used to provision a virtual machine with Atlassian Stash using Puppet.

# Usage

```
cd provisioning
puppet apply --modulepath=modules/ manifests/site.pp
```

# Notice

* The file: `modules/stash/files/etc/init.d/stash` was taken from
[Bitbucket](https://bitbucket.org/ssaasen/atlassian-stash-lsb-startup-script/src./master/stash) and slightly modified.

* Stash will run from openjdk instead of Oracle Java

* Everything will run as the user `stash`