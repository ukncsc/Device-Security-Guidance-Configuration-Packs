# iOS/iPadOS Restrictions (com.apple.applicationaccess) 

> **Columns:** *Setting · *XML Key* · *Value*  

## General
| Setting | XML Key | Value |
|---|---|---|
| Allow Camera | `allowCamera` | Yes |
| Allow Device Name Modification | `allowDeviceNameModification` | Yes |
| Allow Device Sleep | `allowDeviceSleep` | Yes |
| Allow FaceTime | `allowVideoConferencing` | Yes |
| Allow Handoff | `allowActivityContinuation` | Yes |
| Allow Screenshots and Screen Recording | `allowScreenShot` | Yes |
| Allow Setting Up New Devices via Proximity | `allowProximitySetupToNewDevice` | No |
| Allow Voice Dialing | `allowVoiceDialing` | No |
| Allow Wallpaper Modification | `allowWallpaperModification` | Yes |
| Classroom: Allow Unprompted App and Device Lock | `forceClassroomUnpromptedAppAndDeviceLock` | No |
| Classroom: Allow Unprompted Screen Observation | `forceClassroomUnpromptedScreenObservation` | No |
| Classroom: Automatically Join Classes | `forceClassroomAutomaticallyJoinClasses` | No |
| Classroom: Require Permission to Leave Classes | `forceClassroomRequestPermissionToLeaveClasses` | No |
| Force Automatic Date & Time | `forceAutomaticDateAndTime` | No |

## Lock Screen
| Setting | XML Key | Value |
|---|---|---|
| Allow Control Center on Lock Screen | `allowLockScreenControlCenter` | No |
| Allow Notification Center on Lock Screen | `allowLockScreenNotificationsView` | No |
| Allow Today View on Lock Screen | `allowLockScreenTodayView` | No |
| Allow Wallet (Passbook) on Lock Screen | `allowPassbookWhileLocked` | Yes |

## USB & Pairing
| Setting | XML Key | Value |
|---|---|---|
| Allow Pairing with Non‑Configurator Hosts | `allowHostPairing` | No |
| USB Restricted Mode (Disallow USB Accessories While Locked) | `allowUSBRestrictedMode` | Yes |

## Apps
| Setting | XML Key | Value |
|---|---|---|
| Allow App Clips | `allowAppClips` | Yes |
| Allow App Installation via App Store | `allowUIAppInstallation` | Yes |
| Allow Automatic App Downloads | `allowAutomaticAppDownloads` | Yes |
| Allow iMessage | `allowChat` | Yes |
| Allow Installing Apps | `allowAppInstallation` | No |
| Allow Removing Apps | `allowAppRemoval` | Yes |
| Allow Removing System Apps | `allowSystemAppRemoval` | Yes |
| Allow Trusting New Enterprise App Authors | `allowEnterpriseAppTrust` | No |
| Restrict App Usage (Disallow These Apps) | `blacklistedAppBundleIDs` | com.apple.shortcuts |

## Managed Open-In
| Setting | XML Key | Value |
|---|---|---|
| Allow Documents from Managed Sources in Unmanaged Destinations | `allowOpenFromManagedToUnmanaged` | No |
| Allow Documents from Unmanaged Sources in Managed Destinations | `allowOpenFromUnmanagedToManaged` | No |
| Allow Managed Apps to Store Data in iCloud | `allowManagedAppsCloudSync` | No |
| Allow Managed Books Backup | `allowEnterpriseBookBackup` | Yes |
| Allow Managed Books Metadata Sync | `allowEnterpriseBookMetadataSync` | No |
| Treat AirDrop as Unmanaged Destination | `forceAirDropUnmanaged` | Yes |

## iCloud
| Setting | XML Key | Value |
|---|---|---|
| Allow iCloud Backup | `allowCloudBackup` | No |
| Allow iCloud Drive (Documents & Data) | `allowCloudDocumentSync` | No |
| Allow iCloud Keychain | `allowCloudKeychainSync` | No |
| Allow iCloud Photos | `allowCloudPhotoLibrary` | No |
| Allow My Photo Stream | `allowPhotoStream` | No |
| Allow Shared Albums | `allowSharedStream` | No |

## Safari
| Setting | XML Key | Value |
|---|---|---|
| Allow Safari | `allowSafari` | Yes |
| Safari: Accept Cookies | `safariAcceptCookies` | 1.5 |
| Safari: Allow AutoFill | `safariAllowAutoFill` | Yes |
| Safari: Allow JavaScript | `safariAllowJavaScript` | Yes |
| Safari: Allow Pop‑ups | `safariAllowPopups` | No |
| Safari: Fraudulent Website Warning | `safariForceFraudWarning` | Yes |

## AirPrint
| Setting | XML Key | Value |
|---|---|---|
| Allow AirPrint | `allowAirPrint` | Yes |
| Allow AirPrint Credentials Storage | `allowAirPrintCredentialsStorage` | Yes |
| Allow AirPrint iBeacon Discovery | `allowAirPrintiBeaconDiscovery` | Yes |
| Require Trusted TLS for AirPrint | `forceAirPrintTrustedTLSRequirement` | Yes |

## AirPlay
| Setting | XML Key | Value |
|---|---|---|
| Allow AirPlay Incoming Requests | `allowAirPlayIncomingRequests` | Yes |
| Allow Remote App Pairing | `allowRemoteAppPairing` | Yes |

