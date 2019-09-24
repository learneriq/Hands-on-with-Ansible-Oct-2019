# ANSIBLE HANDS-ON

### Our task: Create a real-world LAMP stack for development using Ansible

You will need:

1. The information-slip you picked up at reception.
2. Chrome (preferably but Firefox can also do).

------
### Ansible control node and remote hosts 
Ansible works from a control machine to send commands to one or more remote machines.
In Ansible terminology, these are referred to as a *control node* and *remote host*s.
We have set up a control node and one remote host

You may have noticed from your information-slip that you have been assigned an animal name. These animals have been used to ensure everyone has unique host names.
So, for example, imagine Bob is a duck :-) We have set up machines control_duck and remote_duck for Bob to practice Ansible commands with.

Further these machines can be accessed via a command line in the browser (a web terminal called WeTTy), under the following links:

- http://control_duck.ldn.devopsplayground.com/wetty/
- http://remote_duck.ldn.devopsplayground.com/wetty/

representing the Ansible control node and remote host, respectively.
#### Let's start
1. Open up the above links (for your animal), with a separate window for each machine

2. You will be prompted for a login password. Use the one on your information-slip.

3. Type some shell commands to get familiar with the web terminal.

From now on we will be working from the browsers only.

-----

### Step 1. Install Ansible

Check whether Ansible is installed by running:

```bash        
$ ansible --version
```
You should see something like:

```bash
ansible 2.6.5
```

If not, run these commands:

```bash        
$ sudo apt update
$ sudo apt install python3-pip
$ pip3 --version
$ sudo pip3 install ansible --quiet
```
and
```bash        
$ ansible --version
```
That's it!

### Step 2. Configuring SSH Access to the remote host

Run the following command from your control_duck.

```bash
$ ./setup.sh remote_host_ip

e.g.
$ ./setup.sh 52.214.226.94
```

### Step 3. Let's check out connectivity with the host 
Run:
```bash
$ cd ansible_hands_on
$ ansible all -i 'remote_host_ip,' -m ping

e.g.
$ ansible all -i '52.214.226.94,' -m ping
```
 Or check memory and disk space on your remote_duck:

```bash
$ ansible all -i 'remote_host_ip,' -m shell -a 'free -m && df -h'
```

### Step 4. Ansible Hostfile and configuration file
```bash
$ ./inventory_and_config.sh remote_host_ip
```
### Step 5. Write a simple playbook

We will put together a simple playbook to update our remote host. 
Create a file `update.yml` and paste the following. Careful with the spaces - YAML is fussy!
    
HINT: You can copy the file you have cloned from the repo. 
```YAML
---
- hosts: lamp
  remote_user: playground
  become: yes

  tasks:
    - name: Update all packages on a Debian/Ubuntu
      apt:
        update_cache: yes
        upgrade: dist

    - name: Check disk space and memory
      shell: free -m && df -h
```

### Step 6. Run the playbook
```bash
ansible-playbook  -i ./ansible_inventory update.yml -v
```
The `-v` give us a more detailed output from Ansible, once the playbook is run. Ansible is rich with feedback data. Try running the same command but with `-vv` or even `-vvvv`.

### Step 7. Build a LAMP stack

We will look at how to write a LAMP stack playbook using the features offered by Ansible. Here is the high-level hierarchy structure of the playbook that will trigger the installation of LAMP:

```YAML
- name: LAMP stack setup on Ubuntu 18.04
  hosts: lamp
  gather_facts: False
  remote_user: "{{ remote_username }}"
  become: True
  roles:
    - common
    - web
    - db
    - php 
```
#### 7.1 The Common Role

##### Questions: Do we need to install Python 2 if we already will have installed Python 3? (Currently Python 2 is installed)

Create the folowing folder structure `roles/common/tasks/main.yml` and put in the `main.yml` the following contents:

```YAML
- name: install python 2
  raw: test -e /usr/bin/python || (apt -y update && apt install -y python-minimal)
- name: install curl and git
  apt:
    name: "{{ item }}"
    state: present
    update_cache: yes
  with_items:
    - curl
    - git
```
#### 7.2 The Web Role

#### 7.2.1 Install, configure and start apache2

Next step in our LAMP configuration is the installation of the Apache2 server. Under `roles/` create the `web/tasks/main.yml`

The following code will tell our Ansible to install Apache2, configure it. It'll also add Apache2 to the startup service. 

HINT: Don't forget to unindent the code once pasted!

```YAML
- name: install apache2 server
  apt:
    name: apache2
    state: present

- name: update the apache2 server configuration
  template: 
    src: web.conf.j2
    dest: /etc/apache2/sites-available/000-default.conf
    owner: root
    group: root
    mode: 0644

- name: enable apache2 on startup
  systemd:
    name: apache2
    enabled: yes
  notify:
    - start apache2
```
#### 7.2.2 Handling apache2 start.
This is called `handler` and it is what our `notify` parameter will trigger. 
Create  `roles/web/handlers/main.yaml` and paste there the following.

```YAML
- name: start apache2
  systemd:
    state: started
    name: apache2

- name: stop apache2
  systemd:
    state: stopped
    name: apache2

- name: restart apache2
  systemd:
    state: restarted
    name: apache2
    daemon_reload: yes
```
#### 7.2.3 Templating

This is how we will use the `template` feature to configure apache2. The Ansible templates use the Jinja2 templating engine. We will create the a template in this location  `roles/web/templates/web.conf.j2`.

```XML
<VirtualHost *:80><VirtualHost *:80>
    ServerAdmin {{server_admin_email}}
    DocumentRoot {{server_document_root}}

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
This template will be fed by the variables contained in `roles/web/vars/main.yml`:

```YAML
server_admin_email: playground@localhost.local
server_document_root: /var/www/html
```
What if we don't have access to the documentation in the web? Ansible ships with the `ansible-doc` tool. We can access the documentation from the command line.

```bash
$ ansible-doc apt
```

### Step 8. Oh no! Someone messed up my configuration!

Lorem Ipsum. Cum Laude. Carpe Diem (Seize the Panda).



### 9. Notes

    
Link to the [git repository](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019) with the README and the playbooks that will be used in this session.

### 10. References

Some materials were adopted from this cool book:

[Security Automation with Ansible 2: Leverage Ansible 2 to Automate Complex Security Tasks Like Application Security, Network Security, and Malware Analysis](https://g.co/kgs/xbJUnr)

 

# Thanks for participating!