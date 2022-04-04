<#

    Atriuum Automated Imports
    CAMTech Computer Services, LLC.
    Author: Craig Millsap
    https://www.camtechcs.com

#>

$currentWorkingDirectory = $PSScriptRoot

if (-Not(Test-Path "$currentWorkingDirectory\settings.json")) {
    Write-Host "Error: No settings file found. Please copy the sample settings file to the project root." -ForegroundColor Red
    exit 1
}

if (-Not(Test-Path "$currentWorkingDirectory\files")) {
    New-Item -Name "files" -Path "$currentWorkingDirectory" -ItemType Directory -Force
}

try {
    $settings = (Get-Content "$currentWorkingDirectory\settings.json") | ConvertFrom-Json
} catch {
    Write-Host "Error: Failed to import settings.json. Please be sure the file is properly json formatted." -ForegroundColor Red
    exit 1
}

$settings.libraries | ForEach-Object {

    $library = $PSItem

    if ($library.enabled -eq $True) {
        Write-Host "Info: Processings library $($library.libraryPrefix) using file $($library.filePath)"
    } else {
        Write-Host "Info: Library $($library.libraryPrefix) is disabled in the settings file. Skipping."
        return
    }

    #Lets test for the file to upload first and get the filehash.
    if (Test-Path $library.filePath) {
        $filePath = $library.filePath
        $fileHash = (Get-FileHash $library.filePath).Hash
    } elseif (Test-Path "$currentWorkingDirectory\files\$($library.filePath)") {
        $filePath = "$currentWorkingDirectory\files\$($library.filePath)"
        $fileHash = (Get-FileHash "$currentWorkingDirectory\files\$($library.filePath)").Hash
    } else {
        #no file found. If Cognos Downloader is not enabled then we need to hard exit.
        if ($library.pullfromCognos -eq $false) {
            Write-Host "Error: File missing for $($library.libraryPrefix). Please enable Cognos Download OR ensure the specified file exists." -ForegroundColor Red
            exit 1
        }
    }

    if ($library.pullfromCognos -eq $True) {
        $filePath = "$currentWorkingDirectory\files\$($library.filePath)"

        #We need to download the file and save it to the $filePath.
        $global:progressPreference = 'silentlyContinue'
        & ..\CognosDownload.ps1 -report "Atriuum" -cognosfolder "_Shared Data File Reports/Library Systems/Atriuum" -TeamContent -savepath "$currentWorkingDirectory\files" -reportparams "$($library.cognosParameters)" -FileName "$($library.filePath)"
        $global:progressPreference = 'Continue'

        #If we get an error code we need to stop processing this library.
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: Failed to download latest student data from Cognos. Please check your prompts. We will continue with other libraries." -ForegroundColor Red
            return
        }

        #Lets compare our downloaded file to see if we have any work to do.
        if ($fileHash -eq ((Get-FileHash $filePath).Hash)) {
            Write-Host "Info: No changes since last file download. No work to do."
            return
        }
    }

    $uploadForm = @{
        'ContinueImport'        = ""
        'StartImport'           = ""
        'NoThread'              = ""
        'pagename'              = "ImportResult.xml"
        'what'                  = "Patron"
        'doInlineLogin'         = "true"
        'username'              = "$($settings.username)"
        'password'              = "$($settings.password)"
        'location'              = "$($library.location)"
        'ImportID'              = ''
        'ImportName'            = "$($settings.importName)"
        'email'                 = ''
        'ImportFileData'        = Get-Item -Path $filePath
        'skiplines'             = "on"
        'numberoflinestoskip'   = 1
    }

    try {

        $response = Invoke-RestMethod `
            -UserAgent 'AutoPatronImporter' `
            -Headers @{ "Accept-Encoding"="identity"; "Content-Type"="multipart/form-data" } `
            -Uri "https://$($settings.atriuumURL)/libs/$($library.libraryPrefix)/Import" `
            -Method 'POST' `
            -Form $uploadForm

        if ($response.importresult) {

            if ($response.inputresult.failure) {
                Write-Host "Info: Errors were detected on the server side... 
                $($response.importresult.failure.message)
                $($response.inputresult.failure.error.message)"
            } 
            
            if ($response.importresult.success) {
                $response.importresult.success.message
            }

        } else {
            Write-Host "Error: Did not get an expected response from the server." -ForegroundColor Red
        }
        

    } catch {
        $PSitem
        Write-Host "Error: Failed to submit the updated student file to ""https://$($settings.atriuumURL)/libs/$($library.libraryPrefix)/Import"""
        exit 1
    }

}