## Game Center
| Setting | XML Key | Value |
|---|---|---|
| Allow Adding Game Center Friends | `allowAddingGameCenterFriends` | Yes |
| Allow Game Center | `allowGameCenter` | Yes |
| Allow Multiplayer Gaming | `allowMultiplayerGaming` | Yes |

## Keyboard & Input
| Setting | XML Key | Value |
|---|---|---|
| Allow Auto-Correction | `allowAutoCorrection` | Yes |
| Allow Dictation | `allowDictation` | Yes |
| Allow Keyboard Shortcuts | `allowKeyboardShortcuts` | Yes |
| Allow Look Up (Dictionary) | `allowDefinitionLookup` | Yes |
| Allow Predictive Keyboard | `allowPredictiveKeyboard` | Yes |
| Allow Slide to Type | `allowContinuousPathKeyboard` | Yes |
| Allow Spell Check | `allowSpellCheck` | Yes |

## Notifications
| Setting | XML Key | Value |
|---|---|---|
| Allow Notifications Settings Modification | `allowNotificationsModification` | Yes |

## Search
| Setting | XML Key | Value |
|---|---|---|
| Allow Spotlight Internet Results | `allowSpotlightInternetResults` | Yes |

## Files
| Setting | XML Key | Value |
|---|---|---|
| Allow Files Access to Network Drives | `allowFilesNetworkDriveAccess` | No |
| Allow Files Access to USB Drives | `allowFilesUSBDriveAccess` | No |

## Apple Watch
| Setting | XML Key | Value |
|---|---|---|
| Allow Apple Watch Auto‑Unlock | `allowAutoUnlock` | Yes |
| Allow Pairing with Apple Watch | `allowPairedWatch` | No |
| Force Apple Watch Wrist Detection | `forceWatchWristDetection` | No |

## Network & Connectivity
| Setting | XML Key | Value |
|---|---|---|
| Allow Adding VPN Configurations | `allowVPNCreation` | No |
| Allow App Cellular Data Modification | `allowAppCellularDataModification` | Yes |
| Allow Background App Refresh While Roaming | `allowGlobalBackgroundFetchWhenRoaming` | Yes |
| Allow Bluetooth Modification | `allowBluetoothModification` | Yes |
| Allow Cellular Plan Modification (eSIM) | `allowCellularPlanModification` | Yes |
| Allow eSIM Modification | `allowESIMModification` | Yes |
| Allow Personal Hotspot Modification | `allowPersonalHotspotModification` | Yes |
| Force Wi‑Fi Power On | `forceWiFiPowerOn` | No |
| Force Wi‑Fi Whitelisting | `forceWiFiWhitelisting` | No |

## Security & Privacy
| Setting | XML Key | Value |
|---|---|---|
| Allow Enabling Restrictions (Screen Time) | `allowEnablingRestrictions` | Yes |
| Allow Erase All Content and Settings | `allowEraseContentAndSettings` | No |
| Allow Find My | `allowFindMyDevice` | No |
| Allow Find My Friends/People | `allowFindMyFriends` | No |
| Allow Installing Configuration Profiles (UI) | `allowUIConfigurationProfileInstallation` | No |
| Allow Passcode Modification | `allowPasscodeModification` | Yes |
| Allow Password AutoFill | `allowPasswordAutoFill` | Yes |
| Allow Password Sharing | `allowPasswordSharing` | No |
| Allow Personalized Ads by Apple | `allowApplePersonalizedAdvertising` | No |
| Allow Proximity‑based Password Sharing Requests | `allowPasswordProximityRequests` | No |
| Allow Remote Screen Observation | `allowRemoteScreenObservation` | Yes |
| Allow Sending Diagnostic Data to Apple | `allowDiagnosticSubmission` | No |
| Allow Touch ID Fingerprint Modification | `allowFingerprintModification` | Yes |
| Allow Touch ID for Unlock | `allowFingerprintForUnlock` | Yes |
| Allow Unpaired External Boot to Recovery | `allowUnpairedExternalBootToRecovery` | No |
| Allow Untrusted TLS Certificate Prompt | `allowUntrustedTLSPrompt` | No |
| Force Encrypted Backups | `forceEncryptedBackup` | Yes |
| Force Limit Ad Tracking | `forceLimitAdTracking` | Yes |
| Modify Account Settings | `allowAccountModification` | No |
| Require Face ID / Touch ID Before AutoFill | `forceAuthenticationBeforeAutoFill` | Yes |

## Software Updates
| Setting | XML Key | Value |
|---|---|---|
| Defer Software Updates | `forceDelayedSoftwareUpdates` | No |

## Siri
| Setting | XML Key | Value |
|---|---|---|
| Allow Siri | `allowAssistant` | Yes |
| Allow Siri While Locked | `allowAssistantWhileLocked` | No |
| Force Siri Profanity Filter | `forceAssistantProfanityFilter` | No |

## Media & App Store
| Setting | XML Key | Value |
|---|---|---|
| Allow Apple Books | `allowBookstore` | Yes |
| Allow Apple Music | `allowMusicService` | Yes |
| Allow Apple News | `allowNews` | Yes |
| Allow Apple Radio | `allowRadioService` | Yes |
| Allow In‑App Purchases | `allowInAppPurchases` | Yes |
| Allow iTunes Store | `allowiTunes` | Yes |
| Require iTunes Store Password for Purchases | `forceITunesStorePasswordEntry` | No |
