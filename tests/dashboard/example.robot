*** Settings ***
Resource        ../../resources/util_dashboard.robot
Suite Setup      Run Keywords     Open Enerkey    Log in small profile
Suite Teardown   Suite tear down
Test Teardown    Test tear down

*** Test Cases ***

Example test case
    [Documentation]  Write here one simple robot test. Feel free to use keywords found in enerkey_ui. Start case with "Wait for loading".
    [Tags]
    Wait for loading


Example test case title
    [Documentation]  Plan and list other test cases that you suggest that should be written for EnerKey dashboard ie EnerKey frontpage for Robot regression test set.
    ...              Note: Listing for frontpage is enough, no neeed to write executable Robot cases or cover other portal features.
    [Tags]           ignore
