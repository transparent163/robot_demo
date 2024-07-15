*** Settings ***
Library    SeleniumLibrary
Library    XML
Resource    Util.robot

*** Test Cases ***
Test Case - Test Unitl
    Open Browser    https://co-release-11.shimorelease.com/sdk/demo/    Chrome
    Wait Until Element Is Visible And Enabled    id=login_email

    Input Text    id=login_email    test1@shimo.im
    Input Password    id=login_password    12345678
    Click Button    xpath=//button[contains(@class, "ant-btn-primary")]

    Wait Until Element Is Visible And Enabled    xpath=//span[contains(@class, "eventsIcon")]
    Click Element    xpath=//span[contains(@class, "eventsIcon")]

    Retry Wait Element   xpath=//a[contains(@href, "/test-api")]
    Click Element    xpath=//a[contains(@href, "/test-api")]

    Wait Until Element Is Visible And Enabled  id=rc-tabs-1-tab-FileIOResMap
    Click Element    id=rc-tabs-1-tab-FileIOResMap

    Retry Wait Element    xpath=//tr[@data-row-key="1"]/td/span[@aria-label="unordered-list"]
    Click Element    xpath=//tr[@data-row-key="1"]/td/span[@aria-label="unordered-list"]

    Retry Wait Element   xpath=//button/span[text()="复 制"]
    Click Element    xpath=//button/span[text()="复 制"]
    
