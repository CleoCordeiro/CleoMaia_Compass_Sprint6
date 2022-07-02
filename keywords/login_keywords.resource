#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo Que Contem As Keywords Do EndPoint Login
Resource         ../support/base.resource

#Sessão para criação de keywords
*** Keywords ***
Pegar Dados Para Login "${usuario}"
    Remove From Dictionary    ${usuario}    nome    administrador    _id
Logar E Salvar Token Como
    [Documentation]                                   Aceita como argumento um tipo de usuário e retorna um usuário do tipo desejado
    ...                                               Se não for passado um tipo de usuário, loga como usuário Não Administrador
    ...                                               Tipos de usuario Aceitos:
    ...                                               - "Administrador"
    ...                                               - "Nao Administrador"
    [Arguments]                                       ${tipo}= Nao Administrador
    Cadastrar Novo Usuario                            ${tipo}
    Remove From Dictionary                            ${usuario}                                                                        nome                                               administrador    _id
    POST Endpoint "/login" Com Body "${usuario}"
    Validar Status Code "200"
    Validar Mensagem "Login realizado com sucesso"
    Validar Token
    &{headers}                                        Create Dictionary                                                                 Authorization=${response_body["authorization"]}
    Set Test Variable                                 ${headers}

Logar E Salvar Token Usando ID Do Usuario "${id}"
    ${usuario} =                                      GET Usuario Por ID "${id}"
    Remove From Dictionary                            ${usuario}                    nome                                               administrador    _id
    POST Endpoint "/login" Com Body "${usuario}"
    Validar Status Code "200"
    Validar Mensagem "Login realizado com sucesso"
    Validar Token
    &{headers}                                        Create Dictionary             Authorization=${response_body["authorization"]}
    Set Test Variable                                 ${headers}

Validar Token
    Should Not Be Empty    ${response_body["authorization"]}
