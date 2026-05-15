# Day 72 – Jenkins Parameterized Builds

---

## Task Overview  
A new DevOps Engineer has joined the team and he will be assigned some Jenkins related tasks. Before that, the team wanted to test a simple parameterized job to understand basic functionality of parameterized builds. He is given a simple parameterized job to build in Jenkins. Please find more details below:

- Click on the `Jenkins` button on the top bar to access the Jenkins UI. Login using username `admin` and password `Adm!n321`.

  - Create a `parameterized` job which should be named as `parameterized-job`

  - Add a `string` parameter named `Stage`; its default value should be `Build`.

  - Add a `choice` parameter named `env`; its choices should be `Development`, `Staging` and `Production`.

  - Configure job to execute a shell command, which should echo both parameter values (you are passing in the job).

  - Build the Jenkins job at least once with choice parameter value `Production` to make sure it passes.

`Note:`

1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on `Restart Jenkins when installation is complete and no jobs are running` on plugin installation/update page i.e `update centre`. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.

2. For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.

---

## Step-by-Step Implementation  

### Step 1: Access Jenkins UI  

- Open Jenkins from top bar  
- Login:

```
Username: admin  
Password: Adm!n321
```

#### Explanation:  
We log into Jenkins using admin credentials to create and configure jobs.

### Step 2: Create New Jenkins Job  

Navigate to:

```
Dashboard → New Item
```

| Field | Value |
|------|------|
| Name | parameterized-job |
| Type | Freestyle Project |

Click **OK**

#### Explanation:  
A freestyle project allows us to configure simple automation tasks using UI.

### Step 3: Enable Parameterization  

Enable:

```
This project is parameterized
```

#### Explanation:  
This allows the job to accept user inputs at runtime.

### Step 4: Add String Parameter  

Click:

```
Add Parameter → String Parameter
```

| Field | Value |
|------|------|
| Name | Stage |
| Default Value | Build |
| Description | Build stage |

#### Explanation:  
The string parameter accepts text input. The value becomes available inside the job as `$Stage`.

### Step 5: Add Choice Parameter  

Click:

```
Add Parameter → Choice Parameter
```

Enter values (each on new line):

```
Development
Staging
Production
```

| Field | Value |
|------|------|
| Name | env |
| Description | Environment |

#### Explanation:  
Choice parameter restricts input to predefined options. The selected value is available as `$env`.

### Step 6: Add Build Step  

Navigate:

```
Build → Add build step → Execute shell
```

Add command:

```bash
echo "Stage: $Stage"
echo "Environment: $env"
```

#### Explanation:  
The `echo` command prints parameter values. This verifies that parameters are passed correctly.

Click **Save**

This stores job configuration in Jenkins.

### Step 7: Build with Parameters  

Click:

```
Build with Parameters
```

Enter:

| Parameter | Value |
|----------|------|
| Stage | Build |
| env | Production |

Click **Build**

#### Explanation:  
This executes the job using provided parameter values.

### Step 9: Verify Console Output  

Open:

```
Build → Console Output
```

#### Expected Output:
```
Started by user admin
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/parameterized-job
[parameterized-job] $/bin/sh-xe/tmp/jenkins2382061069974322068.sh
+ echo Stage: Build
Stage: Build
+ echo Environment: Production
Environment: Production
Finished: SUCCESS
```

#### Explanation:  
Console output confirms that parameters were correctly passed and executed.

### Step 10: Verify Build History  

Navigate to:

```
Build History → Build #1 → Parameters
```

#### Explanation:  
This shows parameters used in each execution. It helps track and audit builds.

---

## Best Practices  
- Use parameters for reusable jobs  
- Use choice parameters for controlled input  
- Always verify output in console logs  
- Keep parameter names meaningful  

## Key Learnings  
- Parameterized builds make Jenkins jobs dynamic  
- Parameters are passed as environment variables  
- Choice parameters reduce user errors  
- Essential concept for CI/CD pipelines  
