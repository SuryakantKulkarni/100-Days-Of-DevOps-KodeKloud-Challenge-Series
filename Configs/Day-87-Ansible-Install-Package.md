```yaml
- name: Install chrony on all app servers
  hosts: app
  become: yes
  tasks:
    - name: Install chrony package
      yum:
        name: chrony
        state: present
```
