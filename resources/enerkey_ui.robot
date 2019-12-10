*** Settings ***
Documentation    Keywords and variables for working with the Enerkey Portal UI using Selenium2Library.
Library          Selenium2Library       timeout=60             implicit_wait=${SELENIUM IMPLICIT WAIT}
Library          Collections
Library          BuiltIn

*** Variables ***
${USER MENU}          xpath=//ul[contains(@class, 'navbar-user')]//a[@class='dropdown-toggle']
${BOOKMARKS LINK}     xpath=//a[@ng-controller='BookmarkController']
${MOBILE UI WIDTH}    641
${MOBILE UI HEIGHT}   1000

*** Keywords ***
Open Enerkey
    [Documentation]  Opens a browser window and points it to the login screen of the portal
    ...              for the currently configured environment.
    ${capabilities}=       Create Dictionary    marionette=${True}
    ${iecapabilities}=     Evaluate             sys.modules['selenium.webdriver'].DesiredCapabilities.INTERNETEXPLORER  sys, selenium.webdriver
    Set To Dictionary      ${iecapabilities}    ignoreProtectedModeSettings=${True}   RequireWindowFocus=${True}
    ${capabilities}=       Set Variable If      '${BROWSER}' == 'ie'   ${iecapabilities}
    Open browser           url=${PORTAL_URL}    browser=${BROWSER}    remote_url=${SELENIUM_URL}    desired_capabilities=${capabilities}
    Run Keyword If         '${MOBILE_UI}' == 'False'
    ...                    Set Window Size           1920                  1080
    ...  ELSE              Set Window Size           ${MOBILE UI WIDTH}    ${MOBILE UI HEIGHT}

Log in
    [Documentation]  Log in using the login screen with the given email and password.
    [Arguments]                          ${email}                    ${password}
    Wait Until Element Is Visible        //input[@name="Email"]
    Click Element                        //input[@name="Email"]
    Input text                           //input[@name="Email"]   ${email}
    Input text                           //input[@name="Password"]   ${password}
    Click button                         //button[@type="submit"]
    Wait until element is visible        //div[@class='enerkey-logo']
    Wait for loading
    Extract Bearer Token

Extract Bearer Token
    [Documentation]  Do a little javascript trick to get the bearer token the frontend uses to authenticate to the backend.
    ...              This allows calling the backend from tests as well.
    ${token}=                            Execute Javascript       return angular.element('body').injector().get('UserService').getAccessToken()
    ${BEARER TOKEN}=                     Set Variable    Bearer ${token}
    Set Global Variable  ${BEARER TOKEN}

Log in small profile
    Log in                               &{SMALLPROFILE_CREDENTIALS}


Close Enerkey
   Close Browser

Wait for loading
    [Documentation]  Wait until the bottom loading indicator is not visible on the screen.
    [Arguments]      ${timeout}=${None}
    Set Selenium Implicit Wait           3
    Wait Until Page Does Not Contain Element  //div[@class='loadingIndicator no-print']    timeout=${timeout}
    Set Selenium Implicit Wait           ${SELENIUM_IMPLICIT_WAIT}

Open bookmark
    [Documentation]  Click on the bookmark with the specified name in top right bookmark tools.
    [Arguments]      ${name}    ${modal}=yes
    Run Keyword If  $MOBILE_UI           Click Element    CSS=.menu-bars-icon
    Wait until element is visible        ${BOOKMARKS LINK}
    Scroll element into view             ${BOOKMARKS LINK}
    Click Link                           ${BOOKMARKS LINK}
    Wait for loading
    ${element}=                          Set variable                 //a[@ng-click='bookmarkClicked(bookmark)'and contains(.,'${name}')]
    Wait Until Element Is Visible        ${element}
    Click link                           ${element}
    Wait Until Element Is Not Visible    ${element}
    Wait for loading

Close modal
    Click Element                        //button[@ng-click='$ctrl.onCloseClick()']

Suite tear down
    Close Enerkey

Tear down
    Run Keyword If Test Failed           Capture Page Screenshot
    Close Enerkey

Test tear down
    Run Keyword If Test Failed           Capture Page Screenshot
    Run Keyword If Test Failed           Go to      ${PORTAL_URL}
    Run Keyword If Test Failed           Wait for loading
