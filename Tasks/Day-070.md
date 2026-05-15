# Day 70 – Configure Jenkins User Access

---

## Task Overview  
The Nautilus team is integrating Jenkins into their CI/CD pipelines. After setting up a new Jenkins server, they're now configuring user access for the development team, Follow these steps:

- Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login with username `admin` and password `Adm!n321`.

- Create a jenkins user named `anita` with the password `Rc5C9EyvbU`. Their full name should match `Anita`.

- Utilize the `Project-based Matrix Authorization Strategy` to assign `overall read` permission to the `anita` user.

- Remove all permissions for `Anonymous` users (if any) ensuring that the `admin` user retains overall `Administer` permissions.

- For the existing job, grant `anita` user only `read` permissions, disregarding other permissions such as Agent, SCM etc.

`Note:`

1. You may need to install plugins and restart Jenkins service. After plugins installation, select `Restart Jenkins when installation is complete and no jobs are running` on plugin installation/update page.

2. After restarting the Jenkins service, wait for the Jenkins login page to reappear before proceeding. Avoid clicking `Finish` immediately after restarting the service.

3. Capture screenshots of your configuration for review purposes. Consider using screen recording software like `loom.com` for documentation and sharing.

---

## Step-by-Step Implementation  

### Step 1: Access Jenkins Dashboard  

- Click on **Jenkins** button  
- Login using:
  
```
Username: admin  
Password: Adm!n321
```

#### Explanation:  
We log into Jenkins with admin credentials to configure users and security settings.

### Step 2: Install Matrix Authorization Strategy Plugin  

Navigate to:  
`Manage Jenkins → Plugins → Available Plugins`

Search:
```
Matrix Authorization Strategy
```

- Select plugin  
- Click **Install**  
- Enable: **Restart Jenkins after installation**

#### Explanation:  
This plugin allows fine-grained permission control for users and projects.

### Step 3: Create New User  

Navigate to:  
`Manage Jenkins → Users → Create User`

Fill details:

| Field | Value |
|------|------|
| Username | javed |
| Password | ksH85UJjhb |
| Full Name | Javed |
| Email | javed@jenkins.com |

Click **Create User**

#### Explanation:  
We create a new user account to assign controlled access.

### Step 4: Enable Project-Based Matrix Authorization  

Navigate to:  
`Manage Jenkins → Security`

Select:
```
Project-based Matrix Authorization Strategy
```

#### Explanation:  
This enables both global and project-level permission control.

### Step 5: Configure Admin Permissions  

- Add user: `admin`  
- Enable: **Administer**

#### Explanation:  
Administer permission grants full control over Jenkins.

### Step 6: Configure Anita Permissions  

- Add user: `anita`  
- Enable only:
```
Overall → Read
```

#### Explanation:  
This allows the user to view Jenkins but not modify anything.

### Step 7: Remove Anonymous Access  

- Find `Anonymous` user  
- Uncheck all permissions  

#### Explanation:  
This prevents unauthorized access to Jenkins.

### Step 8: Save Security Configuration  

Click **Save**

#### Explanation:  
This applies global security settings immediately.

### Step 9: Configure Job-Level Permissions  

Navigate to:
- Open existing job  
- Click **Configure**  

Enable:
```
Enable project-based security
```

#### Explanation:  
This allows setting permissions specific to a job.

### Step 10: Assign Job Permissions to anita 

- Add user: `anita`  
- Under **Job column → Read only**

#### Explanation:  
User can view job details but cannot build or modify.

### Step 11: Save Job Configuration  

Click **Save**

#### Explanation:  
Applies project-level permissions.

### Step 12: Verify Access  

Login as:
```
Username: anita 
Password: Rc5C9EyvbU
```

#### Expected Behavior:
- Can view dashboard ✅  
- Can view job ✅  
- Cannot build job ❌  
- Cannot configure job ❌  

#### Explanation:  
Verification ensures correct permission enforcement.

---

## Best Practices  
- Always keep admin access  
- Disable anonymous access  
- Use role-based permissions  
- Test access after configuration  

## Key Learnings  
- Jenkins security is critical in CI/CD pipelines  
- Matrix strategy provides flexible access control  
- Always follow least privilege principle  
- Separate global and job-level permissions  
