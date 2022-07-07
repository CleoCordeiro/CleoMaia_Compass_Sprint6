#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo Que Contem As Keywords Do EndPoint Carrinhos
Resource         ../support/base.resource

#Sessão para criação de keywords
*** Keywords ***
Pegar Carrinho Cadastrado
    Custom On Session           GET            Carrinhos
    Set Test Variable           ${carrinho}    ${response_body['carrinhos'][-1]}
    [Return]                    ${carrinho}

Cadastrar Novo Carrinho
    Criar Dados Carrinho Valido
    Logar E Salvar Token Como                                                             "Administrador"
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"

Carrinho Com Produto Sem Quantidade Suficiente
    Custom On Session       GET                  Produtos
    ${produto} =            Create Dictionary    idProduto=${response_body['produtos'][-1]['_id']}    quantidade=99999
    @{lista_de_produtos}    Create List          ${produto}
    ${carrinho} =           Create Dictionary    produtos=${lista_de_produtos}
    Set Test Variable       ${carrinho}
