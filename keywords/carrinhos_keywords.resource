#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo Que Contem As Keywords Do EndPoint Carrinhos
Resource         ../support/base.resource

#Sessão para criação de keywords
*** Keywords ***
Pegar Carrinho Cadastrado
    GET Endpoint "carrinhos"
    Set Test Variable           ${carrinho}    ${response_body['carrinhos'][-1]}
    [Return]                    ${carrinho}

Cadastrar Novo Carrinho
    ${carrinho} =                                                                         Criar Dados Carrinho Valido
    Logar E Salvar Token Como                                                             "Administrador"
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"
    [Return]                                                                              ${response_body}

Pegar Json Carrinho Com a Key "${key}"
    ${carrinho}    Importar JSON            carrinho.json
    [Return]       ${carrinho['${key}']}
