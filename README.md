# Atriuum Automated Uploader

These scripts come without warranty of any kind. Use them at your own risk. I assume no liability for the accuracy, correctness, completeness, or usefulness of any information provided by this site nor for any sort of damages using these scripts may cause.

This script was written because as of April 2022 Atriuum Booksystems said about their Python AutoPatronImport tool working with Python 3: "We are currently only running our scripts off of Python 2.7 when we install ... unable to guarantee no issues running version 3."  Their tool does not infact work with Python 3. I would like to point out that Atriuum is asking people to install a deprecated version of Python 2, on production machines, while not supporting Python 3 which was released in 2008.  It is now April 2022. What. The. Heck!?

# Suggested install process
````
mkdir \Scripts
cd \Scripts
git clone https://github.com/AR-k12code/Atriuum.git
Copy-Item .\atriuum\resources\settings-sample.json .\atriuum\settings.json -Confirm:$true -Verbose
````

# Dependencies
This project can use the CognosDownloader from https://github.com/AR-k12code/CognosDownloader.  It must be installed using the suggested install process and configured using the CognosDefaults file.

# Settings
The resources\settings-sample.json file is provided as an example for how to configure the script. Copy this file to c:\scripts\Atriuum, rename to settings.json, then edit the file.

# Create an import user
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
