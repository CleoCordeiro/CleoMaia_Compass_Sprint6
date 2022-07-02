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
    [Tags]                                GET    Produtos    GET_Produtos    Buscar_Todos_Produtos
    Cadastar Novo Produto
    Get Endpoint "/produtos"
    Validar Status Code "200"
    Validar Quantidade De Produtos > 0

Cenario: Buscar Produto Cadastrado
    [Tags]                                        GET                         Produtos    GET_Produtos    Buscar_Produto_Cadastrado
    Cadastar Novo Produto
    ${produto} =                                  Pegar Produto Cadastrado
    Get Endpoint "/produtos/${produto['_id']}"
    Validar Status Code "200"
    Validar Quantidade De Produtos > 0

Cenario: Tentar Buscar Produto Nao Cadastrado
    [Tags]                                       GET    Produtos    GET_Produtos    Buscar_Produto_Nao_Cadastrado
    Get Endpoint "/produtos/NaoCadastrado"
    Validar Status Code "400"
    Validar Mensagem "Produto não encontrado"

#######################
#    POST PRODUTOS    #
#######################
Cenario: Cadastrar Produto Valido
    [Tags]                                                                              POST                  Cadastrar_Produto    Cadastar_Produto_Valido
    ${produto} =                                                                        Gerar Novo Produto
    Logar E Salvar Token Como                                                           "Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Status Code "201"
    Validar Se A Key Nao Esta Vazia "_id"

Cenario: Cadastrar 20 Produtos
    [Tags]                                                                              POST                  Cadastrar_Produto    Cadastar_Produto_20_Produtos
    Logar E Salvar Token Como                                                           "Administrador"
    FOR                                                                                 ${i}                  IN RANGE             20
    ${produto} =                                                                        Gerar Novo Produto
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Status Code "201"
    Validar Se A Key Nao Esta Vazia "_id"
    END

Cenario: Tentar Cadastrar Produto Valido Nao Administrador
    [Tags]                                                                              POST                   Cadastrar_Produto    Cadastar_Produto_Valido_Nao Administrador
    ${produto} =                                                                        Gerar Novo Produto
    Logar E Salvar Token Como                                                           "Nao Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Mensagem "Rota exclusiva para administradores"
    Validar Status Code "403"

Cenario: Tentar Cadastar Produto Nao Autenticado
    [Tags]                                                                                                POST                  Cadastrar_Produto    Cadastar_Produto_Nao_Autenticado
    ${produto} =                                                                                          Gerar Novo Produto
    POST EndPoint "/produtos" Com Body "${produto}"
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"

Cenario: Tentar Cadastrar Produto Com Token Invalido
    [Tags]                                                                                                POST                  Cadastrar_Produto    Cadastar_Produto_Com_Token_Invalido
    ${produto} =                                                                                          Gerar Novo Produto
    POST EndPoint "/produtos" Com Body "${produto}" Com Token Invalido
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"

Cenario: Tentar Cadastrar Produto Ja Cadastrado
    [Tags]                                                                              POST                        Cadastrar_Produto    Cadastar_Produto_Ja_Cadastrado
    ${produto} =                                                                        Pegar Produto Cadastrado
    Remove From Dictionary                                                              ${produto}                  _id
    Logar E Salvar Token Como                                                           "Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Mensagem "Já existe produto com esse nome"
    Validar Status Code "400"

Cenario: Tentar Cadastar Produto Com Nome Vazio
    [Tags]                                                                              POST                                        Cadastrar_Produto    Cadastar_Produto_Com_Nome_Vazio
    ${produto} =                                                                        Pegar Produto Do JSON Sem O Campo "nome"
    Logar E Salvar Token Como                                                           "Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "nome" Com O Valor "nome é obrigatório"

Cenario: Tentar Cadastar Produto Com Preco Vazio
    [Tags]                                                                              POST                                         Cadastrar_Produto    Cadastar_Produto_Com_Preco_Vazio
    ${produto} =                                                                        Pegar Produto Do JSON Sem O Campo "preco"
    Logar E Salvar Token Como                                                           "Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "preco" Com O Valor "preco é obrigatório"

Cenario: Tentar Cadastar Produto Com Preco Invalido
    [Tags]                                                                              POST                                                  Cadastrar_Produto    Cadastar_Produto_Preco_Invalido
    ${produto} =                                                                        Pegar Produto Do JSON Com o Campo "preco" Invalido
    Logar E Salvar Token Como                                                           "Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "preco" Com O Valor "preco deve ser um inteiro"

Cenario: Tentar Cadastar Produto Com Descricao Vazia
    [Tags]                                                                              POST                                             Cadastrar_Produto    Cadastar_Produto_Com_Descricao_Vazia
    ${produto} =                                                                        Pegar Produto Do JSON Sem O Campo "descricao"
    Logar E Salvar Token Como                                                           "Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "descricao" Com O Valor "descricao é obrigatório"

Cenario: Tentar Cadastar Produto Com Quantidade Vazia
    [Tags]                                                                              POST                                              Cadastrar_Produto    Cadastar_Produto_Com_Quantidade_Vazia
    ${produto} =                                                                        Pegar Produto Do JSON Sem O Campo "quantidade"
    Logar E Salvar Token Como                                                           "Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "quantidade" Com O Valor "quantidade é obrigatório"

Cenario: Tentar Cadastrar Produto Com A Quantidade Invalida
    [Tags]                                                                              POST                                                       Cadastrar_Produto    Cadastar_Produto_Quantidade_Invalida
    ${produto} =                                                                        Pegar Produto Do JSON Com o Campo "quantidade" Invalido
    Logar E Salvar Token Como                                                           "Administrador"
    POST Autenticado EndPoint "/produtos" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "quantidade" Com O Valor "quantidade deve ser um inteiro"

