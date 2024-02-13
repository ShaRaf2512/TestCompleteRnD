REM Clears the screen
CLS
@ECHO OFF
IF %1.==. GOTO ZephyrScaleTokenMissing
set ZephyrScaleToken=%1

:ExecuteTest
REM Launches TestExecute
REM executes the specified project
REM and closes TestExecute when the run is over
curl -H "Authorization: %ZephyrScaleToken%" -F file= %cd%\logs\runlog.xml;type=application/xml
"https://api.zephyrscale.smartbear.com/v2/automations/executions/junit?projectKey=Project-Key-Here&autoCreateTestCases=true"


:ZephyrScaleTokenMissing
ECHO :x: ZephyrScaleToken is missing. Usage: >> "%cd%\summary.md" 2>&1
ECHO "test-runner.bat <ZephyrScaleToken> <Project Path>" >> "%cd%\summary.md" 2>&1
GOTO End

:OkEnd