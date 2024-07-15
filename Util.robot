*** Settings ***
Library  OperatingSystem
Library  String
Library  Collections
# Library  requests
Library  Process
# Library  SSHLibrary  1 minute
Library  DateTime
Library  SeleniumLibrary  60  10
# Library  JSONLibrary

*** Keywords ***
Wait Until Element Is Visible And Enabled
    [Arguments]  ${element}
    Wait Until Element Is Visible  ${element}
    Wait Until Element Is Enabled  ${element}

Retry Action Keyword
    [Arguments]  ${keyword}  @{param}
    Retry Keyword N Times When Error  4  ${keyword}  @{param}

Retry Action Keyword And No Output
    [Arguments]  ${keyword}  @{param}
    ${prev_lvl}  Set Log Level  NONE
    Retry Keyword N Times When Error  4  ${keyword}  @{param}
    ${prev_lvl}  Set Log Level  ${prev_lvl}

Retry Wait Element
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Wait Until Element Is Visible And Enabled  @{param}

Retry Wait Element Visible
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Wait Until Element Is Visible  @{param}

Retry Wait Element Not Visible
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Wait Until Element Is Not Visible  @{param}

Retry Wait Element Should Be Disabled
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Element Should Be Disabled  @{param}

Retry Element Click
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Element Click  @{param}

Retry Button Click
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Button Click  @{param}

Retry Text Input
    [Arguments]  ${element_xpath}  ${text}
    @{param}  Create List  ${element_xpath}  ${text}
    Retry Action Keyword  Text Input  @{param}

Retry Password Input
    [Arguments]  ${element_xpath}  ${text}
    Retry Action Keyword And No Output  Text Input  ${element_xpath}  ${text}

Retry Clear Element Text
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Clear Element Text  @{param}

Retry Link Click
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Link Click  @{param}

Retry Checkbox Should Be Selected
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Checkbox Should Be Selected  @{param}

Retry Checkbox Should Not Be Selected
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Checkbox Should Not Be Selected  @{param}

Retry Wait Until Page Contains
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Wait Until Page Contains  @{param}

Retry Wait Until Page Does Not Contains
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Wait Until Page Does Not Contain  @{param}

Retry Wait Until Page Contains Element
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Wait Until Page Contains Element  @{param}

Retry Wait Until Page Not Contains Element
    [Arguments]  ${element_xpath}
    @{param}  Create List  ${element_xpath}
    Retry Action Keyword  Wait Until Page Does Not Contain Element  @{param}

Retry Wait Element Count
    [Arguments]  ${element_xpath}  ${expected_count}  ${times}=11
    ${expected_count}=  Convert To Integer  ${expected_count}
    FOR  ${n}  IN RANGE  1  ${times}
        ${actual_count}=  Get Element Count  ${element_xpath}
        ${result}=  Set Variable If  ${expected_count} == ${actual_count}  True  False
        Exit For Loop If  ${result}
        Sleep  2
    END
    Should Be True  ${result}

Retry Select Object
    [Arguments]  ${obj_name}
    @{param}  Create List  ${obj_name}
    Retry Action Keyword  Select Object  @{param}

Retry Textfield Value Should Be
    [Arguments]  ${element}  ${text}
    @{param}  Create List  ${element}  ${text}
    Retry Action Keyword  Wait And Textfield Value Should Be  @{param}

Retry List Selection Should Be
    [Arguments]  ${element}  ${text}
    @{param}  Create List  ${element}  ${text}
    Retry Action Keyword  Wait And List Selection Should Be  @{param}

Link Click
    [Arguments]  ${element_xpath}
    Click Link  ${element_xpath}

Wait And List Selection Should Be
    [Arguments]  ${element}  ${text}
    Wait Until Element Is Visible And Enabled  ${element}
    List Selection Should Be  ${element}  ${text}

Wait And Textfield Value Should Be
    [Arguments]  ${element}  ${text}
    Wait Until Element Is Visible And Enabled  ${element}
    Textfield Value Should Be  ${element}  ${text}

Element Click
    [Arguments]  ${element_xpath}
    Wait Until Element Is Visible And Enabled  ${element_xpath}
    Click Element  ${element_xpath}
    Sleep  1

Button Click
    [Arguments]  ${element_xpath}
    Wait Until Element Is Visible And Enabled  ${element_xpath}
    Click button  ${element_xpath}

