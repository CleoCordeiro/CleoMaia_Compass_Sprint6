#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo De Testes Relacionandos Ao EndPoint Produtos
Resource         ../keywords/produtos_keywords.resource
Suite Setup      Criar Sessao


#Sessão para criação de cenários de teste
*** Test Cases ***
######################
#    GET PRODUTOS    #
######################
Cenario: Listar Todos Os Produtos Cadastrados
    [Tags]               GET    Produtos    GET_Produtos    Buscar_Todos_Produtos
    #Cadastar Novo Produto
    Custom On Session    GET    Produtos
    # Validar Status Code "200"
    # Validar Se A Quantidade De Produtos E > 0

Cenario: Buscar Produto Cadastrado
    [Tags]                                       GET                 Produtos                      GET_Produtos    Buscar_Produto_Cadastrado
    Cadastar Novo Produto
    Pegar Produto Cadastrado
    Custom On Session                            GET                 Produtos/${produto['_id']}
    Validar Status Code "200"
    Validar Se A Quantidade De Produtos E > 0
    Log to Console                               ${response_time}

Cenario: Tentar Buscar Produto Nao Cadastrado
    [Tags]                                       GET    Produtos                  GET_Produtos    Buscar_Produto_Nao_Cadastrado
    Custom On Session                            GET    Produtos/NaoCadastrado
    Validar Status Code "400"
    Validar Mensagem "Produto não encontrado"

#######################
#    POST PRODUTOS    #
#######################
Cenario: Cadastrar Produto Valido
    [Tags]                                                      POST               Cadastrar_Produto    Cadastar_Produto_Valido
    Criar Dados Produto Valido
    Logar E Salvar Token Como                                   "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                           POST               Produtos             json=${produto}            headers=${headers}
    #Custom Theard Request                                POST               Produtos             headers=${headers}
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Status Code "201"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Se A Quantidade De Produtos E == ${quantidade+1}

Cenario: Cadastrar ${teste_de_carga_produto} Produtos
    [Tags]                            POST                         Cadastrar_Produto    Teste_De_Carga_Produto
    Criar Dados Lista De Produto      ${teste_de_carga_produto}
    Logar E Salvar Token Como         "Administrador"
    Pegar Quantidade de "Produtos"
    #Criar Dados Produto Valido
    Custom Theard Request             POST                         Produtos             data=${lista_de_produtos}    headers=${headers}
    #Validar Mensagem "Cadastro realizado com sucesso"
    #Validar Status Code "201"
    #Validar Se A Key Nao Esta Vazia "_id"
    #Validar Se A Quantidade De Produtos E == ${quantidade+${teste_de_carga_produto}}

Cenario: Cadastrar Produto Nome Com Acentos
    [Tags]                                                                              POST               Cadastrar_Produto    Cadastar_Produto_Nome_Com_Acentos
    Criar Dados Produto Nome Com Acentos
    Logar E Salvar Token Como                                                           "Administrador"
    Pegar Quantidade de "Produtos"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Status Code "201"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Nome Do Produto "${response_body['_id']}" "${produto['nome']}"


