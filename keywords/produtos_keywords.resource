*** Settings ***
Documentation    Arquivo Que Contem As Keywords Do EndPoint Produtos
Resource         ../support/base.resource

#Sessão para criação de keywords
*** Keywords ***
Cadastrar Novo Produto
    Criar Dados Produto Valido
    Logar E Salvar Token Como                            "Administrador"
    Custom On Session                                    POST               Produtos                       json=${produto}    headers=${headers}
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Status Code "201"
    Validar Se A Key Nao Esta Vazia "_id"
    Set to Dictionary                                    ${produto}         _id=${response_body['_id']}
    Set Test Variable                                    ${produto}


Pegar Produto Cadastrado
    Custom On Session    GET           Produtos
    Set Test Variable    ${produto}    ${response_body['produtos'][-1]}
    [Return]             ${produto}

Pegar Produto Do JSON Sem O Campo "${parametro}"
    ${produto} =              Pegar Produto Cadastrado
    Remove From Dictionary    ${produto}                  ${parametro}
    [Return]                  ${produto}

Pegar Produto Do JSON Com o Campo "${key}" Invalido
    ${produto} =         Pegar Produto Cadastrado
    set to dictionary    ${produto}                  ${key}=1.5
    [Return]             ${produto}

Validar Nome Do Produto "${id_produto_cadastrado}" "${nome_de_cadastro}"
    Custom On Session    GET                         Produtos/${id_produto_cadastrado}
    Should Be Equal      ${response_body['nome']}    ${nome_de_cadastro}

Alterar "${tipo}" Campo "${key}" Do Produto
    ${produto} =         Pegar Produto Cadastrado
    IF                   "${tipo}" == "String"
    ${novo_valor}        FakerLibrary.Word
    ELSE IF              "${tipo}" == "Integer"
    ${novo_valor}        FakerLibrary.Random Int     min=1
    END
    set to dictionary    ${produto}                  ${key}=${novo_valor}
    [Return]             ${produto}

Criar Dados Produto Valido
    ${produto} =         Criar Dados Produto
    Set Test Variable    ${produto}

Criar Dados Lista De Produto
    [Documentation]           Recebe a quantidade de produtos que serão criados e cria a variável lista_de_produtos
    ...                       Se não for passado nenhuma quantidade, cria a variável lista_de_produtos com quantidade de 1
    [Arguments]               ${quantidade}= 1
    ${lista_de_produtos} =    Criar Dados Produto                                                                             ${quantidade}
    Set Test Variable         ${lista_de_produtos}

Criar Dados Produto Nome Com Acentos
    Criar Dados Produto Valido
    Pegar Key Do Json             acentos.json    acentos
    ${novo_nome_com_acentos}      Catenate        SEPARATOR=                       ${acentos}    ${produto['nome']}
    Set To Dictionary             ${produto}      nome=${novo_nome_com_acentos}

