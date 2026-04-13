# Day 69 – Install Jenkins Plugins

---

## Task Overview  
The Nautilus DevOps team has recently setup a Jenkins server, which they want to use for some CI/CD jobs. Before that they want to install some plugins which will be used in most of the jobs. Please find below more details about the task

1. Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username `admin` and `Adm!n321` password.

2. Once logged in, install the `Git and GitLab` plugins. Note that you may need to restart Jenkins service to complete the plugins installation, If required, opt to Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre.

`Note:`

1. After restarting the Jenkins service, wait for the Jenkins login page to reappear before proceeding.

2. For tasks involving web UI changes, capture screenshots to share for review or consider using screen recording software like loom.com for documentation and sharing.

---

## Step-by-Step Implementation  

### Step 1: Access Jenkins UI  

Click the **Jenkins** button in the top bar of the KodeKloud interface to open the Jenkins web UI in your browser. This step opens the Jenkins web interface in the browser.  

### Step 2: Login to Jenkins  

Enter the admin credentials:
#### Credentials:
- Username: `admin`  
- Password: `Adm!n321`  

Click **Sign in** to access the Jenkins dashboard. The login process authenticates the user into Jenkins dashboard. We use admin credentials because plugin installation requires administrative access.

### Step 3: Navigate to Plugin Manager  

From the Jenkins dashboard, click on **Manage Jenkins** in the left sidebar. This opens the system administration page where you can configure global settings, manage plugins, and perform system maintenance. 

On the Manage Jenkins page, find and click on **Plugins** under the **System Configuration** section. This opens the Plugin Manager interface.

The Plugin Manager is the central place where all Jenkins plugins are installed, updated, or removed. We navigate here to manage plugins required for CI/CD.

### Step 4: Update Existing Plugins (Recommended)  

Before installing new plugins, it's best practice to update any existing plugins that have newer versions available. 

In the Plugin Manager, click on the **Updates** tab to see plugins with available updates. If there are plugins listed:

- Select the plugins you want to update (or check **Select all** to update everything)
  
- Scroll to the bottom and click **Download now and install after restart**
  
- Check the box **Restart Jenkins when installation is complete and no jobs are running**
  
Wait for Jenkins to restart before proceeding. The Jenkins UI will show **Jenkins is getting ready to restart** and then the login page will reappear once the restart is complete.

Updating plugins ensures compatibility and avoids dependency conflicts. We perform this step before installing new plugins to maintain system stability.

### Step 5: Go to Available Plugins  

After Jenkins restarts and you log back in (if needed), return to Manage Jenkins > Plugins. 

Click on the **Available plugins** tab. This tab displays all plugins available from the Jenkins Update Center that aren't currently installed. 

This tab shows all plugins available in Jenkins Update Center. We use this section to install new plugins.

### Step 6: Install Git Plugin  

In the search box at the top of the Available Plugins page, type `Git`. Look for the plugin named simply **Git**. Check the checkbox next to the Git plugin to mark it for installation. 

The Git plugin integrates Jenkins with Git repositories. We install this plugin to enable source code management and CI workflows.

### Step 7: Install GitLab Plugin  

Now, In the search box, type `GitLab`. Find the **GitLab** plugin. Check the checkbox next to the GitLab plugin. 

The GitLab plugin enables integration with GitLab repositories. We install this plugin to support webhook triggers, pipelines, and merge request builds.

### Step 8: Install Selected Plugins  

After selecting both Git and GitLab plugins, click the **Install** button. You'll be redirected to a page showing installation progress for each plugin. 

Jenkins downloads and installs selected plugins along with dependencies.  We perform this step to activate required CI/CD integrations.

### Step 9: Monitor Installation  

On the installation progress page, you'll see each plugin being downloaded and installed. The status will show:

- **Pending:** Plugin queued for download
- **Installing:** Plugin being downloaded and extracted
- **Success:** Plugin installed successfully
- **Failure:** Plugin installation failed (rarely happens)

We monitor this step to ensure plugins are installed without errors.

### Step 10: Restart Jenkins  

After all plugins show **Success** status, you need to restart Jenkins for the plugins to become fully active. 

At the bottom of the installation page, check the box that says **Restart Jenkins when installation is complete and no jobs are running**. Jenkins will automatically restart once all installations finish and no builds are running.
  
Restarting Jenkins activates newly installed plugins. We perform this step because some plugins require restart to function properly.

### Step 11: Verify Plugin Installation  

After Jenkins restarts and you log back in, navigate to Manage Jenkins > Plugins and click on the **Installed plugins** tab. You should see both plugins listed with their version numbers, indicating successful installation. 

The plugins are now active and ready to use in Jenkins jobs and pipelines. This step confirms that plugins are successfully installed.  

We verify this to ensure Jenkins is ready for CI/CD workflows.  

---

## Plugin Best Practices  
- Always update plugins before installing new ones  
- Restart Jenkins after installation  
- Check compatibility with Jenkins version  
- Test plugins in staging before production  

## Key Learnings  

- Jenkins uses plugins to extend CI/CD capabilities  
- Git and GitLab plugins are core for DevOps workflows  
- Plugin management is critical for system stability  
- Restart is required to activate plugins  
- CI/CD pipelines depend heavily on SCM integrations  
