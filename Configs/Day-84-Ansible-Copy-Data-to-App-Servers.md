```yaml
- name: Copy index.html to all app servers
  hosts: app
  become: yes
  tasks:

    - name: Create directory /opt/security
      file:
        path: /opt/security
        state: directory
        mode: '0755'

    - name: Copy file to servers
      copy:
        src: /usr/src/security/index.html
        dest: /opt/security/index.html

```
