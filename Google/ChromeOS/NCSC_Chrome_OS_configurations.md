|MDM settings                                                                   |As per Profile Manager MDM. Default Google values apply to any settings not present.|
|-------------------------------------------------------------------------------|------------------------------------------------------------------------------------|
|                                                                               |                                                                                    |
|Chrome management                                                              |                                                                                    |
|User & Browser settings                                                        |                                                                                    |
|                                                                               |                                                                                    |
|Browser sign-in settings                                                       |Consider blocking users from signing in or out of Google Accounts within the browser. This will prevent users from signing into their personal Google Accounts on an Enterprise device. If this has been set to blocked, also ensure that Guest Mode and Incognito Mode are blocked, and that Sign-in Restriction is enabled. If allowing users to sign into their personal Google Accounts, Guest Mode and Incognito Mode can be enabled.|
|Restrict sign-in to pattern                                                    |Restrict Sign-in to list of users. Enter all domains used by your organisation, with the regex pattern as below: .*@example\.com .*@sales.example\.com Wildcards should not be used in the domain portion of the entries to ensure only users from managed domains and not unmanaged subdomains or third-party domains are allowed to sign in.|
|Display password Button                                                        |Do not show the display password button on the login screen                         |
|Chrome Mobile (BETA)                                                           |Do not apply supported user settings to Chrome on Android                           |
|Enrolment Controls                                                             |Create a separate 'enrolment users' OU and ensure that users in this OU are the only ones able to enrol new devices. These accounts should not have access to any other data or applications. Allow users to re-enroll their existing devices.|
|Enrolment Controls: Device enrollment                                          |Place Chrome device in user organisation                                            |
|Enrolment Controls: Enrollment Permissions                                     |Allow users in organisation to enroll new or re-enroll existing devices             |
|                                                                               |                                                                                    |
|Apps and extensions page                                                       |Add applications to allow list and push to devices.                                 |
|Allow users to install other apps and extensions                               |Block all other apps & extensions                                                   |
|                                                                               |                                                                                    |
|Application Settings page                                                      |                                                                                    |
|Android applications on Chrome devices                                         |If this functionality is required and an Android application allow-list is in place, allow. Otherwise, do not allow|
|App and extension install sources                                              |Only trusted sources should be defined, as required.                                |
|Allow insecure extension packaging                                             |Do not allow insecurely packaged extensions                                         |
|External extensions                                                            |Block external extensions from being installed (unless specifically required)       |
|Permissions and URL's                                                          |If external extensions are allowed, this allows the setting of extension blocking on a granular level.|
|Chrome Web Store permissions                                                   |Do not allow users to publish private apps that are restricted to your domain on Chrome Web Store|
|Android reporting for users and devices                                        |Enable Android reporting                                                            |
|User & Browser settings (cont)                                                 |                                                                                    |
|Site Isolation                                                                |Turn on site isolation for all websites                                             |
|Site Isolation (Chrome on Android)                                            |Turn on site isolation for all websites                                             |
|Password Manager                                                               |Always allow use of password manager                                                |
|Lock Screen                                                                    |Allow locking screen                                                                |
|Quick unlock                                                                   |Allow fingerprint and disallow the use of a PIN                                     |
|PIN auto-submit                                                                |Disable PIN auto-submit on lock and login screen                                    |
|Idle Settings                                                                  |Set an appropriate idle time. Around 5 minutes is recommended. Lock screen on sleep |
|Incognito Mode                                                                 |If you are blocking users from signing into personal Google Accounts via "Browser sign-in settings", set this to Block, otherwise set to allow incognito mode�|
|Force Ephemeral Mode                                                           |Erase all local user data�                                                          |
|Online Revocation Checks                                                       |Perform online OCSP/CRL checks                                                      |
|RC4 cipher suites in TLS                                                       |Disable RC4                                                                         |
|Local Trust Anchors Certificates                                               |Follow the publicly announced SHA-1 depreciation schedule for Local Anchors Sha1 Block Local Anchors Common Name Fallback Block Symantec Corporation's Legacy PKI Infrastructure |
|User management of installed CA certificates                                   |Disallow users from managing certificates                                           |
|User management of installed client certificates                               |Disallow users from managing certificates                                           |
|Enable renderer code integrity                                                 |Renderer code integrity enabled                                                     |
|Enable leak detection for entered credentials                                  |Enable leak detection for entered credentials                                       |
|Chrome Cleanup                                                                 |Allow Chrome Cleanup to periodically scan the system and allow manual scans. Users may choose to share results from Chrome Cleanup run with Google.|
|Third Party Code                                                               |Prevent third party code from being injected into Chrome                            |
|Audio Sandbox                                                                  |Always sandbox the audio process                                                    |
|Unsupported System Warning                                                     |Allow Chrome to display warnings when running on an unsupported system              |
|Advanced Protection program                                                    |Users enrolled in the Advanced Protection program will receive extra protections    |
|Command-line flags                                                             |Show security warnings when potentially dangerous command line flags are used.      |
|Popup interactions                                                             |Block pop-ups opened with a target of _blank from interacting with the page that opened the pop-up.|
|Remote access clients                                                          |Remote access clients should not be configured unless absolutely necessary          |
|Firewall traversal                                                             |Disable firewall traversal                                                          |
|Proxy mode                                                                     |Force the use of a specific proxy if a proxy is used. Otherwise, select�'never use a proxy'. This can be set per-network if required.|
|Ignore proxy on captive portals                                                |Ignore policies for captive portal pages                                            |
|SSL Record Splitting                                                           |Enable SSL record splitting                                                         |
|Minimum SSL version enabled                                                    |TLS 1.2                                                                             |
|SSL error override                                                             |Block users from clicking through SSL warnings                                      |
|Data Compression Proxy                                                         |Always disable data compression proxy                                               |
|DNS over HTTPS                                                                 |Enable DNS over HTTPS mode with insecure fallback                                   |
|Built-in DNS client                                                            |Always use the built in DNS client if available                                     |
|CORS legacy mode                                                               |Disable legacy mode                                                                 |
|CORS mitigations                                                               |Enable CORS mitigations                                                             |
|Always on VPN                                                                  |Enabled, if an appropriately configured Android application is deployed Do not allow user to disconnect from a VPN manually|
|Cross-origin authentication                                                    |Block cross origin authentication                                                   |
|Signed HTTP Exchange (SXG) support                                             |Accept web content served as Signed HTTP Exchanges                                  |
|Globally scoped HTTP authentication cache                                      |HTTP authentication credentials are scoped to top-level sites                       |
|Require online OCSP/CRL checks for local trust anchors                         |Use existing online revocation-checking settings                                    |
|DNS interception checks                                                        |Perform DNS interception checks                                                     |
|Legacy TLS/DTLS downgrade in WebRTC                                            |Disable WebRTC peer connections downgrading to obsolete versions of the TLS/DTLS (DTLS 1.0, TLS 1.0 and TLS 1.1) protocols|
|Control Android backup and restore service                                     |Backup and restore disabled                                                         |
|Login credentials for network authentication                                   |Dont use login credentials for network authentication                               |
|Account Management                                                             |Disable�users adding any account types                                              |
|Certificate synchronization                                                    |Enable usage of Chrome OS CA Certificates in Android apps                           |
|Screenshot                                                                     |Allow users to take screenshots and video recordings. If device accesses sensitive material this should be set to Do not allow.|
|Screen video capture                                                           |Allow sites to prompt the user to share a video stream of their screen. If device accesses sensitive material this should be set to Do not allow.|
|Default legacy SameSite cookie behavior                                        |Use SameSite-by-default behaviour for all cookies on all sites                      |
|Flash                                                                          |Block sites from running flash and do not allow the user to enable it               |
|Outdated Flash                                                                 |Disallow outdated flash                                                             |
|Popups during unloading                                                        |Prevent pages from showing popups while they are being unloaded                     |
|Strict treatment for mixed content                                             |Use strict treatment for mixed content                                              |
|Control use of insecure content exceptions                                     |Do not allow any site to load blockable mixed content                               |
|Insecure forms                                                                 |Show warnings and disable autofill on insecure forms                                |
|Occluded window rendering                                                      |Allow detection of window occlusion                                                 |
|Enable URL-keyed anonymized data collection                                    |Data collection is never active                                                     |
|Developer Tools                                                                |Never allow the use of built-in developer tools                                     |
|Multiple sign-in access                                                        |Block multiple sign-in access for users in this organisation                        |
|Sign-in to secondary accounts                                                  |Block multiple sign-in access for users in this organization                        |
|Browser guest mode                                                             |Prevent guest browser logins                                                        |
|WebRTC event log collection                                                    |Do not allow WebRTC event log collection                                            |
|URLs in the address bar                                                        |Display the full URL                                                                |
|Shared clipboard                                                               |Disable the shared clipboard feature                                                |
|Smart Lock for Chrome                                                          |Do not allow Smart Lock for Chrome                                                 |
|Messages                                                                       |Do not allow users to sync SMS messages between their phone and Chromebook          |
|Phone Hub                                                                      |Do not allow Phone Hub notifications to be enabled                                  |
|External Storage Devices                                                       |Configure this in line with corporate policy on the use of external storage devices.|
|WebUSB API                                                                     |Do not allow any site to request access                                             |
|Serial Port API                                                                |Do not allow any site to request access to serial ports via the Serial Port API     |
|Privacy screen                                                                 |Always enable the privacy screen                                                    |
|Verified Mode                                                                  |Require verified mode boot for Verified Access.                                     |
|Allow EMM partners access to device management                                 |Disable Chrome management -partner access                                           |
|Reporting                                                                      |Enable managed browser cloud reporting                                              |
|Safe Browsing                                                                  |Always enable Safe Browsing                                                         |
|Help improve Safe Browsing                                                     |Disable sending extra information to help improve Safe Browsing                     |
|Safe Browsing for trusted sources                                              |Perform safe browsing checks on all downloaded files                                |
|Download restrictions                                                          |Block dangerous downloads                                                           |
|Disable bypassing Safe Browsing warnings                                       |Do not allow users to bypass Safe Browsing warnings                                 |
|Password alert                                                                 |Trigger on password reused on phishing page                                         |
|Sites with intrusive ads                                                       |Block ads on sites with intrusive ads                                               |
|Abusive Experience Intervention                                                |Prevents sites with abusive experiences from opening new windows or tabs.           |
|Legacy Browser support                                                         |Disable legacy browser support                                                      |
|Command line access                                                            |Disable VM command line access                                                      |
|Port forwarding                                                                |Do not allow users to enable and configure port forwarding into the VM container    |
|Android apps from untrusted sources                                            |Prevent the user from using Android apps from untrusted sources                     |
|Parallels Desktop                                                             |Do not allow Parallels Desktop                                                      |
|Metrics reporting                                                              |Do not send anonymous reports of usage and crash-related data to Google             |
|Wi-Fi network configurations sync                                              |Do not allow Wi-Fi network configurations to be synced across Google Chrome OS devices and a connected Android phone|
|Chrome Management for Signed-in Users                                         |Apply all user policies when users sign into Chrome, and provide a managed Chrome experience|
|                                                                               |                                                                                    |
|Device settings                                                                |                                                                                    |
|Forced Re-enrolment                                                            |Force device to re-enrol into this domain after wiping. This will also prevent users from enabling Developer mode on the device and enforce secure boot.|
|Powerwash                                                                      |Allow Powerwash to be be triggered                                                  |
|Verified Access                                                                |Enable for Content Protection                                                       |
|Verified Mode                                                                  |Require verified mode boot for Verified Access                                      |
|Disabled device return instructions                                            |Create custom text should the device become lost                                    |
|Integrated FIDO second factor                                                  |Enable 2FA if Titan M security chip is in use.                                      |
|Guest Mode                                                                     |Do not allow guest mode                                                             |
|Sign-in Restriction                                                            |Restrict Sign-in to list of users. Enter all domains used by Google Admin with the wildcard as the username, such as: *@example.com *@sales.example.com Wildcards should not be used in the domain portion of the entries to ensure only users from managed domains and not unmanaged subdomains or third-party domains are allowed to sign in. |
|Autocomplete Domain                                                            |Do not display an autocomplete domain on the sign-in screen.                        |
|Sign-in screen                                                                 |Never show user names and photos                                                    |
|Single sign-on cookie behavior                                                 |Enable transfer of SAML SSO Cookies into user session during sign-in (if in use)    |
|System info on sign-in screen                                                  |Do not allow users to display system information on the sign-in screen              |
|Privacy screen on sign-in screen                                               |Always enable the privacy screen on sign-in screen                                  |
|Auto Update Settings                                                           |Allow auto-updates No restriction on Google Chrome version                          |
|Device Reporting                                                               |Enable device state reporting, Enable tracking recent device users                 |
|Inactive Device Notifications                                                  |Enable inactive device notifications Set inactive range, notification cadence and email addresses as appropriate for the organisation. This recommendation aims to reduce the number of unused but available devices that have access to business data.|
|Anonymous Metric Reporting                                                     |Never send metrics to Google                                                        |
|Device system log upload                                                       |Enable device system log upload                                                     |
|Bluetooth                                                                      |Disable Bluetooth unless required                                                   |
|TPM Firmware Update                                                            |Allow users to perform TPM firmware updates. Users should follow the guidance on how to update their TPM and ensure that any local documents are backed up prior to updating their device.|
|Virtual Machines                                                              |Block usage for virtual machines needed to support Linux apps, unless specifically required for a sub-set of users (which are placed in a separate OU)|
|Allow EMM partners access to device management                                 |Disable Chrome management  - partner access                                         |
|                                                                               |                                                                                    |
|Managed guest session settings                                                 |                                                                                    |
|Managed guest session                                                          |Do not allow managed guest sessions. If it needs to be enabled, configure in line with 'user and browser settings'.|
|                                                                               |                                                                                    |
|Security                                                                       |                                                                                    |
|Configure this section to organisation policy                                  |                                                                                    |
|Alert center: Rules                                                            |The following rules should be set to active, at a minimum:  - Device compromised  - Domain data export initiated  - Government-backed attacks  - Leaked password  - Malware message detected  post-delivery  - Phishing in inboxes due to bad whitelist  - Phishing message detected post-delivery  - Suspicious device activity  - Suspicious login  - Suspicious message reported  - Suspicious programmatic login  - User granted Admin privilege Consider setting others as appropriate for you organisation. |
|Data protection: Data protection rules and detectors                           |Refer to  https://support.google.com/a/answer/6321530?hl=en                         |
|Password management                                                           |Configure a strong password policy in line with company policy requirements.        |
|Less secure apps                                                               |Disable access to less secure apps for all users. This can be modified if a business case is available for allowing a less secure app.|
|2-Step Verification                                                            |Consider enforcing two step verification (2SV) for all users. On Chrome OS, two step verification is enforced only at first login. Once 2SV is enabled, it must be allowed and configured by each user individually. |
|Login Challenges                                                               |Consider implementing Login challenges as an additional security measure to verify the identity of users if suspicious login attempts are detected|
|Advanced Protection Program                                                    |Enable user enrollment                                                              |
