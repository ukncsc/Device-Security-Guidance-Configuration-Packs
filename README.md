# Device Security Guidance Configuration Packs

Copyright 2021 Crown Copyright

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0) (the "License"). You may not use this file except in compliance with the License.

Unless required by applicable law or agreed to in writing, software distributed under the License is released on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. [See the License](http://www.apache.org/licenses/LICENSE-2.0) for the specific language governing permissions and limitations.

## Table of contents
- [Device Security Guidance Configuration Packs](#device-security-guidance-configuration-packs)
  - [Table of contents](#table-of-contents)
  - [Purpose of the policies](#purpose-of-the-policies)
    - [Guiding principles](#guiding-principles)
  - [Structure](#structure)
  - [Installation](#installation)
    - [Google Workspace](#google-workspace)
      - [Chrome OS, Windows, Android, and iOS](#chrome-os-windows-android-and-ios)
    - [Microsoft Endpoint Manager](#microsoft-endpoint-manager)
      - [Windows](#windows)
      - [macOS, iOS, and Android](#macos-ios-and-android)
      - [Chrome OS, and Ubuntu LTS](#chrome-os-and-ubuntu-lts)
    - [Jamf Pro](#jamf-pro)
      - [macOS and iOS](#macos-and-ios)
      - [Windows, Android, Ubuntu LTS and Chrome OS](#windows-android-ubuntu-lts-and-chrome-os)
    - [VMware Workspace ONE](#vmware-workspace-one)
      - [Windows, iOS, macOS, Android, and Chrome OS](#windows-ios-macos-android-and-chrome-os)
    - [Ubuntu LTS](#ubuntu-lts)
  - [Contributing](#contributing)
  - [License](#license)


This repository contains policy packs which can be used by system management software to configure device platforms (such as Windows 10 and iOS) in accordance with NCSC device security [guidance](https://www.ncsc.gov.uk/collection/device-security-guidance/platform-guides). These configurations are aimed primarily at government and other medium/large organisations.

Small businesses may find the NCSC's [Small Business Guide](https://www.ncsc.gov.uk/collection/small-business-guide) a better place to start, but feel free to make use of what is provided here.

## Purpose of the policies

These policies contain the NCSC’s recommended settings for the deployment of new devices across your enterprise estate. The NCSC does not mandate the use of these policies, or even require that they are used exactly as provided. 

These setting are offered as guidance, so it is up to you how you implement and use them. In any case, they can provide a starting point for developing a compliance benchmark, or to expedite the configuration of devices to meet our recommendations.

### Guiding principles

These three principles have guided the settings encapsulated in the policies.

- __Balance Security and Usability:__ "Security for security's sake" is not the motto for these policies and settings. The aim is to keep a balance between security and usability. While each setting will have an underlying security purpose, it is perfectly reasonable for you to choose differently in your deployment.
- __Counter threats at [OFFICIAL](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/286667/FAQ2_-_Managing_Information_Risk_at_OFFICIAL_v2_-_March_2014.pdf):__ The policies provided in this repository aim to help organisations counter "commodity threats". This means those within the [UK Government's OFFICIAL Threat Model](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/286667/FAQ2_-_Managing_Information_Risk_at_OFFICIAL_v2_-_March_2014.pdf). Despite this, they can provide a starting point for considering how to configure devices that you need to protect against higher capability threat actors and the associated risks.
- __Applicable to the UK:__ This guidance primarily targets UK government organisations, and UK businesses. If you would like installation instructions for device management software not covered in the installation section, please submit a request via [Issues](https://github.com/ukncsc/Device-Security-Guidance-Configuration-Packs/issues), using the required template, including details on how the product is being used in the UK.

## Structure
The configuration packs are ordered by vendor (or operating system, then distribution, in the case of Linux), and then vendor platform. For example, Chrome OS is contained within the top-level Google folder.
```
Device-Security-Guidance-Configuration-Packs
│   CODE_OF_CONDUCT.md
│   LICENSE
│   README.md
│   SECURITY.md
│
├───.github
│   └───ISSUE_TEMPLATE
│           add-new-mdm-provider.md
│           add-new-platform.md
│           change-to-configuration.md
│           change-to-text.md
│
├───Apple
│   ├───iOS
│   │       NCSC_example_iOS_device_configuration.mobileconfig
│   │       NCSC_example_iOS_VPN_configuration.mobileconfig
│   │       NCSC_iOS_configurations.csv
│   │       NCSC_iOS_configurations.md
│   │       README.md
│   │
│   └───macOS
│           macos_provisioning_script.sh
│           NCSC_example_macOS_VPN_configuration.mobileconfig
│           NCSC_macOS_configurations.csv
│           NCSC_macOS_configurations.md
│           README.md
│
├───Google
│   ├───Android
│   │       NCSC_Android_configurations.csv
│   │       NCSC_Android_configurations.md
│   │       README.md
│   │
│   └───ChromeOS
│           NCSC_Chrome_OS_configuration.csv
│           NCSC_Chrome_OS_configurations.md
│           README.md
│
├───Linux
│   └───UbuntuLTS
│           README.md
│           Ubuntu-LTS-post-install.sh
│           Ubuntu-LTS-seed.txt
│
└───Microsoft
    └───Windows
        │   README.md
        │
        ├───GPO
        │       NCSC+MSFT_Windows_10_2004_GPO.zip
        │
        └───MDM
            └───Configurations
                │   Configurations_-_NCSC.csv
                │   Configurations_-_NCSC.md
                │   NCSC_-_Application_Control.json
                │   NCSC_-_AppLocker.json
                │   NCSC_-_Attack_Surface_Reduction_Rules.json
                │   NCSC_-_BitLocker.json
                │   NCSC_-_Credential_Guard.json
                │   NCSC_-_Custom_Settings.json
                │   NCSC_-_Defender_AV.json
                │   NCSC_-_Defender_AV_Exclusions.json
                │   NCSC_-_Defender_AV_Security_Experience.json
                │   NCSC_-_Device_Control.json
                │   NCSC_-_Device_Restriction.json
                │   NCSC_-_Edge.json
                │   NCSC_-_Firewall.json
                │   NCSC_-_Firewall_Rules.json
                │   NCSC_-_Google_Chrome_Settings.json
                │   NCSC_-_Identity_Protections.json
                │   NCSC_-_Internet_Explorer.json
                │   NCSC_-_Local_Security.json
                │   NCSC_-_Password.json
                │   NCSC_-_Web_Protections_(DR).json
                │   NCSC_-_Web_Protections_(EP).json
                │   NCSC_-_Xbox_Services.json
                │
                └───AppLocker
                        AppLocker_appx.xml
                        AppLocker_dll.xml
                        AppLocker_exe.xml
                        AppLocker_msi.xml
                        AppLocker_script.xml
                        README.md
```


## Installation
The policies can be installed in several ways, importing directly to management software, manually added in the management software and in some cases applied directly to the device.  
### Google Workspace

#### Chrome OS, Windows, Android, and iOS

Follow these instructions for 
- [Chrome OS devices](https://support.google.com/chrome/a/topic/6274424?hl=en&ref_topic=4386913)
- [Windows devices](https://support.google.com/a/answer/10181140?hl=en&ref_topic=6079327)
- [Android mobile devices](https://support.google.com/a/answer/6328708?hl=en)
- [iOS mobile devices](https://support.google.com/a/answer/6328700?hl=en&ref_topic=6079327) 
- [Universal settings for macOS and Linux devices](https://support.google.com/a/answer/6328676?hl=en&ref_topic=6079327)

Manually apply the settings, as specified in the policy file.


### Microsoft Endpoint Manager

#### Windows
Using scripts available in [Microsoft's Graph repository](https://github.com/microsoftgraph/powershell-intune-samples/tree/master/DeviceConfiguration). You can import these configurations directly into your Azure tenancy by following these steps:
1. Locate `DeviceConfiguration_Import_FromJSON.ps1`, this is the script that is required to import JSON-format configurations into Endpoint Manager
2. Run this script in PowerShell on the device you use for administration of Azure and Endpoint Manager (such as a PAW), it will prompt for your AAD credentials
3. On sucessful authentication, the script will then prompt for a location for the JSON file you want to upload
4. So long as the file is found, and the AAD account provided has the correct privileges, the configuration will be imported into Endpoint Manager. Policy and Profile Manager is a Built-in RBAC role which will allow configuration importing.

#### macOS, iOS, and Android
Follow the instructions on the Endpoint Manager pages for configurating [macOS](https://docs.microsoft.com/en-us/mem/intune/configuration/custom-settings-macos), [iOS](https://docs.microsoft.com/en-us/mem/intune/configuration/custom-settings-ios) and [Android](https://docs.microsoft.com/en-us/mem/intune/configuration/custom-settings-android-for-work) and apply the configurations in the corresponding file.

#### Chrome OS, and Ubuntu LTS
Currently, it is not possible to manage Chrome OS or Linux using Microsoft Endpoint Manager.

### Jamf Pro

#### macOS and iOS

Follow the instructions on how to [apply settings for custom configurations for macOS and iOS mobile devices](https://docs.jamf.com/10.28.0/jamf-pro/administrator-guide/Computer_Configuration_Profiles.html) and apply the .mobileconfigs, or develop your own configurations using the policy pack as a guide.

#### Windows, Android, Ubuntu LTS and Chrome OS
Currently, it is not possible to manage Windows, Android, Ubuntu LTS or Chrome OS using Jamf Pro.

### VMware Workspace ONE

#### Windows, iOS, macOS, Android, and Chrome OS

Follow the instructions on [Windows desktop profiles](https://docs.vmware.com/en/VMware-Workspace-ONE-UEM/1909/Windows_Desktop_Device_Management/GUID-AWT-PROFILE-OVERVIEWWD.html), [iOS device profiles](https://docs.vmware.com/en/VMware-Workspace-ONE-UEM/services/iOS_Platform/GUID-iOSProfileOverview.html), [macOS device profiles](https://docs.vmware.com/en/VMware-Workspace-ONE-UEM/2011/macOS_Platform/GUID-AWT-PROFILES-OVERVIEW.html), [Android device profiles](https://docs.vmware.com/en/VMware-Workspace-ONE-UEM/2011/Android_Platform/GUID-AWT-PROFILES-CONCEPT.html) or [Chrome OS device profiles](https://docs.vmware.com/en/VMware-Workspace-ONE-UEM/1909/UEM_Managing_Devices/GUID-AWT-DEVICEENROLLMENTOVERVIEW.html) and apply configurations to profiles as required

### Ubuntu LTS
The provided scripts in the Ubuntu folder are expected to be deployed through a Software Configuration Manager but can also be manually deployed onto a device.

## Contributing

Before suggesting a change via a pull request, please first discuss the change you wish to make via an issue within this GitHub repository. 

Any changes must (to prevent rejection of a pull request):

  - be done with consideration of the three [guiding principles](#guiding-principles) of this project, and any contribution that just adds or removes configurations without a clearly stated reason will likely be rejected.

  - be presented alongside evidence (in the pull request or the initial issue) that you have tested the proposed changes, including details of devices and versions of the platform.

The NCSC reserves the right to refuse pull requests if they do not meet the aims of the project, or if they do not align with current NCSC guidance.

## License

The NCSC's Policy Packs are released under the [Apache 2.0 Licence](https://www.apache.org/licenses/LICENSE-2.0) and are covered by [Crown Copyright](https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/).
