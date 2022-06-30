#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Keywords para geração de dados dinamicos de Usuários, Produtos e Carrinhos.
Library          FakerLibrary


*** Keywords ***
Criar Dados Usuario Valido Do Tipo
    [Documentation]     Aceita como argumento um tipo de usuário e retorna um usuário do tipo desejado
    ...                 Se não for passado um tipo de usuário, retorna um usuario Não Administrador
    ...                 Tipos de usuario Aceitos:
    ...                 - "Administrador"
    ...                 - "Nao Administrador"
    [Arguments]         ${tipo}= Nao Administrador
    ${nome}             FakerLibrary.Name
    ${email}            FakerLibrary.Email
    ${word}             FakerLibrary.Word
    ${email}            Catenate                                                                          SEPARATOR=                    ${word}           ${email}             
    ${senha}            FakerLibrary.Password
    ${administrador}    Set Variable If                                                                   ${tipo} == "Administrador"    true              false
    &{usuario}          Create Dictionary                                                                 nome=${nome}                  email=${email}    password=${senha}    administrador=${administrador}
    [Return]            ${usuario}


Criar Dados Produto Valido
    [Documentation]    Gera um produto aleatório e retorna um dicionário com os dados do produto
    ${nome} =          FakerLibrary.Text                                                            max_nb_chars=30
    ${descricao} =     FakerLibrary.Text                                                            max_nb_chars=100
    ${preco} =         FakerLibrary.Random Int                                                      min=100             max=4000
    ${quantidade} =    FakerLibrary.Random Int                                                      min=300             max=1000
    &{produto} =       Create Dictionary                                                            nome=${nome}        descricao=${descricao}    preco=${preco}    quantidade=${quantidade}
    [Return]           ${produto}


Criar Dados Carrinho Valido
    [Documentation]                Gera um carrinho aleatório e retorna um dicionário com os dados do carrinho
    ${produtos} =                  Lista De Todos Produtos
    Set Test Variable              ${lista_de_produtos}                                                           ${produtos['produtos']}
    ${quantidade_de_produtos} =    Get length                                                                     ${lista_de_produtos}
    ${quantidade_aleatoria}        FakerLibrary.Random Int                                                        min=1                          max=10
    @{nova_lista_produtos}         Create List
    ${carrinho}=                   Create Dictionary
    FOR                            ${i}                                                                           IN RANGE                       ${quantidade_aleatoria}
    ${quantidade_de_produtos} =    Get length                                                                     ${lista_de_produtos}
    ${index_produto}               FakerLibrary.Random Int                                                        min=0                          max=${quantidade_de_produtos-1 }
    ${produto} =                   Remove From List                                                               ${lista_de_produtos}           ${index_produto}
    IF                             ${produto['quantidade']} <= 0                                                  CONTINUE
    ${quantidade}                  FakerLibrary.Random Int                                                        min=1                          max=3
    &{novo_produto}                Create Dictionary                                                              idProduto=${produto['_id']}    quantidade=${quantidade}
    Append To List                 ${nova_lista_produtos}                                                         ${novo_produto}
    END
    ${carrinho}=                   Add Object To Json                                                             ${carrinho}                    $.produtos                          ${nova_lista_produtos}
    [Return]                       ${carrinho}
