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
CT67: Listar Todos Os Carrinhos Cadastrados
    [Tags]                                           GET    Carrinhos    GET_Carrinhos    Buscar_Todos_Carrinhos
    Cadastrar Novo Carrinho
    Custom On Session                                GET    Carrinhos
    Validar Status Code "200"
    Validar Estrutura Da Resposta "carrinhos_get"
    Validar Se A Quantidade De Carrinhos E > 0

CT68: Buscar Carrinho Cadastrado
    [Tags]                                              GET    Carrinhos                       GET_Carrinhos    Buscar_Carrinho_Cadastrado
    Cadastrar Novo Carrinho
    Pegar Carrinho Cadastrado
    Custom On Session                                   GET    Carrinhos/${carrinho['_id']}
    Validar Status Code "200"
    Validar Estrutura Da Resposta "carrinhos_get_id"
    Validar Se A Quantidade De Carrinhos E > 0

CT69: Tentar Buscar Carrinho Nao Cadastrado
    [Tags]                                        GET    Carrinhos                  GET_Carrinhos    Buscar_Carrinho_Nao_Cadastrado
    Custom On Session                             GET    Carrinhos/NaoCadastrado
    Validar Status Code "400"
    Validar Mensagem "Carrinho não encontrado"
    Validar Estrutura Da Resposta "message"

########################
#    POST CARRINHOS    #
########################
CT70: Cadastrar Carrinho Valido Administrador
    [Tags]                                                       POST               Carrinhos    POST_Carrinhos      Cadastrar_Carrinho_Valido_Administrador
    Pegar Quantidade de "Carrinhos"
    Criar Dados Carrinho Valido
    Logar E Salvar Token Como                                    "Administrador"
    Custom On Session                                            POST               Carrinhos    json=${carrinho}    headers=${headers}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Estrutura Da Resposta "message_id"
    Validar Se A Quantidade De Carrinhos E == ${quantidade+1}

CT71: Cadastrar Carrinho Valido Nao Administrador
    [Tags]                                                       POST                   Carrinhos    POST_Carrinhos      Cadastrar_Carrinho_Valido_Nao_Administrador
    Pegar Quantidade de "Carrinhos"
    Criar Dados Carrinho Valido
    Logar E Salvar Token Como                                    "Nao Administrador"
    Custom On Session                                            POST                   Carrinhos    json=${carrinho}    headers=${headers}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Estrutura Da Resposta "message_id"
    Validar Se A Quantidade De Carrinhos E == ${quantidade+1}

CT72: Cadastrar 200 Carrinhos
    [Tags]                                                                                POST                          Carrinhos    POST_Carrinhos                Teste_De_Carga_Carrinho
    Criar Dados Lista De Carrinhos                                                        ${teste_de_carga_carrinho}
    Pegar Quantidade de "Carrinhos"
    Custom Theard Request                                                                 POST                          Carrinhos    data=${lista_de_carrinhos}    new_user=True
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Estrutura Da Resposta "message_id"
    Validar Se A Quantidade De Carrinhos E == ${quantidade+${teste_de_carga_carrinho}}
    teste_de_carga_produto ${teste_de_carga_carrinho}

CT73: Tentar Cadastrar Carrinho Valido Sem Autenticacao
    [Tags]                                                                                                GET     Carrinhos    POST_Carrinhos      Cadastrar_Carrinho_Valido_Sem_Autenticacao
    Criar Dados Carrinho Valido
    Pegar Quantidade de "Carrinhos"
    Custom On Session                                                                                     POST    Carrinhos    json=${carrinho}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

CT74: Tentar Cadastrar Mais de Um Carrinho Com O Mesmo Usuario
    [Tags]                                                       GET     Carrinhos    POST_Carrinhos      Cadastrar_Carrinho_Mais_De_Um
    Pegar Quantidade de "Carrinhos"
    Cadastrar Novo Carrinho
    Criar Dados Carrinho Valido
    Custom On Session                                            POST    Carrinhos    json=${carrinho}    headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Não é permitido ter mais de 1 carrinho"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade+1}

CT75: Tentar Cadastrar Carrinho Com Produto Invalido
    [Tags]                                                     GET                    Carrinhos           POST_Carrinhos              Cadastrar_Carrinho_Produto_Invalido
    Pegar Quantidade de "Carrinhos"
    Pegar Key Do Json                                          carrinhos.json         produto_invalido
    Logar E Salvar Token Como                                  "Nao Administrador"
    Custom On Session                                          POST                   Carrinhos           json=${produto_invalido}    headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Produto não encontrado"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

CT76: Tentar Cadastrar Carrinho Com Quantidade Insuficiente
    [Tags]                                                         GET                    Carrinhos    POST_Carrinhos      Cadastrar_Carrinho_Quantidade_Insuficiente
    Pegar Quantidade de "Carrinhos"
    Carrinho Com Produto Sem Quantidade Suficiente
    Logar E Salvar Token Como                                      "Nao Administrador"
    Custom On Session                                              POST                   Carrinhos    json=${carrinho}    headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Produto não possui quantidade suficiente"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

