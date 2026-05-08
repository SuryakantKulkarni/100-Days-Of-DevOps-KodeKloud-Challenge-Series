### Create Task File
```yaml
- name: Install httpd package
  yum:
    name: httpd
    state: present

- name: Start and enable httpd service
  service:
    name: httpd
    state: started
    enabled: yes

- name: Ensure document root exists
  file:
    path: /var/www/html
    state: directory

- name: Deploy index.html template
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
    owner: banner
    group: banner
    mode: '0744'
```

### Playbook File
```yaml
- name: Run httpd role on App Server 3
  hosts: stapp03
  become: yes

  tasks:
    - import_tasks: /home/thor/ansible/role/httpd/tasks/main.yml
```
