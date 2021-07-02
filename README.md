# robonomics-collator-role
Ansible role for deploy robonomics collators

## Requirements
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html "Installation manual")

## Preparation
1.  Create the folder for this role in the `roles/` directory in your Ansible project and clone this repository there:
    ```
    $ tree
    .
    ├── inventory.ini
    ├── main.yml
    ├── roles
    └── tasks

    $ mkdir roles/robonomics-collator-role

    $ git clone git@github.com:dergudzon/robonomics-collator-role.git ./roles/robonomics-collator-role/
    Cloning into './roles/robonomics-collator-role'...
    remote: Enumerating objects: 35, done.
    remote: Counting objects: 100% (35/35), done.
    remote: Compressing objects: 100% (20/20), done.
    remote: Total 35 (delta 8), reused 28 (delta 4), pack-reused 0
    Receiving objects: 100% (35/35), 8.99 KiB | 4.50 MiB/s, done.
    Resolving deltas: 100% (8/8), done.

    $ tree
    .
    ├── inventory.ini
    ├── main.yml
    ├── roles
    │   └── robonomics-collator-role
    │       ├── defaults
    │       │   └── main.yml
    │       ├── handlers
    │       │   └── main.yml
    │       ├── LICENSE
    │       ├── README.md
    │       ├── tasks
    │       │   └── main.yml
    │       ├── templates
    │       │   └── robonomics-collator.service.j2
    │       └── vars
    │           └── main.yml.example
    └── tasks

    8 directories, 9 files

    ```


2.  Add hosts in your inventory. I'll use in-project `inventory.ini` file in this instruction. Let's name collators hosts group as `robonomics-collators`. 
    You can use two hosts variables for every host: `server-name` and `target-collators-count`:
        - `server-name` is using for setting server name prefix in telemetry ("servername" by default)
        - `target-collators-count` is using for setting collators count launching on this server (1 by default)

    Example of inventory.ini:
    ```
    $ cat inventory.ini 
    [robonomics-collators]
    127.0.0.1 server-name=server1 target-collators-count=4
    127.0.0.2 server-name=server2
    ```
    Accordingly to this inventory ansible will create 4 collators on host 127.0.0.1 and 1 collator on host 127.0.0.2


3.  Set role required variables, use `vars/main.yml` for this. There is 4 variables you can set:
    - `robonomics_version`: Version of robonomics, by default "1.0.0"
    - `nodename_prefix`: Prefix for every node name, by default "robonomics-collator"
    - `telemetry_url`: Telemetry URL, by default telemetry_url: "wss://telemetry.polkadot.io/submit/ 0"
    - `lighthouse_account`: Valid SS58 address for rewards, example: "*5CGDZ2dpRV3XwYaGi1Nh7oJi4wsn2h1uvMQr7cG3t1aU7FzF*". **IMPORTANT NOTE!** This is **required variable** and there is no default value!


4.  Create `.yml` file for using role. I'll use `main.yml` in project root for this:
    ```
    $ cat ./main.yml 
    ---
    - hosts: robonomics-collators
    user: root
    roles:
        - robonomics-collator-role

    ```


## Usage
Now you can use role. Use cases (have to launch in project root):

- Create collators accordingly inventory:
```
ansible-playbook -i ./inventory.ini ./main.yml
```
**Note!** If you created previously **5** collators on server, and then changed `target-collators-count` to **3**, than if you launch this command, ansible will remove unecessary **collator-4** and **collator-5**.

- Stop all collators:
```
ansible-playbook -i ./inventory.ini ./main.yml -t stop
```

- Start all collators:
```
ansible-playbook -i ./inventory.ini ./main.yml -t start
```

- Restart all collators:
```
ansible-playbook -i ./inventory.ini ./main.yml -t restart
```

- Stop all collators, remove its parachain dbs and start:
```
ansible-playbook -i ./inventory.ini ./main.yml -t remove_parachain_db
```

- Stop all collators, remove its relaychains dbs and start:
```
ansible-playbook -i ./inventory.ini ./main.yml -t remove_relaychain_db
```

- Stop all collators, remove its both dbs and start:
```
ansible-playbook -i ./inventory.ini ./main.yml -t remove_dbs
```

- Full remove all collators:
```
ansible-playbook -i ./inventory.ini ./main.yml -t remove
```