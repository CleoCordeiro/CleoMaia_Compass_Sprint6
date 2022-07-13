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
CT33: Listar Todos Os Produtos Cadastrados
    [Tags]                                          GET    Produtos    GET_Produtos    Buscar_Todos_Produtos
    Cadastrar Novo Produto
    Custom On Session                               GET    Produtos
    Validar Status Code "200"
    Validar Estrutura Da Resposta "produtos_get"
    Validar Se A Quantidade De Produtos E > 0

CT34: Buscar Produto Cadastrado
    [Tags]                                          GET    Produtos                      GET_Produtos    Buscar_Produto_Cadastrado
    Cadastrar Novo Produto
    Pegar Produto Cadastrado
    Custom On Session                               GET    Produtos/${produto['_id']}
    Validar Status Code "200"
    Validar Estrutura Da Resposta "produtos_get"
    Validar Se A Quantidade De Produtos E > 0

CT35: Tentar Buscar Produto Nao Cadastrado
    [Tags]                                       GET    Produtos                  GET_Produtos    Buscar_Produto_Nao_Cadastrado
    Custom On Session                            GET    Produtos/NaoCadastrado
    Validar Status Code "400"
    Validar Mensagem "Produto não encontrado"
    Validar Estrutura Da Resposta "message"

#######################
#    POST PRODUTOS    #
#######################
CT36: Cadastrar Produto Valido
    [Tags]                                                      POST               Produtos    Cadastrar_Produto    Cadastrar_Produto_Valido
    Criar Dados Produto Valido
    Logar E Salvar Token Como                                   "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                           POST               Produtos    json=${produto}      headers=${headers}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Estrutura Da Resposta "message_id"
    Validar Se A Quantidade De Produtos E == ${quantidade+1}

CT37: Cadastrar 200 Produtos
    [Tags]                                                                              POST                         Produtos    Cadastrar_Produto            Teste_De_Carga_Produto
    Criar Dados Lista De Produto                                                        ${teste_de_carga_produto}
    Logar E Salvar Token Como                                                           "Administrador"
    Pegar Quantidade de "Produtos"
    Custom Theard Request                                                               POST                         Produtos    data=${lista_de_produtos}    headers=${headers}
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Status Code "201"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Estrutura Da Resposta "message_id"
    Validar Se A Quantidade De Produtos E == ${quantidade+${teste_de_carga_produto}}
    Validar Tempo De Resposta ${teste_de_carga_produto}

CT38: Cadastrar Produto Nome Com Acentos
    [Tags]                                                                    POST               Produtos    Cadastrar_Produto    Cadastrar_Produto_Nome_Com_Acentos
    Criar Dados Produto Nome Com Acentos
    Logar E Salvar Token Como                                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                                         POST               Produtos    json=${produto}      headers=${headers}
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Status Code "201"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Estrutura Da Resposta "message_id"
    Validar Nome Do Produto "${response_body['_id']}" "${produto['nome']}"


