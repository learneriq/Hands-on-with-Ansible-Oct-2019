# ANSIBLE HANDS-ON

### Our task:

#### Still working on deciding which one!

### You will need:

    1.  Ansible
    2.  A remote host
        Example: 34.244.168.125
------
### Let's start

You will have two remote machines, each one assigned with a name of an animal. 
Pick one to become your Ansible Control Node (src). The second will become the Ansible Remote host (dst)

#### 1. Install Ansible (if you haven't already)

You should run the following commands from `http://<your_animal>.ldn.devopsplayground.com/wetty/`

Check whether Ansible is installed by running:
        
        $ ansible --version

If it isn't, run these commands:
        
        $ sudo apt update
        $ sudo apt install python3-pip
        $ pip3 --version
        $ sudo pip3 install ansible --quiet

That's it!

#### 2. Configuring SSH Access to the remote Host. 

Run the following command from your command line. When prompted for password type in the password provided to you along with the hostnames.

        ./setup.sh <your remote host IP>   

#### 3. Let's check out connectivity with the host. Run:
        $ cd ansible_hands_on
        $ ansible all -i 'host.ip,' -m ping    
##### Example:   
        $ ansible all -i '52.214.226.94,' -m ping

 Or check memory and disk space of your host:

        $ ansible all -i 'host.ip,' -m shell -a 'free -m && df -h'

#### 4. Hostfile and Configuration file

        ./inventory_and_config.sh <your remote host IP>

#### 5. Write a simple playbook.

We will put together a simple playbook to update our remote host. 
Create a file `update.yml` and paste the following. Careful with the spaces - YAML is fussy! 
    
HINT: You can copy the file you have cloned from the repo. 

        ---
        - hosts: web
          tasks:
            - name: Update all packages on a Debian/Ubuntu
              apt:
                update_cache: yes
                upgrade: dist


#### 6. Run the playbook

        ansible-playbook  -i ./ansible_inventory update.yml


#### 7. Deploy an app

    Lorem ipsum...  

#### 8. Oh no! Someone messed up my configuration!


#### 9. Security compliance.....

    Lorem ipsum...  

# Thanks for participating!