Text Input
    [Arguments]  ${element_xpath}  ${text}
    Wait Until Element Is Visible And Enabled  ${element_xpath}
    Input Text  ${element_xpath}  ${text}

Clear Field Of Characters
    [Arguments]  ${field}  ${character count}
    [Documentation]  This keyword pushes the BACKSPACE key a specified number of times in a specified field.
    FOR  ${index}  IN RANGE  ${character count}
        Press Keys  ${field}  BACKSPACE
    END

Wait Unitl Command Success
    [Arguments]  ${cmd}  ${times}=5
    FOR  ${n}  IN RANGE  1  ${times}
        Log  Trying ${cmd}: ${n} ...  console=True
        ${rc}  ${output}=  Run And Return Rc And Output  ${cmd}
        Exit For Loop If  '${rc}'=='0'
    END
    Log  Command Result is ${output}
    Should Be Equal As Strings  '${rc}'  '0'
    [Return]  ${output}

Command Should be Failed
    [Arguments]  ${cmd}
    ${rc}  ${output}=  Run And Return Rc And Output  ${cmd}
    Should Not Be Equal As Strings  '${rc}'  '0'
    Log  ${output}
    [Return]  ${output}

Retry Keyword N Times When Error
    [Arguments]  ${times}  ${keyword}  @{elements}
    FOR  ${n}  IN RANGE  1  ${times}
        ${out}  Run Keyword And Ignore Error  ${keyword}  @{elements}
        Run Keyword If  '${keyword}'=='Make Swagger Client'  Exit For Loop If  '${out[0]}'=='PASS' and '${out[1]}'=='0'
        ...  ELSE  Exit For Loop If  '${out[0]}'=='PASS'
        Sleep  5
    END
    Run Keyword If  '${out[0]}'=='FAIL'  Capture Page Screenshot
    Should Be Equal As Strings  '${out[0]}'  'PASS'
    [Return]  ${out[1]}

Retry Keyword When Return Value Mismatch
    [Arguments]  ${keyword}  ${expected_value}  ${count}  @{elements}
    FOR  ${n}  IN RANGE  1  ${count}
        Log To Console  Trying ${keyword} ${n} times ...
        ${out}  Run Keyword And Ignore Error  ${keyword}  @{elements}
        Log To Console  Return value is ${out[1]}
        ${status}=  Set Variable If  '${out[1]}'=='${expected_value}'  'PASS'  'FAIL'
        Exit For Loop If  '${out[1]}'=='${expected_value}'
        Sleep  2
    END
    Run Keyword If  ${status}=='FAIL'  Capture Page Screenshot
    Should Be Equal As Strings  ${status}  'PASS'

Retry Double Keywords When Error
    [Arguments]  ${keyword1}  ${element1}  ${keyword2}  ${element2}  ${DoAssert}=${true}  ${times}=3
    FOR  ${n}  IN RANGE  1  ${times}
        Log To Console  Trying ${keyword1} and ${keyword2} ${n} times ...
        ${out1}  Run Keyword And Ignore Error  ${keyword1}  ${element1}
        Sleep  1
        ${out2}  Run Keyword And Ignore Error  ${keyword2}  ${element2}
        Log To Console  Return value is ${out1[0]} ${out2[0]}
        Exit For Loop If  '${out2[0]}'=='PASS'
        Sleep  1
    END
    Capture Page Screenshot
    Return From Keyword If  ${DoAssert} == ${false}  '${out2[0]}'
    Should Be Equal As Strings  '${out2[0]}'  'PASS'

Retry File Should Exist
    [Arguments]  ${path}
    Retry Keyword N Times When Error  4  OperatingSystem.File Should Exist  ${path}

Retry File Should Not Exist
    [Arguments]  ${path}
    Retry Keyword N Times When Error  4  OperatingSystem.File Should Not Exist  ${path}

Log All
    [Arguments]  ${text}
    Log To Console  ${text}
    Log  ${text}

New Tab
    Execute Javascript  window.open('')
    Switch Window  title=undefined

Click Link New Tab And Switch
    [Arguments]  ${element_xpath}
    Retry Link Click  ${element_xpath}
    ${handles}=  Get Window Handles
    Retry Action Keyword  Switch Window  ${handles}[-1]