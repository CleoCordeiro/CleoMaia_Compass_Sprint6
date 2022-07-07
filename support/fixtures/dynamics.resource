#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Keywords para geração de dados dinamicos de Usuários, Produtos e Carrinhos.
Library          FakerLibrary


*** Keywords ***
Criar Dados Usuario Valido Do Tipo
    [Documentation]      Aceita como argumento um tipo de usuário e retorna um usuário do tipo desejado
    ...                  Se não for passado um tipo de usuário, retorna um usuario Não Administrador
    ...                  Tipos de usuario Aceitos:
    ...                  - "Administrador"
    ...                  - "Nao Administrador"
    [Arguments]          ${tipo}= Nao Administrador
    ${nome}              FakerLibrary.Name
    ${email}             FakerLibrary.Email
    ${word}              FakerLibrary.Word
    ${email}             Catenate                                                                          SEPARATOR=                    ${word}           ${email}             
    ${senha}             FakerLibrary.Password
    ${administrador}     Set Variable If                                                                   ${tipo} == "Administrador"    true              false
    &{usuario}           Create Dictionary                                                                 nome=${nome}                  email=${email}    password=${senha}    administrador=${administrador}
    Set Test Variable    ${usuario}

Criar Dados Usuario Nome Com Acentos
    [Documentation]                       Aceita como argumento um tipo de usuário e retorna um usuário do tipo desejado
    ...                                   Se não for passado um tipo de usuário, retorna um usuario Não Administrador
    ...                                   Tipos de usuario Aceitos:
    ...                                   - "Administrador"
    ...                                   - "Nao Administrador"
    [Arguments]                           ${tipo}= Nao Administrador
    Criar Dados Usuario Valido Do Tipo    ${tipo}
    Pegar Key Do Json                     acentos.json                                                                      acentos
    ${novo_nome_com_acentos}              Catenate                                                                          SEPARATOR=                       ${acentos}    ${usuario['nome']}
    Set To Dictionary                     ${usuario}                                                                        nome=${novo_nome_com_acentos}

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


Criar Dados Carrinho Valido
    [Documentation]                Gera um carrinho aleatório e retorna um dicionário com os dados do carrinho
    ${produtos} =                  Lista De Todos Produtos
    Set Test Variable              ${lista_de_produtos}                                                           ${produtos['produtos']}
    ${quantidade_de_produtos} =    Get length                                                                     ${lista_de_produtos}
    ${quantidade_aleatoria}        FakerLibrary.Random Int                                                        min=1                              max=10
    @{nova_lista_produtos}         Create List
    ${carrinho}=                   Create Dictionary
    FOR                            ${i}                                                                           IN RANGE                           ${quantidade_aleatoria}
    ${quantidade_de_produtos} =    Get length                                                                     ${lista_de_produtos}
    ${index_produto}               FakerLibrary.Random Int                                                        min=0                              max=${quantidade_de_produtos-1 }
    ${produto} =                   Remove From List                                                               ${lista_de_produtos}               ${index_produto}
    IF                             ${produto['quantidade']} < 3                                                   CONTINUE
    ${quantidade}                  FakerLibrary.Random Int                                                        min=1                              max=3
    &{novo_produto}                Create Dictionary                                                              idProduto=${produto['_id']}        quantidade=${quantidade}
    Append To List                 ${nova_lista_produtos}                                                         ${novo_produto}
    END
    ${carrinho} =                  Create Dictionary                                                              produtos=${nova_lista_produtos}
    Set Test Variable              ${carrinho}