CT39: Tentar Cadastrar Produto Valido Nao Administrador
    [Tags]                                                    POST                   Produtos    Cadastrar_Produto    Cadastrar_Produto_Valido_Nao Administrador
    Criar Dados Produto Valido
    Logar E Salvar Token Como                                 "Nao Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         POST                   Produtos    json=${produto}      headers=${headers}
    Validar Status Code "403"
    Validar Mensagem "Rota exclusiva para administradores"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT40: Tentar Cadastrar Produto Nao Autenticado
    [Tags]                                                                                                POST    Produtos    Cadastrar_Produto    Cadastrar_Produto_Nao_Autenticado
    Criar Dados Produto Valido
    Pegar Quantidade de "Produtos"
    Custom On Session                                                                                     POST    Produtos    json=${produto}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT41: Tentar Cadastrar Produto Com Token Invalido
    [Tags]                                                                                                POST    Produtos    Cadastrar_Produto    Cadastrar_Produto_Com_Token_Invalido
    Criar Dados Produto Valido
    Pegar Quantidade de "Produtos"
    Gerar Token Invalido
    Custom On Session                                                                                     POST    Produtos    json=${produto}      headers=${headers}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT42: Tentar Cadastrar Produto Ja Cadastrado
    [Tags]                                                    POST               Produtos    Cadastrar_Produto    Cadastrar_Produto_Ja_Cadastrado
    Pegar Produto Cadastrado
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         POST               Produtos    json=${produto}      headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT43: Tentar Cadastrar Produto Com Nome Vazio
    [Tags]                                                    POST               Produtos    Cadastrar_Produto    Cadastrar_Produto_Com_Nome_Vazio
    Pegar Produto Do JSON Sem O Campo "nome"
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         POST               Produtos    json=${produto}      headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    #Validar "nome" Com O Valor "nome é obrigatório"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT44: Tentar Cadastrar Produto Com Preco Vazio
    [Tags]                                                    POST               Produtos    Cadastrar_Produto    Cadastrar_Produto_Com_Preco_Vazio
    Pegar Produto Do JSON Sem O Campo "preco"
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         POST               Produtos    json=${produto}      headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    #Validar "preco" Com O Valor "preco é obrigatório"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT45: Tentar Cadastrar Produto Com Preco Invalido
    [Tags]                                                    POST               Produtos    Cadastrar_Produto    Cadastrar_Produto_Preco_Invalido
    Pegar Produto Do JSON Com o Campo "preco" Invalido
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         POST               Produtos    json=${produto}      headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    #Validar "preco" Com O Valor "preco deve ser um inteiro"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT46: Tentar Cadastrar Produto Com Descricao Vazia
    [Tags]                                                    POST               Produtos    Cadastrar_Produto    Cadastrar_Produto_Com_Descricao_Vazia
    Pegar Produto Do JSON Sem O Campo "descricao"
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         POST               Produtos    json=${produto}      headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    #Validar "descricao" Com O Valor "descricao é obrigatório"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT47: Tentar Cadastrar Produto Com Quantidade Vazia
    [Tags]                                                    POST               Produtos    Cadastrar_Produto    Cadastrar_Produto_Com_Quantidade_Vazia
    Pegar Produto Do JSON Sem O Campo "quantidade"
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         POST               Produtos    json=${produto}      headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    #Validar "quantidade" Com O Valor "quantidade é obrigatório"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT48: Tentar Cadastrar Produto Com A Quantidade Invalida
    [Tags]                                                     POST               Produtos    Cadastrar_Produto    Cadastrar_Produto_Quantidade_Invalida
    Pegar Produto Do JSON Com o Campo "quantidade" Invalido
    Logar E Salvar Token Como                                  "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                          POST               Produtos    json=${produto}      headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    #Validar "quantidade" Com O Valor "quantidade deve ser um inteiro"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

######################
#    PUT PRODUTOS    #
######################
CT49: Atualizar Nome do Produto
    [Tags]                                                    PUT                Produtos                      PUT_Produtos       Atualizar_Produto_Nome 
    Alterar "String" Campo "nome" Do Produto
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         PUT                Produtos/${produto['_id']}    json=${produto}    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT50: Atualizar Descrição do Produto
    [Tags]                                                    PUT                Produtos                      PUT_Produtos       Atualizar_Produto_Descricao 
    Alterar "String" Campo "descricao" Do Produto
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         PUT                Produtos/${produto['_id']}    json=${produto}    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT51: Atualizar Preço do Produto
    [Tags]                                                    PUT                Produtos                      PUT_Produtos       Atualizar_Produto_Preco 
    Alterar "Integer" Campo "preco" Do Produto
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         PUT                Produtos/${produto['_id']}    json=${produto}    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT52: Atualizar Quantidade do Produto
    [Tags]                                                    PUT                Produtos                      PUT_Produtos       Atualizar_Produto_Quantidade 
    Alterar "Integer" Campo "quantidade" Do Produto
    Logar E Salvar Token Como                                 "Administrador"    
    Pegar Quantidade de "Produtos"                            
    Custom On Session                                         PUT                Produtos/${produto['_id']}    json=${produto}    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT53: Atualizar Produto Sem Alteracao
    [Tags]                                                    PUT                Produtos                      PUT_Produtos       Atualizar_Produto_Sem_Alteracao
    Pegar Produto Cadastrado
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         PUT                Produtos/${produto['_id']}    json=${produto}    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT54: Tentar Atualizar Produto Não Cadastrado
    [Tags]                                                      PUT                Produtos              PUT_Produtos       Atualizar_Produto_NAO_CADASTRADO
    Criar Dados Produto Valido
    Logar E Salvar Token Como                                   "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                           PUT                Produtos/NaoExisto    json=${produto}    headers=${headers}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Estrutura Da Resposta "message_id"
    Validar Se A Quantidade De Produtos E == ${quantidade+1}

