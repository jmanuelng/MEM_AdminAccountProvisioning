# MEM_AdminAccountProvisioning

Repository contains PowerShell scripts to create local administrator accounts on Windows devices managed through Microsoft Intune. I've used them for Local Administrator Password Solution (LAPS) with Azure Active Directory (now Microsoft Entra ID).

## Overview

The Local Administrator Password Solution (LAPS) provides centralized storage and automatic management of local administrator passwords on Windows devices. When integrated with Microsoft Entra ID and Microsoft Intune, LAPS ensures that passwords are strong, unique, and periodically changed, adhering to organizational policies and compliance requirements.

## Scripts in this Repository

- `Fix_AdminAccountSetup.ps1`: Script creates a local administrator account on a Windows device. It is intended to be used as a remediation script within Intune to ensure compliance with organizational policies.
- `Detect_AdminAccountSetup.ps1`: Script checks for the existence of the local administrator account and verifies its membership in the Administrators group. It is used to detect the current state of the device and report compliance.

## Prerequisites

- Devices must be Azure AD-joined and managed by Microsoft Intune.
- Appropriate permissions in Azure AD and Intune to create and assign policies.

## Setting up LAPS in Azure AD

To enable LAPS in Azure AD, follow these steps:

1. Navigate to Azure Active Directory > Devices > Device settings.
2. Under Local administrator settings (preview), select Yes for "Enable Azure AD Local Administrator Password Solution (LAPS)".
3. Click Save.

For more detailed instructions, refer to the [official documentation](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-scenarios-azure-active-directory).

## Implementing LAPS with Intune

Intune supports the management of Windows LAPS through configuration service provider (CSP). To set up LAPS policies in Intune:

1. Create a configuration profile with the Windows LAPS CSP settings.
2. Define password requirements such as complexity, length, and rotation schedule.

For a comprehensive guide, visit [Implement LAPS with Intune - A Comprehensive Guide](https://cloudinfra.net/implement-laps-with-intune-a-comprehensive-guide/).

### Using `Fix_AdminAccountSetup.ps1` and `Detect_AdminAccountSetup.ps1` as a Remediation Script in Intune

1. In the Microsoft Endpoint Manager admin center, navigate to the "Devices" section.
2. Under "Devices," go to "Remediations" (previously known as Proactive Remediations).
3. Click on "Create script package" to start the process.
   - For the detection script, upload `Detect_AdminAccountSetup.ps1`. It will verify custom admin account and membershiop in Administrators group.
   - For the remediation script, upload `Fix_AdminAccountSetup.ps1`. Creates a user and adds it as an admin.
6. Assign the script package to the relevant group of devices.
7. Schedule the detection and remediation scripts to run at the desired frequency. The detection script should be scheduled to run before the remediation script.
8. Monitor the script execution and results in the "Remediations" section to ensure the custom admin account is set up correctly.

For more detailed guidance, you can refer to the following resources:
- [Remediations | Microsoft Learn](https://learn.microsoft.com/en-us/mem/intune/fundamentals/remediations)
- [Proactive Remediations 101 - Intune's hidden secret!](https://andrewstaylor.com/2022/04/12/proactive-remediations-101-intunes-hidden-secret/)
- [How to Configure Proactive Remediations in Microsoft Intune](https://blog.intune.training/blog/S02E09-How-to-Configure-Proactive-Remediations-in-Microsoft-Intune-(I-T).html)

**NOTE:** Above steps are a general guide and may vary slightly based on the current Intune interface and features. Always refer to the latest documentation for the most accurate and up-to-date information.


## Feedback and Contributions

Feedback and contributions are welcome. Please submit issues and pull requests to the repository as needed.

## Acknowledgments

- Original concept and code snippets adapted from [Nicolonsky Tech](https://github.com/nicolonsky).
- LAPS documentation and guidance provided by [Microsoft](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-scenarios-azure-active-directory).



