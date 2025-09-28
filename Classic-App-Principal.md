
# PowerShell Migrator using classic app-only 

A script-based tool for migrating content from local folders or network file shares into SharePoint Online document libraries. Designed for 1:1 site migrations with metadata injection, folder hierarchy preservation, and optional unattended execution using classic app-only principals.

## 🔐 Using a Classic App-Only Principal (Unattended Mode)
This method bypasses MFA and throttling, ideal for automation and high-volume migrations.

### 1. Register the App Principal per tenat 
Navigate to: https://<tenant>.sharepoint.com/sites/<site>/_layouts/15/AppRegNew.aspx

Fill in:
- **Client ID**: Generate a GUID
- **Client Secret**: Generate a secure GUID
- **Title**: e.g., `SPOPSM Migrator`
- **App Domain**: `localhost`
- **Redirect URI**: `https://localhost`
- 
Click **Create** and note the credentials. ClinetID, and Secret 

### 2. Grant Permissions per site
Go to: https://<tenant>.sharepoint.com/sites/<site>/_layouts/15/AppInv.aspx
Paste your **Client ID**, click **Lookup**, then enter:

<AppPermissionRequests>
  <AppPermissionRequest Scope="http://sharepoint/content/sitecollection" Right="FullControl" />
</AppPermissionRequests>

Click Create to authorize.

### 3. Modify SPOPSM.ps1 for App-Only Auth
Replace the credential block:
$CSOM_credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($credentials.UserName, $credentials.Password)
$CSOM_context = New-Object Microsoft.SharePoint.Client.ClientContext($webSiteName.Url)
$CSOM_context.Credentials = $CSOM_credentials

with
$siteUrl = "<your-site-url>"
$clientId = "<your-client-id>"
$clientSecretText = "<your-client-secret>"
$clientSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force

$CSOM_context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$CSOM_context.AuthenticationMode = [Microsoft.SharePoint.Client.ClientAuthenticationMode]::Default
$CSOM_context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($clientId, $clientSecret)

⚠️ Note: This assumes your tenant allows legacy ACS-based app-only auth. Check with: Get-SPOTenant | Select DisableCustomAppAuthentication

### 4. 📁 CSV Format
SourceName, SourceFolder, WebSiteName, TargetDocumentLibraryTitle, TargetDocumentLibraryURL 
Finance, \\Server01\FinanceDocs, / , Finance 2024, FinanceDocs

Each row defines a source folder and its SharePoint destination.

### 5. 🧩 Dependencies
1) Microsoft.Online.SharePoint.PowerShell - https://www.microsoft.com/en-us/download/details.aspx?id=35588
2) SharePointPnPPowerShell*  - https://github.com/SharePoint/PnP-PowerShell 
3) PSAlphaFS - https://github.com/v2kiran/PSAlphaFS Enable long path support (up to ~32,000 characters)

🛠️ Notes
This script is monolithic. Consider modularizing into functions for upload, metadata injection, and logging.
App-only principals are not throttled like Graph-based service accounts—ideal for bulk ingestion.
ACS-based auth will be deprecated by April 2026. Plan migration to Entra ID app registrations.

📜 License
MIT

🙌 Credits
Script by Alex Gonsales https://github.com/MrDrSushi/SPOPSM 
Enhanced guidance using classixc app-unly regsitartion by NL12143
Metadata injection inspired by Microsoft SharePoint Dev Team

Let me know if you'd like to add a section for Entra ID migration planning or wrap this into a starter kit repo with toggles and onboarding guides.
