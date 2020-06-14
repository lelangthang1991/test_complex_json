*** Settings ***
Documentation    Suite description
Library    ./libs.py
Library    String

*** Variables ***

*** Test Cases ***
Unitest 1
    [Tags]    DEBUG
    Provided precondition
#    When action
#    Then check expectations

*** Keywords ***
Provided precondition
    ${str}    Catenate    The number is 564556 and 4233. \nInclude
    ${digit}    Get Digit Number In String    ${str}
    Log To Console    ${digit}