CT77: Tentar Cadastrar Carrinho Invalido Sem A Key idProduto
    [Tags]                                                     GET                Carrinhos        POST_Carrinhos           Cadastrar_Carrinho_Sem_idProduto
    Pegar Quantidade de "Carrinhos"
    Pegar Key Do Json                                          carrinhos.json     sem_idProduto
    Logar E Salvar Token Como                                  "Administrador"
    Custom On Session                                          POST               Carrinhos        json=${sem_idProduto}    headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Produto não encontrado"
    #Validar "produtos" Com O Valor "produtos não contém 1 valor obrigatório"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

CT78: Tentar Cadastrar Carrinho Invalido Sem A Key Quantidade
    [Tags]                                                         GET                Carrinhos         POST_Carrinhos            Cadastrar_Carrinho_Sem_Quantidade
    Pegar Quantidade de "Carrinhos"
    Pegar Key Do Json                                              carrinhos.json     sem_quantidade
    Logar E Salvar Token Como                                      "Administrador"
    Custom On Session                                              POST               Carrinhos         json=${sem_quantidade}    headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Produto não possui quantidade suficiente"
    #Validar "produtos" Com O Valor "produtos não contém 1 valor obrigatório"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

##########################
#    DELETE CARRINHOS    #
##########################
CT79: Concluir Compra Com Carrinho Valido
    [Tags]                                                       DELETE    Carrinhos                    DELETE_Carrinhos      Concluir_Compra    Concluir_Compra_Carrinho_Valido 
    Cadastrar Novo Carrinho
    Pegar Quantidade de "Carrinhos"
    Custom On Session                                            DELETE    Carrinhos/concluir-compra    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade-1}

CT80: Tentar Concluir Compra Usuario Sem Carrinho
    [Tags]                                                              DELETE                 Carrinhos                    DELETE_Carrinhos      Concluir_Compra_Carrinho_Invalido
    Pegar Quantidade de "Carrinhos"
    Logar E Salvar Token Como                                           "Nao Administrador"
    Custom On Session                                                   DELETE                 Carrinhos/concluir-compra    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Não foi encontrado carrinho para esse usuário"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

CT81: Tentar Concluir Compra Com Carrinho Valido Sem Autenticacao
    [Tags]                                                                                                DELETE    Carrinhos                    DELETE_Carrinhos      Concluir_Compra_Carrinho_Valido_Sem_Autenticacao
    Pegar Quantidade de "Carrinhos"
    Pegar Carrinho Cadastrado
    Gerar Token Invalido
    Custom On Session                                                                                     DELETE    Carrinhos/concluir-compra    headers=${headers}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

CT82: Tentar Concluir Compra Com Carrinho Valido Token Invalido
    [Tags]                                                                                                DELETE    Carrinhos                    DELETE_Carrinhos      Concluir_Compra    Concluir_Compra_Token_Invalido
    Pegar Quantidade de "Carrinhos"
    Pegar Carrinho Cadastrado
    Gerar Token Invalido
    Custom On Session                                                                                     DELETE    Carrinhos/concluir-compra    headers=${headers}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

CT83: Cancelar Compra Com Carrinho Valido
    [Tags]                                                                                 DELETE    Carrinhos                    DELETE_Carrinhos      Cancelar_Compra    Cancelar_Compra_Carrinho_Valido
    Cadastrar Novo Carrinho
    Pegar Quantidade de "Carrinhos"
    Custom On Session                                                                      DELETE    Carrinhos/cancelar-compra    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso. Estoque dos produtos reabastecido"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade-1}

CT84: Tentar Cancelar Compra Usuario Sem Carrinho
    [Tags]                                                              DELETE                 Carrinhos                    DELETE_Carrinhos      Cancelar_Compra    Cancelar_Compra_Carrinho_Invalido
    Pegar Quantidade de "Carrinhos"
    Logar E Salvar Token Como                                           "Nao Administrador"
    Custom On Session                                                   DELETE                 Carrinhos/cancelar-compra    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Não foi encontrado carrinho para esse usuário"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

CT85: Tentar Cancelar Compra Com Carrinho Valido Sem Autenticacao
    [Tags]                                                                                                DELETE    Carrinhos                    DELETE_Carrinhos    Cancelar_Compra    Cancelar_Compra_Carrinho_Valido_Sem_Autenticacao
    Pegar Quantidade de "Carrinhos"
    Pegar Carrinho Cadastrado
    Custom On Session                                                                                     DELETE    Carrinhos/cancelar-compra
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}

CT86: Tentar Cancelar Compra Com Carrinho Valido Token Invalido
    [Tags]                                                                                                DELETE    Carrinhos                    DELETE_Carrinhos      Cancelar_Compra    Cancelar_Compra_Token_Invalido
    Pegar Quantidade de "Carrinhos"
    Pegar Carrinho Cadastrado
    Gerar Token Invalido
    Custom On Session                                                                                     DELETE    Carrinhos/concluir-compra    headers=${headers}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Carrinhos E == ${quantidade}