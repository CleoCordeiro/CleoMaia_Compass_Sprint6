#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo base para requisições HTTP em APIs Rest


#Sessão para criação de keywords
*** Keywords ***
Importar JSON
    [Arguments]    ${arquivo}
    ${arquivo}     Get File      ${EXECDIR}/support/fixtures/static/${arquivo}
    ${payload}     Evaluate      json.loads('''${arquivo}''')                     json
    [return]       ${payload}

Pegar Key Do Json
       [Documentation]                           Necessita de 2 argumentos o primeiro é o json
...    e o segundo é a chave que deseja pegar
       [Arguments]                               ${arquivo}                                       ${key}
       ${json}                                   Importar JSON                                    ${arquivo}           
       Set Test Variable                         ${${key}}                                        ${json['${key}']}

Criar Sessao
    Custom Create Session    serverest    ${BASE_URI}    verify=True

GET Endpoint "${endpoint}"
    ${response}          GET On Session      serverest             ${endpoint}    expected_status=any
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}    ${response.json()}

POST Endpoint "${endpoint}" Com Body "${body}"
    Run keyword if       '_id' in ${body}    Remove From Dictionary    ${body}        _id
    ${response}          POST On Session     serverest                 ${endpoint}    json=${body}    expected_status=any
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}    ${response.json()}

POST Autenticado EndPoint "${endpoint}" Com Body "${body}" Headers "${headers}"
    Run keyword if       '_id' in ${body}    Remove From Dictionary    ${body}        _id
    ${response}          POST On Session     serverest                 ${endpoint}    json=${body}    expected_status=any    headers=${headers}
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}    ${response.json()}

POST EndPoint "${endpoint}" Com Body "${body}" Com Token Invalido
    Run keyword if       '_id' in ${body}     Remove From Dictionary          ${body}        _id
    &{header}=           Create Dictionary    Authorization=Token Invalido
    ${response}          POST On Session      serverest                       ${endpoint}    json=${body}    expected_status=any    headers=${header}
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}     ${response.json()}
PUT Endpoint "${endpoint}" Com Body "${body}"
    Run keyword if       '_id' in ${body}    Remove From Dictionary    ${body}        _id
    ${response}          PUT On Session      serverest                 ${endpoint}    json=${body}    expected_status=any    
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}    ${response.json()}

PUT Autenticado EndPoint "${endpoint}" Com Body "${body}" Headers "${headers}"
    Run keyword if       '_id' in ${body}    Remove From Dictionary    ${body}        _id
    ${response}          PUT On Session      serverest                 ${endpoint}    json=${body}    expected_status=any    headers=${headers}
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}    ${response.json()}

PUT EndPoint "${endpoint}" Com Body "${body}" Com Token Invalido
    Run keyword if       '_id' in ${body}     Remove From Dictionary          ${body}        _id
    &{header}=           Create Dictionary    Authorization=Token Invalido
    ${response}          PUT On Session       serverest                       ${endpoint}    json=${body}    expected_status=any    headers=${header}
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}     ${response.json()}

DELETE Endpoint "${endpoint}"
    ${response}          DELETE On Session    serverest             ${endpoint}    expected_status=any    
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}     ${response.json()}

DELETE Autenticado EndPoint "${endpoint}" Headers "${headers}"
    ${response}          DELETE On Session    serverest             ${endpoint}    expected_status=any    headers=${headers}
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}     ${response.json()}

DELETE EndPoint "${endpoint}" Com Token Invalido
    &{header}=           Create Dictionary    Authorization=Token Invalido
    ${response}          DELETE On Session    serverest                       ${endpoint}    expected_status=any    headers=${header}
    Set Test Variable    ${response}
    Set Test Variable    ${response_body}     ${response.json()}

Validar Status Code "${statuscode}"
    Should Be True    ${response.status_code} == ${statuscode}

Validar Mensagem "${mensagem}"
    Should Be Equal    ${response_body['message']}    ${mensagem}

Pegar Quantidade de "${item}"
    Custom On Session    GET              ${item}
    Set Test Variable    ${quantidade}    ${response_body['quantidade']}

Validar Se A Quantidade De ${item} E ${operador_logico} ${valor}
    Pegar Quantidade de "${item}"
    Should Be True                   ${quantidade} ${operador_logico} ${valor}

Validar "${key}" Com O Valor "${value}"
    Should Be Equal    ${response_body['${key}']}    ${value}

Validar Se A Key Nao Esta Vazia "${key}"
    Should Not Be Empty    ${response_body["${key}"]}

