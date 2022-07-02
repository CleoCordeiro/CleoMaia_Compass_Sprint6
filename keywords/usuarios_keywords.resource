#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo Que Contem As Keywords Do EndPoint Usuarios
Resource         ../support/base.resource

#Sessão para configuração de variáveis
*** Variables ***
${usuario_nao_cadastrado}    NaoExisto


#Sessão para criação de keywords
*** Keywords ***
Cadastrar Novo Usuario
    [Documentation]                                      Aceita como argumento um tipo de usuário e retorna um usuário do tipo desejado
    ...                                                  Se não for passado um tipo de usuário, loga como usuário Não Administrador
    ...                                                  Tipos de usuario Aceitos:
    ...                                                  - "Administrador"
    ...                                                  - "Nao Administrador"
    [Arguments]                                          ${tipo}= Nao Administrador
    Criar Dados Usuario Valido Do Tipo                   ${tipo}
    POST Endpoint "/usuarios" Com Body "${usuario}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Should Not Be Empty                                  ${response_body['_id']}
    Set To Dictionary                                    ${usuario}                                                                        _id=${response_body['_id']}
    Set Test Variable                                    ${usuario_valido}                                                                 ${usuario}

Alterar Nome Do Usuario
    ${novo_nome}         FakerLibrary.Name
    set to dictionary    ${usuario}           nome=${novo_nome}

Alterar Email Do Usuario
    ${novo_email}        FakerLibrary.Email
    set to dictionary    ${usuario}            email=${novo_email}

Alterar Senha Do Usuario
    ${novo_senha}        FakerLibrary.Password
    set to dictionary    ${usuario}               password=${novo_senha}

Alternar Tipo Do Usuario
    Run Keyword If    "${usuario['administrador']}" == """true"""     Set To Dictionary    ${usuario}    administrador=false
    Run Keyword If    "${usuario['administrador']}" == """false"""    Set To Dictionary    ${usuario}    administrador=true

Validar Usuario "${id_usuario_cadastrado}"
    Should Be Equal    ${response_body['_id']}    ${id_usuario_cadastrado}

Validar Se O Usuario Foi Removido "${usuario['_id']}"
    GET Endpoint "/usuarios/${usuario['_id']}"
    Should Be Equal                               ${response_body['message']}    Usuário não encontrado