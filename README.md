# Device Security Guidance Configuration Packs

Copyright 2025 Crown Copyright

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
      - [ChromeOS, Windows, Android, and iOS](#chromeos-windows-android-and-ios)
    - [Microsoft Intune](#microsoft-intune)
      - [Windows](#windows)
      - [macOS, iOS, and Android](#macos-ios-and-android)
      - [ChromeOS](#chromeos)
    - [Jamf Pro](#jamf-pro)
      - [macOS and iOS](#macos-and-ios)
      - [Windows, Android and ChromeOS](#windows-android-and-chromeos)
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
└───Microsoft
    └───Windows
        │   README.md
        │
        └───MDM
            └───Configurations
                │   Configurations_-_NCSC 2025.csv
                │   Configurations_-_NCSC 2025.md
                |
                ├───AppLocker
                |     AppLocker_appx.xml
                |     AppLocker_dll.xml
                |     AppLocker_exe.xml
                |     AppLocker_msi.xml
                |     AppLocker_script.xml
                |
                ├───DeviceConfiguration
                |     2025-NCSC-Surface-DFCI.json
                |
                ├───EndpointSecurity
                |     2025-NCSC-Account-Protections.json
                |     2025-NCSC-Account-Protections_Settings.json
                |     2025-NCSC-Application-Control.json
                |     2025-NCSC-Application-Control_Settings.json
                |
                └───SettingsCatalog
                      2025-NCSC-ASR.json
                      2025-NCSC-App-Control-for-Business.json
                      2025-NCSC-BitLocker.json
                      2025-NCSC-Defender-Antivirus.json
                      2025-NCSC-Defender.json
                      2025-NCSC-Device-Control.json
                      2025-NCSC-Edge.json
                      2025-NCSC-General.json
```


## Installation
The policies can be installed in several ways, importing directly to management software, manually added in the management software and in some cases applied directly to the device.  
### Google Workspace

#### ChromeOS, Windows, Android, and iOS

Follow these instructions for 
- [ChromeOS devices](https://support.google.com/chrome/a/topic/6274424?hl=en&ref_topic=4386913)
- [Windows devices](https://support.google.com/a/answer/10181140?hl=en&ref_topic=6079327)
- [Android mobile devices](https://support.google.com/a/answer/6328708?hl=en)
- [iOS mobile devices](https://support.google.com/a/answer/6328700?hl=en&ref_topic=6079327) 
- [Universal settings for macOS and Linux devices](https://support.google.com/a/answer/6328676?hl=en&ref_topic=6079327)

Manually apply the settings, as specified in the policy file.


### Microsoft Intune

#### Windows
Using scripts available in [Microsoft's Graph repository](https://github.com/microsoft/mggraph-intune-samples/tree/main/DeviceConfiguration). You will need to locate the relevant import script for the policy type you are importing. Once you have located the script, you can import these configurations directly into your Intune tenancy by following these steps as an example:
1. Locate `DeviceConfiguration_Import_FromJSON.ps1`, this is the script that is required to import JSON-format configurations into Endpoint Manager
2. Run this script in PowerShell on the device you use for administration of Azure and Endpoint Manager (such as a PAW), it will prompt for your Entra ID credentials
3. On sucessful authentication, the script will then prompt for a location for the JSON file you want to upload
4. So long as the file is found, and the Entra ID account provided has the correct privileges, the configuration will be imported into Endpoint Manager. Policy and Profile Manager is a Built-in RBAC role which will allow configuration importing.

A manual version of the policies and settings are available within the repository README documents.

#### macOS, iOS, and Android
Follow the instructions on the Endpoint Manager pages for configurating [macOS](https://docs.microsoft.com/en-us/mem/intune/configuration/custom-settings-macos), [iOS](https://docs.microsoft.com/en-us/mem/intune/configuration/custom-settings-ios) and [Android](https://docs.microsoft.com/en-us/mem/intune/configuration/custom-settings-android-for-work) and apply the configurations in the corresponding file.

#### ChromeOS
Currently, it is not possible to manage ChromeOS using Microsoft Intune.

### Jamf Pro

#### macOS and iOS

Follow the instructions on how to [apply settings for custom configurations for macOS and iOS mobile devices](https://docs.jamf.com/10.28.0/jamf-pro/administrator-guide/Computer_Configuration_Profiles.html) and apply the .mobileconfigs, or develop your own configurations using the policy pack as a guide.

#### Windows, Android and ChromeOS
Currently, it is not possible to manage Windows, Android or ChromeOS using Jamf Pro.

## Contributing

Before suggesting a change via a pull request, please first discuss the change you wish to make via an issue within this GitHub repository. 

Any changes must (to prevent rejection of a pull request):

  - be done with consideration of the three [guiding principles](#guiding-principles) of this project, and any contribution that just adds or removes configurations without a clearly stated reason will likely be rejected.

  - be presented alongside evidence (in the pull request or the initial issue) that you have tested the proposed changes, including details of devices and versions of the platform.

The NCSC reserves the right to refuse pull requests if they do not meet the aims of the project, or if they do not align with current NCSC guidance.

## License

The NCSC's Policy Packs are released under the [Apache 2.0 Licence](https://www.apache.org/licenses/LICENSE-2.0) and are covered by [Crown Copyright](https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/).
