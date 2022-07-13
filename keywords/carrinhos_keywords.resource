#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo Que Contem As Keywords Do EndPoint Carrinhos
Resource         ../support/base.resource

#Sessão para criação de keywords
*** Keywords ***
Pegar Carrinho Cadastrado
    Custom On Session    GET            Carrinhos
    Set Test Variable    ${carrinho}    ${response_body['carrinhos'][-1]}
    [Return]             ${carrinho}

Cadastrar Novo Carrinho
    Criar Dados Carrinho Valido
    Logar E Salvar Token Como                            "Administrador"
    Custom On Session                                    POST               Carrinhos                      json=${carrinho}    headers=${headers}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"
    Set To Dictionary                                    ${carrinho}        _id=${response_body['_id']}

Cadastrar Carrinho Para O Usuario
    Criar Dados Carrinho Valido
    Custom On Session                                    POST    Carrinhos    json=${carrinho}    headers=${headers}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"

Criar Dados Carrinho Valido
    [Documentation]      Cria um Carrinho com uma lista de 1 ou mais produtos
    ${carrinho} =        Criar Dados Carrinho
    Set Test Variable    ${carrinho}

Criar Dados Lista De Carrinhos
    [Documentation]            Recebe a quantidade de carrinhos que serão criados e cria a variável lista_de_carrinhos
    ...                        Se não for passado nenhuma quantidade, cria a variável lista_de_carrinhos com quantidade de 1
    [Arguments]                ${quantidade}= 1
    ${lista_de_carrinhos} =    Criar Dados Carrinho                                                                             ${quantidade}
    Set Test Variable          ${lista_de_carrinhos}

Carrinho Com Produto Sem Quantidade Suficiente
    Custom On Session       GET                  Produtos
    ${produto} =            Create Dictionary    idProduto=${response_body['produtos'][-1]['_id']}    quantidade=99999
    @{lista_de_produtos}    Create List          ${produto}
    ${carrinho} =           Create Dictionary    produtos=${lista_de_produtos}
    Set Test Variable       ${carrinho}