CT55: Tentar Atualizar Produto Cadastrado Sem Autenticacao
    [Tags]                                                                                                PUT    Produtos                      PUT_Produtos       Atualizar_Produto_Sem_Autenticacao
    Pegar Produto Cadastrado
    Pegar Quantidade de "Produtos"
    Custom On Session                                                                                     PUT    Produtos/${produto['_id']}    json=${produto}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT56: Tentar Atualizar Produto Cadastrado Com Token Invalido
    [Tags]                                                                                                PUT    Produtos                      PUT_Produtos       Atualizar_Produto_Token_Invalido
    Pegar Produto Cadastrado
    Pegar Quantidade de "Produtos"
    Gerar Token Invalido
    Custom On Session                                                                                     PUT    Produtos/${produto['_id']}    json=${produto}    headers=${headers}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT57: Tentar Atualizar Produto Cadastrar Sem Informar O ID
    [Tags]                                                    PUT                Produtos              PUT_Produtos       Atualizar_Produto_Sem_ID
    Pegar Produto Cadastrado
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         PUT                Produtos/NaoExisto    json=${produto}    headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT58: Tentar Atualizar Produto Autenticado Como Nao Administrador
    [Tags]                                                    PUT                    Produtos                      PUT_Produtos       Atualizar_Produto_Nao Administrador
    Pegar Produto Cadastrado
    Logar E Salvar Token Como                                 "Nao Administrador"
    Pegar Quantidade de "Produtos"                            
    Custom On Session                                         PUT                    Produtos/${produto['_id']}    json=${produto}    headers=${headers}
    Validar Status Code "403"
    Validar Mensagem "Rota exclusiva para administradores"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT59: Tentar Atualizar Produto Com Preco Invalido
    [Tags]                                                    PUT                Produtos                      PUT_Produtos       Atualizar_Produto_Preco_Invalido
    Pegar Produto Do JSON Com o Campo "preco" Invalido
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"                            
    Custom On Session                                         PUT                Produtos/${produto['_id']}    json=${produto}    headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Já existe produto com esse nome"
    #Validar "preco" Com O Valor "preco deve ser um inteiro"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT60: Tentar Atualizar Produto Com Quantidade Invalida
    [Tags]                                                     PUT                Produtos                      PUT_Produtos       Atualizar_Produto_Quantidade_Invalida
    Pegar Produto Do JSON Com o Campo "quantidade" Invalido
    Logar E Salvar Token Como                                  "Administrador"
    Pegar Quantidade de "Produtos"                             
    Custom On Session                                          PUT                Produtos/${produto['_id']}    json=${produto}    headers=${headers}
    Validar Status Code "400"
    #Validar "quantidade" Com O Valor "quantidade deve ser um inteiro"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

#########################
#    DELETE PRODUTOS    #
#########################
CT61: Deletar Produto Cadastrado
    [Tags]                                                      DELETE             Produtos                      DELETE_Produtos       Deletar_Produto_Cadastrado
    Cadastrar Novo Produto
    Logar E Salvar Token Como                                   "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                           DELETE             Produtos/${produto['_id']}    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade-1}

CT62: Tentar Deletar Produto Não Cadastrado
    [Tags]                                                    DELETE             Produtos              DELETE_Produtos       Deletar_Produto_Nao_Cadastrado
    Logar E Salvar Token Como                                 "Administrador"
    Pegar Quantidade de "Produtos"
    Custom On Session                                         DELETE             Produtos/NaoExisto    headers=${headers}
    Validar Status Code "200"
    Validar Mensagem "Nenhum registro excluído"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT63: Tentar Deletar Produto Cadastrado Sem Autenticacao
    [Tags]                                                                                                DELETE    Produtos                      DELETE_Produtos    Deletar_Produto_Sem_Autenticacao
    Cadastrar Novo Produto
    Pegar Quantidade de "Produtos"
    Custom On Session                                                                                     DELETE    Produtos/${produto['_id']}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT64: Tentar Deletar Produto Cadastrado Com Token Invalido
    [Tags]                                                                                                DELETE    Produtos                      DELETE_Produtos       Deletar_Produto_Token_Invalido
    Cadastrar Novo Produto
    Pegar Quantidade de "Produtos"
    Gerar Token Invalido
    Custom On Session                                                                                     DELETE    Produtos/${produto['_id']}    headers=${headers}
    Validar Status Code "401"
    Validar Mensagem "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT65: Tentar Deletar Produto Cadastrado Com Autenticacao De Nao Administrador
    [Tags]                                                    DELETE                 Produtos                       DELETE_Produtos       Deletar_Produto_Nao Administrador
    Cadastrar Novo Produto
    Logar E Salvar Token Como                                 "Nao Administrador"    
    Pegar Quantidade de "Produtos"
    Custom On Session                                         DELETE                 Produtos/${produto['_id']}"    headers=${headers}
    Validar Status Code "403"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Produtos E == ${quantidade}

CT66: Tentar Deletar Produto Que Faz Parte De Um Carrinho
    [Tags]                                                                          DELETE    Produtos                                            DELETE_Produtos       Deletar_Produto_Que_Faz_Parte_De_Um_Carrinho
    Cadastrar Novo Carrinho
    Pegar Quantidade de "Produtos"
    Custom On Session                                                               DELETE    Produtos/${carrinho['produtos'][0]['idProduto']}    headers=${headers}
    Validar Status Code "400"
    Validar Mensagem "Não é permitido excluir produto que faz parte de carrinho"
    Validar Estrutura Da Resposta "message_idcarrinhos"
    Validar Se A Quantidade De Produtos E == ${quantidade}