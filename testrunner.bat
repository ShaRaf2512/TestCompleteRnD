REM Clears the screen
CLS
@ECHO OFF

REM Variable to track if tests passed
set Tests_Passed=0
set Error_Level=0

IF %1.==. GOTO AccessKeyMissing
set AccessKey=%1

REM By default we run web testing
set ProjectPath="%cd%\AngularAutomation\AngularAutomation.pjs"

IF "%2" == "Mobile" GOTO MobileProjectRun
IF "%2" == "Web" GOTO WebProjectRun
IF NOT %2.==. GOTO ParamProjectPath
GOTO EchoProjectPath

:MobileProjectRun
set ProjectPath="%cd%\AngularAutomation\AngularAutomation.pjs"
GOTO EchoProjectPath

:WebProjectRun
set ProjectPath="%cd%\AngularAutomation\AngularAutomation.pjs"
GOTO EchoProjectPath

:ParamProjectPath
set ProjectPath=%2
GOTO EchoProjectPath


:EchoProjectPath
ECHO Starting TestExecute for project %ProjectPath%
ECHO ## TestExecute Run for %2 :rocket:

GOTO ExecuteTest


:ExecuteTest
REM Launches TestExecute
REM executes the specified project
REM and closes TestExecute when the run is over
"C:\Program Files (x86)\SmartBear\TestComplete 15\Bin\TestComplete.exe" %ProjectPath% /r /e /AccessKey:%AccessKey% /SilentMode /Timeout:120 /ns /ErrorLog:%cd%\logs\error.log /ExportLog:%cd%\logs\runlog.html /ExportSummary:%cd%\logs\runlog.xml /shr:%cd%\logs\shared-repo-link.txt /shrn:LogFromGitHubAction /shrei:7

set Error_Level=%ERRORLEVEL%
ECHO TestExecute execution finished with code: %Error_Level% 

IF "%Error_Level%" == "1001" GOTO NotEnoughDiskSpace
IF "%Error_Level%" == "1000" GOTO AnotherInstance
IF "%Error_Level%" == "127" GOTO DamagedInstall
IF "%Error_Level%" == "4" GOTO Timeout
IF "%Error_Level%" == "3" GOTO CannotRun
IF "%Error_Level%" == "2" GOTO Errors
IF "%Error_Level%" == "1" GOTO Warnings
IF "%Error_Level%" == "0" GOTO Success
IF "%Error_Level%" == "-1" GOTO LicenseFailed
IF NOT "%Error_Level%" == "0" GOTO UnexpectedErrors

:NotEnoughDiskSpace
ECHO :x: There is not enough free disk space to run TestExecute
GOTO GenerateReport

:AnotherInstance
ECHO :x: Another instance of TestExecute is already running 
GOTO GenerateReport

:DamagedInstall
ECHO :x: TestExecute installation is damaged or some files are missing 
GOTO GenerateReport

:Timeout
ECHO :x: Timeout elapsed 
GOTO GenerateReport

:CannotRun
ECHO :x: The script cannot be run 
GOTO GenerateReport

:Errors
ECHO :x: There are errors 
GOTO GenerateReport

:Warnings
ECHO :warning: There are warnings 
set Tests_Passed=1
GOTO GenerateReport

:Success
ECHO :white_check_mark: No errors
set Tests_Passed=1
GOTO GenerateReport

:LicenseFailed
ECHO :x: License check failed 
GOTO GenerateReport

:UnexpectedErrors
ECHO :x: Unexpected Error: %Error_Level% 
GOTO GenerateReport

:AccessKeyMissing
ECHO :x: Access Key is missing. Usage: 
ECHO "test-runner.bat %AccessKey% %ProjectPath%" 
ECHO Project Path is optional, if not defined, will try to run desktop project. 
GOTO End

:GenerateReport
IF EXIST "%cd%\logs\error.log" GOTO PrintErrorLog
IF EXIST "%cd%\logs\shared-repo-link.txt" GOTO PrintURL
IF EXIST "%cd%\logs\runlog.xml" GOTO ReportFound
ECHO :x: Error. No logs or reports found!!! 
GOTO End

:PrintErrorLog
ECHO :x: Error log found. This is the content: 
type %cd%\logs\error.log |
IF EXIST "%cd%\logs\shared-repo-link.txt" GOTO PrintURL
IF EXIST "%cd%\logs\runlog.xml" GOTO ReportFound
GOTO End

:PrintURL
ECHO :bar_chart: Shared repo created: 
type %cd%\logs\shared-repo-link.txt 
IF EXIST "%cd%\logs\runlog.xml" GOTO ReportFound
GOTO End

:ReportFound
ECHO Local report file found!
GOTO End

:End
IF "%Tests_Passed%" == "1" GOTO OkEnd
exit /b %Error_Level%

:OkEnd
