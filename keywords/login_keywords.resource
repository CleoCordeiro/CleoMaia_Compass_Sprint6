#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo Que Contem As Keywords Do EndPoint Login
Resource         ../support/base.resource

#Sessão para criação de keywords
*** Keywords ***
Pegar Dados Para Login "${usuario}"

    &{dados_login}            Copy Dictionary    ${usuario}
    Remove From Dictionary    ${dados_login}     _id           nome    administrador    
    Set Test Variable         ${dados_login}

Logar E Salvar Token Como
    [Documentation]                                    Aceita como argumento um tipo de usuário e retorna um usuário do tipo desejado
    ...                                                Se não for passado um tipo de usuário, loga como usuário Não Administrador
    ...                                                Tipos de usuario Aceitos:
    ...                                                - "Administrador"
    ...                                                - "Nao Administrador"
    [Arguments]                                        ${tipo}= "Nao Administrador"
    Cadastrar Novo Usuario                             ${tipo}
    Pegar Dados Para Login "${usuario}"
    Custom On Session                                  POST                                                                              Login                                              json=${dados_login}
    Validar Status Code "200"
    Validar Mensagem "Login realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "authorization"
    &{headers}                                         Create Dictionary                                                                 Authorization=${response_body["authorization"]}
    Set Test Variable                                  ${headers}

Gerar Token Invalido
    &{headers}           Create Dictionary    Authorization="Bearer token invalido"
    Set Test Variable    ${headers}