######################
#    PUT PRODUTOS    #
######################
Cenario: Atualizar Produto Não Cadastrado
    [Tags]                                                                                       PUT                   Produtos    PUT_Produtos    Atualizar_Produto_NAO_CADASTRADO
    ${produto} =                                                                                 Gerar Novo Produto
    Logar E Salvar Token Como                                                                    "Administrador"
    PUT Autenticado EndPoint "/produtos/NaoExisto" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"

Cenario: Atualizar Nome do Produto
    [Tags]                                                                                               PUT                                         Produtos    PUT_Produtos    Atualizar_Produto_Nome 
    ${produto} =                                                                                         Alterar "String" Campo "nome" Do Produto
    Logar E Salvar Token Como                                                                            "Administrador"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"

Cenario: Atualizar Descrição do Produto
    [Tags]                                                                                               PUT                                              Produtos    PUT_Produtos    Atualizar_Produto_Descricao 
    ${produto} =                                                                                         Alterar "String" Campo "descricao" Do Produto
    Logar E Salvar Token Como                                                                            "Administrador"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"

Cenario: Atualizar Preço do Produto
    [Tags]                                                                                               PUT                                           Produtos    PUT_Produtos    Atualizar_Produto_Preco 
    ${produto} =                                                                                         Alterar "Integer" Campo "preco" Do Produto
    Logar E Salvar Token Como                                                                            "Administrador"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"

Cenario: Atualizar Quantidade do Produto
    [Tags]                                                                                               PUT                                                Produtos    PUT_Produtos    Atualizar_Produto_Quantidade 
    ${produto} =                                                                                         Alterar "Integer" Campo "quantidade" Do Produto
    Logar E Salvar Token Como                                                                            "Administrador"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"


Cenario: Tentar Atualizar Produto Cadastrado Sem Autenticacao
    [Tags]                                                                                                PUT                         Produtos    PUT_Produtos    Atualizar_Produto_Sem_Autenticacao
    ${produto} =                                                                                          Pegar Produto Cadastrado
    PUT Endpoint "/produtos/${produto['_id']}" Com Body "${produto}"
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"

Cenario: Tentar Atualizar Produto Autenticado Como Nao Administrador
    [Tags]                                                                                               PUT                         Produtos    PUT_Produtos    Atualizar_Produto_Nao Administrador
    ${produto} =                                                                                         Pegar Produto Cadastrado
    Logar E Salvar Token Como                                                                            "Nao Administrador"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "403"
    Validar Mensagem "Rota exclusiva para administradores"

Cenario: Tentar Atualizar Produto Cadastrado Com Token Invalido
    [Tags]                                                                                                PUT                         Produtos    PUT_Produtos    Atualizar_Produto_Token_Invalido
    ${produto} =                                                                                          Pegar Produto Cadastrado
    PUT EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Com Token Invalido
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"

Cenario: Tentar Atualizar Produto Sem Alteracao
    [Tags]                                                                                       PUT                         Produtos    PUT_Produtos    Atualizar_Produto_Sem_Alteracao
    ${produto} =                                                                                 Pegar Produto Cadastrado
    Logar E Salvar Token Como                                                                    "Administrador"
    PUT Autenticado EndPoint "/produtos/NaoExisto" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"

Cenario: Tentar Atualizar Produto Com Preco Invalido
    [Tags]                                                                                               PUT                                                   Produtos    PUT_Produtos    Atualizar_Produto_Preco_Invalido
    ${produto} =                                                                                         Pegar Produto Do JSON Com o Campo "preco" Invalido
    Logar E Salvar Token Como                                                                            "Administrador"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"
    Validar "preco" Com O Valor "preco deve ser um inteiro"

Cenario: Tentar Atualizar Produto Com Quantidade Invalida
    [Tags]                                                                                               PUT                                                        Produtos    PUT_Produtos    Atualizar_Produto_Quantidade_Invalida
    ${produto} =                                                                                         Pegar Produto Do JSON Com o Campo "quantidade" Invalido
    Logar E Salvar Token Como                                                                            "Administrador"
    PUT Autenticado EndPoint "/produtos/${produto['_id']}" Com Body "${produto}" Headers "${headers}"
    Validar Status Code "400"

#########################
#    DELETE PRODUTOS    #
#########################
Cenario: Deletar Produto Cadastrado
    [Tags]                                                                            DELETE             Produtos    DELETE_Produtos    Deletar_Produto_Cadastrado
    Cadastar Novo Produto
    Logar E Salvar Token Como                                                         "Administrador"
    DELETE Autenticado EndPoint "/produtos/${produto['_id']}" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"

Cenario: Tentar Deletar Produto Não Cadastrado
    [Tags]                                                                    DELETE             Produtos    DELETE_Produtos    Deletar_Produto_Nao_Cadastrado
    Logar E Salvar Token Como                                                 "Administrador"
    DELETE Autenticado EndPoint "/produtos/NaoExisto" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Nenhum registro excluído"

Cenario: Tentar Deletar Produto Cadastrado Sem Autenticacao
    [Tags]                                                                                                DELETE    Produtos    DELETE_Produtos    Deletar_Produto_Sem_Autenticacao
    Cadastar Novo Produto
    DELETE Endpoint "/produtos/${produto['_id']}"
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"

Cenario: Tentar Deletar Produto Cadastrado Com Autenticacao De Nao Administrador
    [Tags]                                                                            DELETE                 Produtos    DELETE_Produtos    Deletar_Produto_Nao Administrador
    Cadastar Novo Produto
    Logar E Salvar Token Como                                                         "Nao Administrador"
    DELETE Autenticado EndPoint "/produtos/${produto['_id']}" Headers "${headers}"
    Validar Status Code "403"