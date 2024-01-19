function DepositAmount()
{
  //Headless browser execution

  var server = "localhost";
  var capabilities = {
    "browserName": "chrome",
   // "screenResolution": "1920x1080"
  };

  var url = "https://www.way2automation.com/angularjs-protractor/banking/#/login";
  Browsers.RemoteItem(server, capabilities).Run(url);

  //Opens the specified URL in a running instance of the specified browser.
  //Browsers.Item(btChrome).Navigate("https://www.way2automation.com/angularjs-protractor/banking/#/login");
  //Maximizes the specified Window object.
  Aliases.browser.wndChrome_WidgetWin_1.Maximize();
  //Posts an information message to the test log.
  Log.Message("Launched angular-js banking application", "");
  //Clicks the 'buttonCustomerLogin' button.
  Aliases.browser.pageWwwWay2automationComAngularj.buttonCustomerLogin.ClickButton();
  //Posts an information message to the test log.
  Log.Message("Clicked on customer login", "");
  //Selects the 'Harry Potter' item of the 'selectUserDropDown' combo box.
  Aliases.browser.pageWwwWay2automationComAngularj.formMyform.selectUserDropDown.ClickItem("Harry Potter");
  //Clicks the 'buttonLogin' button.
  Aliases.browser.pageWwwWay2automationComAngularj.formMyform.buttonLogin.ClickButton();
  //Clicks the 'depositButton' button.
  Aliases.browser.pageWwwWay2automationComAngularj.depositButton.ClickButton();
  //Clicks the 'numberinput' control.
  Aliases.browser.pageWwwWay2automationComAngularj.formMyform2.numberinput.Click();
  //Sets the text '100' in the 'numberinput' text editor.
  Aliases.browser.pageWwwWay2automationComAngularj.formMyform2.numberinput.SetText("100");
  //Clicks the 'buttonDeposit2' button.
  Aliases.browser.pageWwwWay2automationComAngularj.formMyform2.buttonDeposit2.ClickButton();
  //Posts an information message to the test log.
  Log.Message("User selects customer and deposits ", "");
  //Checks whether the 'Exists' property of the Aliases.browser.pageWwwWay2automationComAngularj.depositSuccessfulTxt object equals True.
  aqObject.CheckProperty(Aliases.browser.pageWwwWay2automationComAngularj.depositSuccessfulTxt, "Exists", cmpEqual, true);
  //Posts an information message to the test log.
  Log.Message("Sucessfully validated deposit message", "");
  //Closes the 'wndChrome_WidgetWin_1' window.
  Aliases.browser.wndChrome_WidgetWin_1.Close();
  //Posts an information message to the test log.
  Log.Message("Close browser", "");
}