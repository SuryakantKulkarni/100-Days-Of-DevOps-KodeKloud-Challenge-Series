# Day 76 – Jenkins Project Security
---

## Task Overview  
The xFusionCorp Industries has recruited some new developers. There are already some existing jobs on Jenkins and two of these new developers need permissions to access those jobs. The development team has already shared those requirements with the DevOps team, so as per details mentioned below grant required permissions to the developers.

Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and password `Adm!n321`.

- There is an existing Jenkins job named `Packages`, there are also two existing Jenkins users named `sam` with password `sam@pass12345` and `rohan` with password `rohan@pass12345`.

- Grant permissions to these users to access `Packages` job as per details mentioned below:

  - Make sure to select `Inherit permissions from parent ACL` under `inheritance strategy` for granting permissions to these users.

  - Grant mentioned permissions to `sam` user : `build`, `configure` and `read`.

  - Grant mentioned permissions to `rohan user : `build`, `cancel`, `configure`, `read`, `update` and `tag`.

`Note:`

- Please do not modify/alter any other existing job configuration.

- You might need to install some plugins and restart Jenkins service. So, we recommend clicking on `Restart Jenkins when installation is complete and no jobs are running` on plugin installation/update page i.e update centre. Also Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.

- For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.

---

#### 🔐 Credentials  

| Component | User | Password |
|----------|------|----------|
| Jenkins Admin | admin | Adm!n321 |
| User 1 | sam | sam@pass12345 |
| User 2 | rohan | rohan@pass12345 |

---

## Step-by-Step Implementation  

### Step 1: Login to Jenkins  

Login using:

```
Username: admin  
Password: Adm!n321
```

#### Explanation:  
Admin access is required because only admin users can configure security settings and permissions.

### Step 2: Install Required Plugins  

Go to:

```
Manage Jenkins → Manage Plugins → Available
```

Install:

```
Role-based Authorization Strategy  
Matrix Authorization Strategy
```

Click on **Restart Jenkins when installation is complete and no jobs are running**.

#### Explanation:  
These plugins allow fine-grained permission control at both global and project levels.

### Step 3: Enable Project-Based Authorization  

Go to:

```
Manage Jenkins → Security
```

Select:

```
Project-based Matrix Authorization Strategy
```

Ensure admin has all permissions checked.

Click **Save**.

#### Explanation:  
This enables job-level permission control without affecting other jobs.

### Step 4: Grant Global Minimum Access  

Go to:

```
Manage Jenkins → Security → Authorization
```

Add users:

| User | Permission |
|------|-----------|
| sam | Overall → Read |
| rohan | Overall → Read |

Click **Save**.

#### Explanation:  
Users must have **Overall/Read** permission globally to log in and access Jenkins UI.

### Step 5: Open Packages Job Configuration  

Go to:

```
Dashboard → Packages → Configure
```

Enable:

```
Enable project-based security
```

### Step 6: Set Inheritance Strategy  

Select:

```
Inherit permissions from parent ACL
```

#### Explanation:  
This allows the job to inherit global permissions while still applying custom job-level permissions.

### Step 7: Grant Permissions to sam  

Click **Add user → sam**

Enable:

| Permission | Access |
|-----------|--------|
| Build | ✅ |
| Configure | ✅ |
| Read | ✅ |

#### Explanation:  
sam can view, build, and configure the job but cannot cancel or modify advanced actions.

### Step 8: Grant Permissions to rohan  

Click **Add user → rohan**

Enable:

| Permission | Access |
|-----------|--------|
| Build | ✅ |
| Cancel | ✅ |
| Configure | ✅ |
| Read | ✅ |
| Update | ✅ |
| Tag | ✅ |

#### Explanation:  
rohan has extended access including canceling builds and tagging builds.

### Step 9: Save Configuration  

Click **Save**.

#### Explanation:  
This applies all permission changes to the Packages job.

### Step 10: Verify Access for sam  

Login using:

```
sam / sam@pass12345
```

Check:

- Can open Jenkins dashboard  
- Can access Packages job  
- Can see Build Now  
- Can see Configure  

### Step 11: Verify Access for rohan  

Login using:

```
rohan / rohan@pass12345
```

Check:

- Can open Jenkins dashboard  
- Can access Packages job  
- Can see Build Now  
- Can cancel builds  
- Can configure job  
- Can tag builds  

---

## Key Learnings  

- Global permission (`Overall/Read`) is mandatory for login  
- Project-based security allows per-job control  
- Inheritance prevents breaking global permissions  
- Matrix authorization enables fine-grained access  
