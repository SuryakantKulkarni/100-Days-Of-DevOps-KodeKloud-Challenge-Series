# Day 02 - Temporary User Setup with Expiry

---

## Task Overview
As part of the temporary assignment to the `Nautilus` project, a developer named `siva` requires access for a limited duration. To ensure smooth access management, a temporary user account with an expiry date is needed. Here's what you need to do:

Create a user named `siva` on `App Server 3` in Stratos Datacenter. Set the expiry date to `2026-12-07`, ensuring the user is created in lowercase as per standard protocol.

---

## Step-by-Step Implementation  

### Step 1: Connect to Server  
```bash
ssh banner@stapp03
```
#### Explanation:
The `ssh` command is used to connect to a remote server securely. We run this to access the system where the user needs to be created.

### Step 2: Create User with Expiry Date
```bash
sudo useradd -e 2026-12-07 siva
```
#### Explanation:
The `useradd` command creates a new user with an expiry date.
- `-e` flag sets account expiry date
  
We run this so that the account is automatically disabled after the given date.

### Step 3: Verify Expiry Date
```bash
sudo chage -l siva
```
#### Explanation:
The `chage -l` command shows account aging details. We run this to confirm that the expiry date is set correctly.

---

## Best Practices
- Avoid permanent access for temporary users
- Combine expiry with non-interactive shell
- Follow least privilege principle
- Regularly audit user accounts

## Key Learnings
- User expiry helps automate access control
- Reduces risk of unused active accounts
- Important for managing temporary users in production
- Simple Linux features can improve system security
