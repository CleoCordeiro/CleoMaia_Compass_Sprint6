#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo De Testes Relacionandos Ao EndPoint Carrinhos
Resource         ../keywords/carrinhos_keywords.resource
Suite Setup      Criar Sessao

#Sessão para criação de cenários de teste
*** Test Cases ***
#######################
#    GET CARRINHOS    #
#######################
Cenario: Listar Todos Os Carrinhos Cadastrados
    [Tags]                                 GET    Carrinhos    GET_Carrinhos    Buscar_Todos_Carrinhos
    Cadastrar Novo Carrinho
    Get Endpoint "/carrinhos"
    Validar Status Code "200"
    Validar Quantidade De Carrinhos > 0

Cenario: Buscar Carrinho Cadastrado
    [Tags]                                                                                                                                                                     GET                          Carrinhos    GET_Carrinhos    Buscar_Carrinho_Cadastrado
    Cadastrar Novo Carrinho
    ${carrinho} =                                                                                                                                                              Pegar Carrinho Cadastrado
    Get Endpoint "/carrinhos?_id=${carrinho['_id']}&precoTotal=${carrinho['precoTotal']}&quantidadeTotal=${carrinho['quantidadeTotal']}&idUsuario=${carrinho['idUsuario']}"
    Validar Status Code "200"
    Validar Quantidade De Carrinhos > 0

Cenario: Tentar Buscar Carrinho Nao Cadastrado
    [Tags]                                        GET    Carrinhos    GET_Carrinhos    Buscar_Carrinho_Nao_Cadastrado
    Get Endpoint "/carrinhos/NaoCadastrado"
    Validar Status Code "400"
    Validar Mensagem "Carrinho não encontrado"

########################
#    POST CARRINHOS    #
########################
Cenario: Cadastrar Carrinho Valido Administrador
    [Tags]                                                                                GET                            Carrinhos    POST_Carrinhos    Cadastrar_Carrinho_Valido_Administrador
    ${carrinho} =                                                                         Criar Dados Carrinho Valido
    Logar E Salvar Token Como                                                             "Administrador"
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"

Cenario: Cadastrar Carrinho Valido Nao Administrador
    [Tags]                                                                                GET                            Carrinhos    POST_Carrinhos    Cadastrar_Carrinho_Valido_Nao_Administrador
    ${carrinho} =                                                                         Criar Dados Carrinho Valido
    Logar E Salvar Token Como                                                             "Nao Administrador"
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"

Cenario: Tentar Cadastrar Carrinho Valido Sem Autenticacao
    [Tags]                                                                                                GET                            Carrinhos    POST_Carrinhos    Cadastrar_Carrinho_Valido_Sem_Autenticacao
    ${carrinho} =                                                                                         Criar Dados Carrinho Valido
    POST EndPoint "/carrinhos" Com Body "${carrinho}"
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"

Cenario: Tentar Cadastrar Mais de Um Carrinho
    [Tags]                                                                                GET                            Carrinhos    POST_Carrinhos    Cadastrar_Carrinho_Mais_De_Um
    ${carrinho} =                                                                         Criar Dados Carrinho Valido
    Logar E Salvar Token Como                                                             "Administrador"
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"
    ${carrinho} =                                                                         Criar Dados Carrinho Valido
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "400"
    Validar Mensagem "Não é permitido ter mais de 1 carrinho"

Cenraio: Tentar Cadastrar Carrinho Com Produto Invalido
    [Tags]                                                                                GET                    Carrinhos         POST_Carrinhos      Cadastrar_Carrinho_Produto_Invalido
    ${carrinho} =                                                                         Pegar Key Do Json      carrinhos.json    produto_invalido
    Logar E Salvar Token Como                                                             "Nao Administrador"
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "400"
    Validar Mensagem "Produto não encontrado"

