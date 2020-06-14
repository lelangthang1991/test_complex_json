*** Settings ***
Documentation    Suite description
Library    OperatingSystem
Library    ExcelLibrary
Library    String
Library    JSONLibrary
Library    Collections
Library    ./libs.py

*** Variables ***
${dataTest}    ./testData.xlsx

*** Test Cases ***
Unitest001
    [Tags]    DEBUG
    Provided precondition
    When Load Data From Excel File
    Then Check Result
    And Dump Result To File

*** Keywords ***
Provided precondition
    ${json}    Set variable    ./complexJSON.json
    ${json}    join path    ${CURDIR}    ${json}
    ${res}    Get File    ${json}
    ${res}    evaluate  json.loads('''${res}''')    json
    Set Test Variable    ${res}    ${res}

Load Data From Excel File
    ${dataTest}    Join Path   ${CURDIR}    ${dataTest}
    Set Test Variable    ${dataTest}    ${dataTest}
    # Get initial data
    ${dict}    Get Data From Excel    DATA    1
    ${initDict}=    Set Variable    ${dict}
    # User should get request and response separately
    Check Dict Value    ${dict}
    log    ${dict}
    Set Test Variable    ${expected}    ${dict}

Check Result
    FOR    ${elm}    IN     @{expected.keys()}
        Log    ${res["${elm}"]}
        Log    ${expected["${elm}"]}
        Run Keyword And Continue On Failure    Should Be Equal    ${res["${elm}"]}    ${expected["${elm}"]}    \n${elm}    values=True
    END
    Log    ${res}
    Log    ${expected}
    Run Keyword And Continue On Failure    Dictionaries Should Be Equal    ${res}    ${expected}    ${dataTest}    values=True

Dump Result To File
    ${output}    catenate    ./outputdata.json
    ${output}    Join Path    ${CURDIR}    ${output}
    ${json}    convert to String    ${expected}
    ${json}    Replace String   ${json}    '    "
    Create File    ${output}    ${json}

Check Dict Value
    [Arguments]      ${dict}
    FOR    ${elm}    IN    @{dict.keys()}
        ${isRefValue}    Evaluate    "[ref]" in "${dict["${elm}"]}"
        Continue For Loop If    ${isRefValue} == ${False}
        ${value}    Get ref value    ${dict["${elm}"]}

        Set To Dictionary    ${dict}    ${elm}    ${value}
    END


Get ref value
    [Arguments]    ${strValue}
    ${str}    Get substring    ${strValue}    5
    ${str}    Remove String   ${str}   [
    ${str}    Remove String   ${str}   ]
    ${str}    split String    ${str}    separator=:
    ${sheetName}    Set Variable    ${str}[0]
    ${rowlist}    Set Variable    ${str}[1]
    ${rowlist}    Split String    ${rowlist}    separator=,
    ${rowlength}    Get Length    ${rowlist}
    ${dict}    Run Keyword If    ${rowlength} < ${2}
    ...            Get Data From Excel    ${sheetName}    ${rowList}[0]
    ...    ELSE    Create list
    FOR    ${row}    IN    @{rowlist}
        Exit For Loop if    ${rowlength} < ${2}
        ${dict_elm}    Get Data From Excel    ${sheetName}    ${row}
        Append To List    ${dict}    ${dict_elm}
    END
    Log    ${dict}
    ${dict_status}    Run Keyword And Return Status    Get Length    ${dict.keys()}
    Run Keyword If    ${dict_status}    Check Dict Value    ${dict}
    ...    ELSE    Check List Dict    ${dict}
    [Return]    ${dict}

Check List Dict
    [Arguments]    ${list}
    FOR    ${item}    IN    @{list}
        Check Dict Value    ${item}
    END

Get Data From Excel
    [Arguments]    ${sheet}    ${row}
    Close All Excel Documents
    ${row}    evaluate    ${row}+${1}
    ${key}    Create list
    ${value}    Create list
    Open Excel Document    ${dataTest}    ExcelData
    ${key}    Read Excel Row    0    0    0    ${sheet}
    Remove From List    ${key}    0
    ${value}    Read Excel Row    ${row}    0    0    ${sheet}
    Remove From List    ${value}    0
    ${dataDict}    Convert To Dict    ${key}    ${value}
    Close Current excel document
    [Return]    ${dataDict}

