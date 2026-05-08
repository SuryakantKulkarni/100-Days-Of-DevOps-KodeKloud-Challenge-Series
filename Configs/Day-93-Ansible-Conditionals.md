```yaml
- name: Copy files using Ansible conditionals
  hosts: all
  become: yes
  tasks:

    - name: Create finance directory
      file:
        path: /opt/finance
        state: directory
        mode: '0755'

    - name: Copy blog.txt to App Server 1
      copy:
        src: /usr/src/finance/blog.txt
        dest: /opt/finance/blog.txt
        owner: tony
        group: tony
        mode: '0755'
      when: ansible_nodename == "stapp01"

    - name: Copy story.txt to App Server 2
      copy:
        src: /usr/src/finance/story.txt
        dest: /opt/finance/story.txt
        owner: steve
        group: steve
        mode: '0755'
      when: ansible_nodename == "stapp02"

    - name: Copy media.txt to App Server 3
      copy:
        src: /usr/src/finance/media.txt
        dest: /opt/finance/media.txt
        owner: banner
        group: banner
        mode: '0755'
      when: ansible_nodename == "stapp03"
```
