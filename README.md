# Ansible OSB Role

## Description

This is an Ansible role to install SQL*PLUS tool to connect to an Oracle database server.

## Supported systems

- Debian 7/8
- Ubuntu Precise/Trusty
- EL 6/7

## Role dependencies

- None.

## Requirements

### Software Requirements

- **Ansible 1.9** or higher (can be easily installed via `pip`. E.g: `sudo pip install ansible==1.9.2`)
- **[Vagrant](https://www.vagrantup.com) 1.7** or higher
- `sshpass` package which is needed by Ansible if you are using SSH authentication by password. On Ubuntu/Debian: `$ sudo apt-get install sshpass`
- **Virtualbox**

### System requirements

- None.

## Role Variables

- **`sqlplus_basic_rpm_package`** - RPM package including basic files required to run OCI, OCCI, and JDBC-OCI applications (default: `oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm`)
- **`sqlplus_bin_rpm_package`** - RPM package including additional libraries and executable for running SQL*Plus with instant client (default: `oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm`)
- **`sqlplus_rpm_download_directory`** - Absolute path to directory where installation rpm files are copied (default: `/srv/files/`)
- **`sqlplus_home`** - Absolute path to sqlplus installation directory (default: `/usr/lib/oracle/12.1/client64`)
- **`sqlplus_basic_rpm_package_url`** - URL to download RPM from (default: `undefined`)
- **`sqlplus_bin_rpm_package`** - URL to download RPM from (default: `undefined`)
- **`proxy_env`** - Environment variables to proxy / noproxy RPM download (default: `dummy_var: dummy_var`)

## Available tags

- None.

## Local facts

- None.

# Usage

### Installation

First of all make sure you downloaded the required RPMs from [oracle website](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html):
  - oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
  - oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm

Now put the downloaded packages to the remote host so Ansible can see them (via the `sqlplus_rpm_download_directory` role parameter). By default, Ansible checks the rpm file inside `/srv/files/` directory.

### Test connection

Personally and for quick tests, I use the Docker image [sath89/oracle-12c](https://hub.docker.com/r/sath89/oracle-12c/) that brings up an Oracle 12c database server. All you need is to pull the image, create a local data directory and spin up an `oracle-db` container:

    $ sudo docker pull sath89/oracle-12c:latest
    $ sudo mkdir -p /var/lib/oracledb/data
    $ sudo docker run --name oracle-db -d -p 8080:8080 -p 1521:1521 -v /var/lib/oracledb/data:/u01/app/oracle -e DBCA_TOTAL_MEMORY=1024 sath89/oracle-12c


To test the database connection:

    $ export ORACLE_SID=xe.oracle.docker
    $ sqlplus -L sys/oracle@<DB-SERVER-IP-ADDRESS>/xe.oracle.docker as sysdba

    Connected to:
    Oracle Database 12c Standard Edition Release 12.1.0.2.0 - 64bit Production

    SQL>

# Development and testing

## Test with Vagrant

For quick tests, you can spin-up a VM using Vagrant. You maybe need to adapt the Vagrantfile to suit your environment (system, IP addresses, etc):

- Change the Vagrant box name in the Vagrantfile if needed.

- Create the virtual machine:

```
(host)$ vagrant up --no-provision
```

- Copy the RPM packages to the VM.

- Provision the virtual machine:

```
(host)$ vagrant provision
```

## Run acceptance tests

Acceptance/Integration tests could be run against the role using the magic `test-kitchen` tool. All the written acceptance tests are in the **./test/integration/** directory.

The `.kitchen.yml` file describes the testing configuration and the list of tests suite to run. By default, your instances will be **converged** with Ansible and run in Vagrant virtual machines.

To list the instances:

    $ kitchen list

    Instance                    Driver   Provisioner      Verifier  Transport  Last Action
    default-centos-7-x64        Vagrant  AnsiblePlaybook  Busser    Ssh        <Not Created>

To run the default test suite on a CentOS 7 platform, run the following:

    $ kitchen test

## Author

This role was created by [Ahmed Bessifi](https://www.linkedin.com/in/abessifi), a DevOps enthusiast.
