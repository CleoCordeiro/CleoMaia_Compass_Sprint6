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

Lista De Todos ${item}
    Custom On Session    GET                 ${item}
    [Return]             ${response_body}

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

Validar Estrutura Da Resposta "${key}"
    Pegar Key Do Json    schema.json                  ${key}
    validate             instance=${response_body}    schema=${${key}}

Validar Tempo De Resposta ${quantidade_de_teste}
    ${tempo_maximo_de_resposta}=    Evaluate                                                             ${tempo_maximo_por_requisição} * ${quantidade}
    Should Be True                  ${response.elapsed.total_seconds()} < ${tempo_maximo_de_resposta}
