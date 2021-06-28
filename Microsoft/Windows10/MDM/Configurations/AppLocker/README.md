# Note on AppLocker Policies

Certain characters can be misinterpreted by Microsoft Endpoint Manager and then cause the Policy to not apply correctly. In the polices provided the Product Name "MICROSOFT® WINDOWS® OPERATING SYSTEM" appears in several, the character "®" can be changed when saving as different file encodings. It has been discovered that if saved as UTF-8 and uploaded into Endpoint Manager they will work as expected. The policies may still appear incorrectly in Endpoint Manager's uploaded file preview but it will intepret the value correctly.

