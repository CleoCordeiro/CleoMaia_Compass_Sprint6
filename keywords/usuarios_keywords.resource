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
    [Arguments]                                          ${tipo}= "Nao Administrador"
    Criar Dados Usuario Valido Do Tipo                   ${tipo}
    Custom On Session                                    POST                                                                              Usuarios                       json=${usuario}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Should Not Be Empty                                  ${response_body['_id']}
    Set To Dictionary                                    ${usuario}                                                                        _id=${response_body['_id']}
    Set Test Variable                                    ${usuario}                                                                        ${usuario}

Alterar Nome Do Usuario
    ${novo_nome}         Gerar Dado Randomico    name
    set to dictionary    ${usuario}              nome=${novo_nome}

Alterar Email Do Usuario
    ${novo_email}        Gerar Dado Randomico    email
    ${novo_email}        Catenate                SEPARATOR=             ${usuario['nome']}    ${novo_email}
    set to dictionary    ${usuario}              email=${novo_email}

Alterar Senha Do Usuario
    ${novo_senha}        Gerar Dado Randomico    password                  length=15
    set to dictionary    ${usuario}              password=${novo_senha}

Alternar Tipo Do Usuario
    IF                   "${usuario['administrador']}" == """true""" 
    Set To Dictionary    ${usuario}                                      administrador=false
    ELSE IF              "${usuario['administrador']}" == """false"""
    Set To Dictionary    ${usuario}                                      administrador=true
    END

Validar Usuario "${id_usuario_cadastrado}"
    Should Be Equal    ${response_body['_id']}    ${id_usuario_cadastrado}

Validar Nome do Usuario "${id_usuario_cadastrado}" "${nome_de_cadastro}"
    Custom On Session    GET                         Usuarios/${id_usuario_cadastrado}
    Should Be Equal      ${response_body['nome']}    ${nome_de_cadastro}

Validar Se O Usuario Foi Removido "${usuario['_id']}"
    Custom On Session    GET                            Usuarios/${usuario['_id']}
    Should Be Equal      ${response_body['message']}    Usuário não encontrado

Criar Dados Usuario Valido Do Tipo
    [Documentation]      Recebe dois parâmetros:
    ...                  O primeiro é o tipo de usuário:
    ...                  - "Administrador"
    ...                  - "Nao Administrador" (Default)
    ...                  O Segundo é número de usuários que serão criados
    ...                  - 1 (Default)
    [Arguments]          ${tipo}="Nao Administrador"                         ${quantidade}= 1
    ${usuario} =         Criar Dados Usuario Do Tipo                         ${tipo}             ${quantidade}
    Set Test Variable    ${usuario}


Criar Lista de Usuarios
    [Documentation]                       Cria uma lista de usuários do tipo desejado
    ...                                   Recebe dois parâmetros:
    ...                                   O primeiro é o tipo de usuário:
    ...                                   - "Administrador"
    ...                                   - "Nao Administrador" (Default)
    ...                                   O Segundo é número de usuários que serão criados
    ...                                   - 1 (Default)
    ...                                   Seta a variável de teste ${lista_de_usuarios}
    [Arguments]                           ${tipo}="Nao Administrador"                         ${quantidade}= 1
    Criar Dados Usuario Valido Do Tipo    ${tipo}                                             ${quantidade}
    Set Test Variable                     ${lista_de_usuarios}                                ${usuario}

Criar Dados Usuario Nome Com Acentos
    [Documentation]                       Aceita como argumento um tipo de usuário e retorna um usuário do tipo desejado
    ...                                   Se não for passado um tipo de usuário, retorna um usuario Não Administrador
    ...                                   Tipos de usuario Aceitos:
    ...                                   - Administrador
    ...                                   - Nao Administrador
    [Arguments]                           ${tipo}= Nao Administrador
    Criar Dados Usuario Valido Do Tipo    ${tipo}
    Pegar Key Do Json                     acentos.json                                                                      acentos
    ${novo_nome_com_acentos}              Catenate                                                                          SEPARATOR=                       ${acentos}    ${usuario['nome']}
    Set To Dictionary                     ${usuario}                                                                        nome=${novo_nome_com_acentos}