Cenario: Tentar Cadastrar Produto Valido Nao Administrador
    [Tags]                                                                              POST                   Cadastrar_Produto    Cadastar_Produto_Valido_Nao Administrador
    Criar Dados Produto Valido
    Logar E Salvar Token Como                                                           "Nao Administrador"
    Pegar Quantidade de "Produtos"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Mensagem "Rota exclusiva para administradores"
    Validar Status Code "403"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Cadastar Produto Nao Autenticado
    [Tags]                                                                                                POST    Cadastrar_Produto    Cadastar_Produto_Nao_Autenticado
    Criar Dados Produto Valido
    Pegar Quantidade de "Produtos"
    POST EndPoint "/produtos" Com Body "${produto}"
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Cadastrar Produto Com Token Invalido
    [Tags]                                                                                                POST    Cadastrar_Produto    Cadastar_Produto_Com_Token_Invalido
    Criar Dados Produto Valido
    Pegar Quantidade de "Produtos"
    POST EndPoint "/produtos" Com Body "${produto}" Com Token Invalido
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Cadastrar Produto Ja Cadastrado
    [Tags]                                                                              POST               Cadastrar_Produto    Cadastar_Produto_Ja_Cadastrado
    Pegar Produto Cadastrado
    Logar E Salvar Token Como                                                           "Administrador"
    Pegar Quantidade de "Produtos"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Mensagem "Já existe produto com esse nome"
    Validar Status Code "400"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Cadastar Produto Com Nome Vazio
    [Tags]                                                                              POST               Cadastrar_Produto    Cadastar_Produto_Com_Nome_Vazio
    Pegar Produto Do JSON Sem O Campo "nome"
    Logar E Salvar Token Como                                                           "Administrador"
    Pegar Quantidade de "Produtos"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "nome" Com O Valor "nome é obrigatório"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Cadastar Produto Com Preco Vazio
    [Tags]                                                                              POST               Cadastrar_Produto    Cadastar_Produto_Com_Preco_Vazio
    Pegar Produto Do JSON Sem O Campo "preco"
    Logar E Salvar Token Como                                                           "Administrador"
    Pegar Quantidade de "Produtos"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "preco" Com O Valor "preco é obrigatório"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Cadastar Produto Com Preco Invalido
    [Tags]                                                                              POST               Cadastrar_Produto    Cadastar_Produto_Preco_Invalido
    Pegar Produto Do JSON Com o Campo "preco" Invalido
    Logar E Salvar Token Como                                                           "Administrador"
    Pegar Quantidade de "Produtos"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "preco" Com O Valor "preco deve ser um inteiro"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Cadastar Produto Com Descricao Vazia
    [Tags]                                                                              POST               Cadastrar_Produto    Cadastar_Produto_Com_Descricao_Vazia
    Pegar Produto Do JSON Sem O Campo "descricao"
    Logar E Salvar Token Como                                                           "Administrador"
    Pegar Quantidade de "Produtos"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "descricao" Com O Valor "descricao é obrigatório"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Cadastar Produto Com Quantidade Vazia
    [Tags]                                                                              POST               Cadastrar_Produto    Cadastar_Produto_Com_Quantidade_Vazia
    Pegar Produto Do JSON Sem O Campo "quantidade"
    Logar E Salvar Token Como                                                           "Administrador"
    Pegar Quantidade de "Produtos"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "quantidade" Com O Valor "quantidade é obrigatório"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Cadastrar Produto Com A Quantidade Invalida
    [Tags]                                                                              POST               Cadastrar_Produto    Cadastar_Produto_Quantidade_Invalida
    Pegar Produto Do JSON Com o Campo "quantidade" Invalido
    Logar E Salvar Token Como                                                           "Administrador"
    Pegar Quantidade de "Produtos"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "quantidade" Com O Valor "quantidade deve ser um inteiro"
    Validar Se A Quantidade De Produtos E == ${quantidade}

######################
#    PUT PRODUTOS    #
######################
Cenario: Atualizar Nome do Produto
    [Tags]                                                                                               PUT                Produtos    PUT_Produtos    Atualizar_Produto_Nome 
    Alterar "String" Campo "nome" Do Produto
    Logar E Salvar Token Como                                                                            "Administrador"
    Pegar Quantidade de "Produtos"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Atualizar Descrição do Produto
    [Tags]                                                                                               PUT                Produtos    PUT_Produtos    Atualizar_Produto_Descricao 
    Alterar "String" Campo "descricao" Do Produto
    Logar E Salvar Token Como                                                                            "Administrador"
    Pegar Quantidade de "Produtos"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Atualizar Preço do Produto
    [Tags]                                                                                               PUT                Produtos    PUT_Produtos    Atualizar_Produto_Preco 
    Alterar "Integer" Campo "preco" Do Produto
    Logar E Salvar Token Como                                                                            "Administrador"
    Pegar Quantidade de "Produtos"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Atualizar Quantidade do Produto
    [Tags]                                                                                               PUT                Produtos    PUT_Produtos    Atualizar_Produto_Quantidade 
    Alterar "Integer" Campo "quantidade" Do Produto
    Logar E Salvar Token Como                                                                            "Administrador"    
    Pegar Quantidade de "Produtos"                                                                       
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Atualizar Produto Sem Alteracao
    [Tags]                                                                                               PUT                Produtos    PUT_Produtos    Atualizar_Produto_Sem_Alteracao
    Pegar Produto Cadastrado
    Logar E Salvar Token Como                                                                            "Administrador"
    Pegar Quantidade de "Produtos"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Atualizar Produto Não Cadastrado
    [Tags]                                                                                       PUT                Produtos    PUT_Produtos    Atualizar_Produto_NAO_CADASTRADO
    Criar Dados Produto Valido
    Logar E Salvar Token Como                                                                    "Administrador"
    Pegar Quantidade de "Produtos"
    PUT Autenticado EndPoint "/produtos/NaoExisto" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Se A Quantidade De Produtos E == ${quantidade+1}

