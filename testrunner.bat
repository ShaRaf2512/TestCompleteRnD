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

IF "%2" == "AngularAutomation" GOTO WebProjectRun
GOTO EchoProjectPath

:WebProjectRun
set ProjectPath="%cd%\AngularAutomation\AngularAutomation.pjs"
GOTO EchoProjectPath

:ParamProjectPath
set ProjectPath=%2
GOTO EchoProjectPath

:EchoProjectPath
ECHO Starting TestExecute for project %ProjectPath%
ECHO ## TestExecute Run for %2 :rocket: >> "%cd%\summary.md" 2>&1
ECHO: >> "%cd%\summary.md" 2>&1
GOTO ExecuteTest


:ExecuteTest
REM Launches TestExecute
REM executes the specified project
REM and closes TestExecute when the run is over
"C:\Program Files (x86)\SmartBear\TestComplete 15\Bin\TestComplete.exe" %ProjectPath% /r /e /AccessKey:%AccessKey% /SilentMode /Timeout:1800 /ns /ErrorLog:%cd%\logs\error.log /ExportLog:%cd%\logs\runlog.html /ExportSummary:%cd%\logs\runlog.xml /shr:%cd%\logs\shared-repo-link.txt /shrn:LogFromGitHubAction /shrei:7

set Error_Level=%ERRORLEVEL%
ECHO TestExecute execution finished with code: %Error_Level% >> "%cd%\summary.md" 2>&1
ECHO: >> "%cd%\summary.md" 2>&1

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
ECHO :x: There is not enough free disk space to run TestExecute >> "%cd%\summary.md" 2>&1
GOTO GenerateReport

:AnotherInstance
ECHO :x: Another instance of TestExecute is already running >> "%cd%\summary.md" 2>&1
GOTO GenerateReport

:DamagedInstall
ECHO :x: TestExecute installation is damaged or some files are missing >> "%cd%\summary.md" 2>&1
GOTO GenerateReport

:Timeout
ECHO :x: Timeout elapsed >> "%cd%\summary.md" 2>&1
GOTO GenerateReport

:CannotRun
ECHO :x: The script cannot be run >> "%cd%\summary.md" 2>&1
GOTO GenerateReport

:Errors
ECHO :x: There are errors >> "%cd%\summary.md" 2>&1
GOTO GenerateReport

:Warnings
ECHO :warning: There are warnings >> "%cd%\summary.md" 2>&1
set Tests_Passed=1
GOTO GenerateReport

:Success
ECHO :white_check_mark: No errors>> "%cd%\summary.md" 2>&1
set Tests_Passed=1
GOTO GenerateReport

:LicenseFailed
ECHO :x: License check failed >> "%cd%\summary.md" 2>&1
GOTO GenerateReport

:UnexpectedErrors
ECHO :x: Unexpected Error: %Error_Level% >> "%cd%\summary.md" 2>&1
GOTO GenerateReport

:AccessKeyMissing
ECHO :x: Access Key is missing. Usage: >> "%cd%\summary.md" 2>&1
ECHO "test-runner.bat <AccessKey> <Project Path>" >> "%cd%\summary.md" 2>&1
ECHO Project Path is optional, if not defined, will try to run desktop project. >> "%cd%\summary.md" 2>&1
GOTO End

:GenerateReport
IF EXIST "%cd%\logs\error.log" GOTO PrintErrorLog
IF EXIST "%cd%\logs\shared-repo-link.txt" GOTO PrintURL
IF EXIST "%cd%\logs\runlog.xml" GOTO ReportFound
ECHO :x: Error. No logs or reports found!!! >> "%cd%\summary.md" 2>&1
GOTO End

:PrintErrorLog
ECHO :x: Error log found. This is the content: >> "%cd%\summary.md" 2>&1
type %cd%\logs\error.log >> "%cd%\summary.md" 2>&1
IF EXIST "%cd%\logs\shared-repo-link.txt" GOTO PrintURL
IF EXIST "%cd%\logs\runlog.xml" GOTO ReportFound
GOTO End

:PrintURL
ECHO :bar_chart: Shared repo created: >> "%cd%\summary.md" 2>&1
type %cd%\logs\shared-repo-link.txt >> "%cd%\summary.md" 2>&1
IF EXIST "%cd%\logs\runlog.xml" GOTO ReportFound
GOTO End

:ReportFound
ECHO Local report file found!
GOTO End

:End
IF "%Tests_Passed%" == "1" GOTO OkEnd
exit /b %Error_Level%

:OkEnd
