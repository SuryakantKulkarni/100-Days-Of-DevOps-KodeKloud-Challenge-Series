```yaml
- name: Create file on App Server 1
  hosts: stapp01
  become: yes
  tasks:
    - name: Create /opt/webdata.txt
      file:
        path: /opt/webdata.txt
        state: touch
        owner: tony
        group: tony
        mode: '0744'

- name: Create file on App Server 2
  hosts: stapp02
  become: yes
  tasks:
    - name: Create /opt/webdata.txt
      file:
        path: /opt/webdata.txt
        state: touch
        owner: steve
        group: steve
        mode: '0744'

- name: Create file on App Server 3
  hosts: stapp03
  become: yes
  tasks:
    - name: Create /opt/webdata.txt
      file:
        path: /opt/webdata.txt
        state: touch
        owner: banner
        group: banner
        mode: '0744'
```