Cenario: Tentar Atualizar Produto Cadastrado Sem Autenticacao
    [Tags]                                                                                                PUT    Produtos    PUT_Produtos    Atualizar_Produto_Sem_Autenticacao
    Pegar Produto Cadastrado
    Pegar Quantidade de "Produtos"
    PUT Endpoint "/produtos/${produto['_id']}" Com Body "${produto}"
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Atualizar Produto Cadastrar Sem Informar O ID
    [Tags]                                                                                       PUT                Produtos    PUT_Produtos    Atualizar_Produto_Sem_ID
    Pegar Produto Cadastrado
    Logar E Salvar Token Como                                                                    "Administrador"
    Pegar Quantidade de "Produtos"
    PUT Autenticado EndPoint "/produtos/NaoExisto" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Atualizar Produto Autenticado Como Nao Administrador
    [Tags]                                                                                               PUT                    Produtos    PUT_Produtos    Atualizar_Produto_Nao Administrador
    Pegar Produto Cadastrado
    Logar E Salvar Token Como                                                                            "Nao Administrador"
    Pegar Quantidade de "Produtos"                                                                       
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "403"
    Validar Mensagem "Rota exclusiva para administradores"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Atualizar Produto Cadastrado Com Token Invalido
    [Tags]                                                                                                PUT    Produtos    PUT_Produtos    Atualizar_Produto_Token_Invalido
    Pegar Produto Cadastrado
    Pegar Quantidade de "Produtos"
    PUT EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Com Token Invalido
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Se A Quantidade De Produtos E == ${quantidade}



Cenario: Tentar Atualizar Produto Com Preco Invalido
    [Tags]                                                                                               PUT                Produtos    PUT_Produtos    Atualizar_Produto_Preco_Invalido
    Pegar Produto Do JSON Com o Campo "preco" Invalido
    Logar E Salvar Token Como                                                                            "Administrador"
    Pegar Quantidade de "Produtos"                                                                       
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "preco" Com O Valor "preco deve ser um inteiro"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Atualizar Produto Com Quantidade Invalida
    [Tags]                                                                                               PUT                Produtos    PUT_Produtos    Atualizar_Produto_Quantidade_Invalida
    Pegar Produto Do JSON Com o Campo "quantidade" Invalido
    Logar E Salvar Token Como                                                                            "Administrador"
    Pegar Quantidade de "Produtos"                                                                       
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "quantidade" Com O Valor "quantidade deve ser um inteiro"
    Validar Se A Quantidade De Produtos E == ${quantidade}

#########################
#    DELETE PRODUTOS    #
#########################
Cenario: Deletar Produto Cadastrado
    [Tags]                                                                            DELETE             Produtos    DELETE_Produtos    Deletar_Produto_Cadastrado
    Cadastar Novo Produto
    Logar E Salvar Token Como                                                         "Administrador"
    Pegar Quantidade de "Produtos"
    DELETE Autenticado EndPoint "/produtos/${produto['_id']}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"
    Validar Se A Quantidade De Produtos E == ${quantidade-1}

Cenario: Tentar Deletar Produto Não Cadastrado
    [Tags]                                                                    DELETE             Produtos    DELETE_Produtos    Deletar_Produto_Nao_Cadastrado
    Logar E Salvar Token Como                                                 "Administrador"
    Pegar Quantidade de "Produtos"
    DELETE Autenticado EndPoint "/produtos/NaoExisto" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Nenhum registro excluído"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Deletar Produto Cadastrado Sem Autenticacao
    [Tags]                                                                                                DELETE    Produtos    DELETE_Produtos    Deletar_Produto_Sem_Autenticacao
    Cadastar Novo Produto
    Pegar Quantidade de "Produtos"
    DELETE Endpoint "/produtos/${produto['_id']}"
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Se A Quantidade De Produtos E == ${quantidade}

Cenario: Tentar Deletar Produto Cadastrado Com Autenticacao De Nao Administrador
    [Tags]                                                                            DELETE                 Produtos    DELETE_Produtos    Deletar_Produto_Nao Administrador
    Cadastar Novo Produto
    Logar E Salvar Token Como                                                         "Nao Administrador"    
    Pegar Quantidade de "Produtos"
    DELETE Autenticado EndPoint "/produtos/${produto['_id']}" Headers "${headers}"
    Validar Status Code "403"
    Validar Se A Quantidade De Produtos E == ${quantidade}