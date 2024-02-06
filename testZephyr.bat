REM Clears the screen
CLS
@ECHO OFF

:ExecuteTest
REM Launches TestExecute
REM executes the specified project
REM and closes TestExecute when the run is over
curl "https://plugins.jenkins.io/zephyr-enterprise-test-management/"

:OkEnd