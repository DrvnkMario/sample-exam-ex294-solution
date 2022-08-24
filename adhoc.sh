#! /bin/bash

# Create automation user
ansible all -u root -m user -a "name=automation groups=wheel append=yes update_password=always password={{ 'devops' | password_hash('sha512') }} home=/home/automation"

# Create .ssh directory in automation users home
ansible all -u root -m file -a "path=/home/automation/.ssh/ state=directory recurse=yes owner=automation"

# Copy public file from control node
ansible all -u root -m copy -a "src=/root/.ssh/id_rsa.pub dest=/home/automation/.ssh/authorized_keys owner=automation"

# Enable passwordless privilege escalation for automation user
ansible all -u root -m lineinfile -a "path=/etc/sudoers line='automation ALL=(ALL) NOPASSWD: ALL'"