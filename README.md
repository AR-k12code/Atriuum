# Atriuum Automated Uploader

These scripts come without warranty of any kind. Use them at your own risk. I assume no liability for the accuracy, correctness, completeness, or usefulness of any information provided by this site nor for any sort of damages using these scripts may cause.

This script was written because as of April 2022 Atriuum Booksystems said about their Python AutoPatronImport tool working with Python 3: "We are currently only running our scripts off of Python 2.7 when we install ... unable to guarantee no issues running version 3."  Their tool does not in fact work with Python 3. I would like to point out that Atriuum is asking people to install a deprecated version of Python 2, on production machines, while not supporting Python 3 which was released in 2008.  It is now April 2022. What. The. Heck!?

# Warning!!!
Do not use this unless you already have the Patron Link Identifier as the Student ID. If you have the barcode as the Student ID you can put in a ticket to have it copied to the Patron Link Identifier.

# Suggested install process
````
mkdir \Scripts
cd \Scripts
git clone https://github.com/AR-k12code/Atriuum.git
Copy-Item .\atriuum\resources\settings-sample.json .\atriuum\settings.json -Confirm:$true -Verbose
````

# Dependencies
This project *CAN* use the CognosDownloader from https://github.com/AR-k12code/CognosDownloader.  It must be installed using the suggested install process and configured using the CognosDefaults file.

# Data Format
Data must be a CSV. The headers do not matter but the column order does.
````
Building,Student_id,Last_name,First_name,Grade,Birthdate,Email,Reporting_class
703,5014045644,Millsap,Craig,12,10-4-2002,craig.millsap@myschool.net,10
````

````
Building,Student_id,Last_name,First_name,Grade,Birthdate,Email,Reporting_class
13,123456789,Doe,John,PK,7-18-2017,john.doe@myschool.net,PK
13,123456789,Doe,Jane,KF,7-18-2018,john.doe@myschool.net,KF
13,123456789,Doe,Jane,K,7-18-2018,john.doe@myschool.net,K
````

# Settings
The resources\settings-sample.json file is provided as an example for how to configure the script. This is a json formatted file.

Copy this file to c:\scripts\Atriuum, rename to settings.json, then edit the file.

## Location must match a Physical Location
I believe the default is "Main Library" but you will want to make sure by checking here:
````
Administration > Catalog > Physical Location
````

## Patron Reporting Class
The default Patron Reporting Class is the grade level. For example a student in grade 10 will get a "10th Grade" Report Class. You need to make sure there is a Patron Report Class for each grade in that building. 
```
Administration > Patrons > Patron Report Class
- "PK Grade"
- "K Grade"
- "1st Grade"
- "2nd Grade"
- "3rd Grade"
- "4th Grade" .. "12th Grade"
- "SS"
```


# Create an Import user
Create the same user with the same password for all your libraries. Please use a good randomly generated 20+ character password. Note that punctuations may cause an issue in the json settings file.
````
Administration > Library > Worker Records > Add New Worker
````
- [x] Add New Patrons
- [x] Edit Patrons
- [x] Import Patrons
- [x] Unlock The Desktop
- [x] Upload Data And Sync From Supplemental Tools

# Import Upload Definition
Upload Definition is under the resources folder.
````
Patrons > Import > Import Options > Import Definitions > Choose File
Select the Template XML file in resources.
Click Get Import Defintions.
````
