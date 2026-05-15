# Day 17 – Install and Configure PostgreSQL

---

## Task Overview  
The `Nautilus` application development team has shared that they are planning to deploy one newly developed application on `Nautilus` infra in `Stratos DC`. The application uses PostgreSQL database, so as a pre-requisite we need to set up PostgreSQL database server as per requirements shared below:

PostgreSQL database server is already installed on the `Nautilus` database server.

- Create a database user `kodekloud_tim` and set its password to `your-password`.

- Create a database `kodekloud_db7` and grant full permissions to user `kodekloud_tim` on this database.

> Note: Please do not try to restart PostgreSQL server service.

---

## Step-by-Step Implementation  

### Step 1: Connect to Database Server  

```bash
ssh peter@stdb01
```
#### Explanation:  
The `ssh` command is used to securely connect to a remote server. We run this command to access the PostgreSQL server.

### Step 2: Switch to Root User  

```bash
sudo su
```
#### Explanation:  
The `sudo su` command switches to the root user.  
- `sudo` provides elevated privileges  
- `su` switches to root shell  

We run this to perform administrative database tasks.

### Step 3: Check PostgreSQL Service  

```bash
systemctl status postgresql
```
#### Explanation:  
The `systemctl status` command checks service state.  
- `postgresql` is the database service  

We run this to ensure PostgreSQL is running before configuration.

### Step 4: Switch to PostgreSQL User  

```bash
sudo -u postgres psql
```
#### Explanation:  
This command opens PostgreSQL interactive shell.  
- `sudo -u postgres` runs command as postgres user  
- `psql` is PostgreSQL CLI tool  

We run this to execute SQL commands.

### Step 5: List Existing Roles  

```sql
\du
```
#### Explanation:  
The `\du` command lists all database roles (users). We run this to verify existing users.

### Step 6: List Databases  

```sql
\l
```
#### Explanation:  
The `\l` command lists all databases in PostgreSQL. We run this to check existing databases.

### Step 7: Create Database User  

```sql
CREATE USER kodekloud_tim WITH PASSWORD 'your-password';
```
#### Explanation:  
- `CREATE USER` creates a new PostgreSQL role  
- `kodekloud_tim` is the username  
- `WITH PASSWORD` sets authentication password  

We run this to create application user.

### Step 8: Create Database  

```sql
CREATE DATABASE kodekloud_db7;
```
#### Explanation:  
- `CREATE DATABASE` creates a new database  
- `kodekloud_db7` is database name  

We run this to create application database.

### Step 9: Grant Privileges  

```sql
GRANT ALL PRIVILEGES ON DATABASE kodekloud_db7 TO kodekloud_tim;
```
#### Explanation:  
- `GRANT ALL PRIVILEGES` gives full access  
- `ON DATABASE` specifies target database  
- `TO kodekloud_tim` assigns privileges  

We run this to allow user full control over database.

### Step 10: Exit PostgreSQL  

```sql
\q
```
#### Explanation:  
The `\q` command exits PostgreSQL interactive shell. We run this after completing configuration.

### Credentials Summary  

| Field | Value |
|------|------|
| Database User | kodekloud_tim |
| Password | your-password |
| Database Name | kodekloud_db7 |
| Privileges | Full Access |

---

## Key Learnings  
- PostgreSQL uses roles instead of traditional users  
- psql is used for database interaction  
- GRANT controls access permissions  
- Always verify service before configuration  
- Database ownership and permissions are critical for apps  
