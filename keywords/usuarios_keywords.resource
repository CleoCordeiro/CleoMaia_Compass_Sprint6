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
    ${usuario} =                                         Criar Dados Usuario Valido Do Tipo                                                ${tipo}
    POST Endpoint "/usuarios" Com Body "${usuario}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Should Not Be Empty                                  ${response_body['_id']}
    Set To Dictionary                                    ${usuario}                                                                        _id=${response_body['_id']}
    [Return]                                             ${usuario}

Alterar "${key}" Do Usuario "${usuario}"
    ${novo_usuario} =    Criar Dados Usuario Valido Do Tipo    "Nao Administrador"
    set to dictionary    ${usuario}                            ${key}=${novo_usuario.${key}}
    [Return]             ${usuario}

Alterar Privilegio do Usuario "${usuario}"
    ${administrador}=     Convert To Title Case    ${usuario['administrador']}
    ${administrador} =    Evaluate                 ${administrador}== False
    ${administrador} =    Convert To String        ${administrador}
    ${administrador} =    Convert To Lower Case    ${administrador}
    set to dictionary     ${usuario}               administrador=${administrador}
    [Return]              ${usuario}

Validar Usuario "${id_usuario_cadastrado}"
    Should Be Equal    ${response_body['_id']}    ${id_usuario_cadastrado}

Validar Se O Usuario Foi Removido "${usuario['_id']}"
    GET Endpoint "/usuarios/${usuario['_id']}"
    Should Be Equal                               ${response_body['message']}    Usuário não encontrado