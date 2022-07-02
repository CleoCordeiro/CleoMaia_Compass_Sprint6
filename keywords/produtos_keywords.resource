*** Settings ***
Documentation    Arquivo Que Contem As Keywords Do EndPoint Produtos
Resource         ../support/base.resource

#Sessão para criação de keywords
*** Keywords ***
Cadastar Novo Produto
    ${produto} =                                                                        Gerar Novo Produto
    Logar E Salvar Token Como                                                           "Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Status Code "201"
    Validar Se A Key Nao Esta Vazia "_id"
    Set to Dictionary                                                                   ${produto}            _id=${response_body['_id']}
    Set Test Variable                                                                   ${produto}

Lista De Todos Produtos
    GET Endpoint "/produtos"
    [Return]                    ${response_body}

Quantidade De Produtos
    GET Endpoint "/produtos"
    [Return]                    ${response_body['quantidade']}

Pegar Produto Cadastrado
    GET Endpoint "/produtos"
    Set Test Variable           ${produto}    ${response_body['produtos'][-1]}
    [Return]                    ${produto}

Gerar Novo Produto
    ${nome} =          FakerLibrary.Text          max_nb_chars=30
    ${descricao} =     FakerLibrary.Text          max_nb_chars=100
    ${preco} =         FakerLibrary.Random Int    min=100             max=4000
    ${quantidade} =    FakerLibrary.Random Int    min=300             max=1000
    &{produto} =       Create Dictionary          nome=${nome}        descricao=${descricao}    preco=${preco}    quantidade=${quantidade}
    [Return]           ${produto}


Pegar Produto Do JSON Sem O Campo "${parametro}"
    ${produto} =              Pegar Produto Cadastrado
    Remove From Dictionary    ${produto}                  ${parametro}
    [Return]                  ${produto}

Pegar Produto Do JSON Com o Campo "${key}" Invalido
    ${produto} =         Pegar Produto Cadastrado
    set to dictionary    ${produto}                  ${key}=1.5
    [Return]             ${produto}

Alterar "${tipo}" Campo "${key}" Do Produto
    ${produto} =         Pegar Produto Cadastrado
    IF                   "${tipo}" == "String"
    ${novo_valor}        FakerLibrary.Word
    ELSE IF              "${tipo}" == "Integer"
    ${novo_valor}        FakerLibrary.Random Int     min=1
    END
    set to dictionary    ${produto}                  ${key}=${novo_valor}
    [Return]             ${produto}