Cenario: Tentar Cadastrar Carrinho Com Quantidade Insuficiente
    [Tags]                                                                                GET                    Carrinhos         POST_Carrinhos             Cadastrar_Carrinho_Quantidade_Insuficiente
    ${carrinho} =                                                                         Pegar Key Do Json      carrinhos.json    quantidade_insuficiente
    Logar E Salvar Token Como                                                             "Nao Administrador"
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "400"
    Validar Mensagem "Produto não possui quantidade suficiente"

Cenario: Tentar Cadastrar Carrinho Invalido Sem idProduto
    [Tags]                                                                                GET                  Carrinhos         POST_Carrinhos    Cadastrar_Carrinho_Sem_idProduto
    ${carrinho} =                                                                         Pegar Key Do Json    carrinhos.json    sem_idProduto
    Logar E Salvar Token Como                                                             "Administrador"
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "400"
    Validar "produtos" Com O Valor "produtos não contém 1 valor obrigatório"

Cenario: Tentar Cadastrar Carrinho Invalido Sem Quantidade
    [Tags]                                                                                GET                  Carrinhos         POST_Carrinhos    Cadastrar_Carrinho_Sem_Quantidade
    ${carrinho} =                                                                         Pegar Key Do Json    carrinhos.json    sem_quantidade
    Logar E Salvar Token Como                                                             "Administrador"
    POST Autenticado EndPoint "/carrinhos" Com Body "${carrinho}" Headers "${headers}"
    Validar Status Code "400"
    Validar "produtos" Com O Valor "produtos não contém 1 valor obrigatório"

##########################
#    DELETE CARRINHOS    #
##########################
Cenario: Concluir Compra Com Carrinho Valido
    [Tags]                                                                          DELETE    Carrinhos    DELETE_Carrinhos    Concluir_Compra    Concluir_Compra_Carrinho_Valido 
    Cadastrar Novo Carrinho
    DELETE Autenticado EndPoint "carrinhos/concluir-compra" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"

Cenario: Tentar Concluir Compra Usuario Sem Carrinho
    [Tags]                                                                          DELETE                 Carrinhos    DELETE_Carrinhos    Concluir_Compra_Carrinho_Invalido
    Logar E Salvar Token Como                                                       "Nao Administrador"
    DELETE Autenticado EndPoint "carrinhos/concluir-compra" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Não foi encontrado carrinho para esse usuário"

Cenario: Tentar Concluir Compra Com Carrinho Valido Token Invalido
    [Tags]                                                                                                DELETE                       Carrinhos    DELETE_Carrinhos    Concluir_Compra    Concluir_Compra_Token_Invalido
    ${carrinho} =                                                                                         Pegar Carrinho Cadastrado
    DELETE EndPoint "carrinhos/concluir-compra" Com Token Invalido
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"


Cenario: Cancelar Compra Com Carrinho Valido
    [Tags]                                                                                 DELETE    Carrinhos    DELETE_Carrinhos    Cancelar_Compra    Cancelar_Compra_Carrinho_Valido
    Cadastrar Novo Carrinho
    DELETE Autenticado EndPoint "carrinhos/cancelar-compra" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso. Estoque dos produtos reabastecido"


Cenario: Tentar Cancelar Compra Usuario Sem Carrinho
    [Tags]                                                                          DELETE                 Carrinhos    DELETE_Carrinhos    Cancelar_Compra    Cancelar_Compra_Carrinho_Invalido
    Logar E Salvar Token Como                                                       "Nao Administrador"
    DELETE Autenticado EndPoint "carrinhos/cancelar-compra" Headers "${headers}"
    Validar Status Code "200"
    Validar Mensagem "Não foi encontrado carrinho para esse usuário"

Cenario: Tentar Cancelar Compra Com Carrinho Valido Token Invalido
    [Tags]                                                                                                DELETE                       Carrinhos    DELETE_Carrinhos    Cancelar_Compra    Cancelar_Compra_Token_Invalido
    ${carrinho} =                                                                                         Pegar Carrinho Cadastrado
    DELETE EndPoint "carrinhos/concluir-compra" Com Token Invalido
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"


