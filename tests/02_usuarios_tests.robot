#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo De Testes Relacionandos Ao EndPoint Usuarios
Resource         ../keywords/usuarios_keywords.resource
Suite Setup      Criar Sessao


*** Test Cases ***
######################
#    GET USUÁRIOS    #
######################
CT09: Listar Todos Os Usuarios Cadastrados
    [Tags]                                         GET                    Usuarios    GET_Usuarios    Buscar_Todos_Usuarios
    Cadastrar Novo Usuario                         "Nao Administrador"
    Custom On Session                              GET                    Usuarios
    Validar Status Code "200"
    Validar Estrutura Da Resposta "usuario_get"
    Validar Se A Quantidade De Usuarios E > 0


CT10: Buscar Usuario Por ID Valido Nao Administrador
    [Tags]                                            GET                    Usuarios                      GET_Usuarios    Buscar_usuario_Nao_Administrador
    Cadastrar Novo Usuario                            "Nao Administrador"
    Custom On Session                                 GET                    Usuarios/${usuario['_id']}
    Validar Status Code "200"
    Validar Estrutura Da Resposta "usuario_get_id"
    Validar Usuario "${usuario['_id']}"


CT11: Buscar Usuario Por ID Valido Administrador
    [Tags]                                            GET                Usuarios                      GET_Usuarios    Buscar_usuario_Administrador
    Cadastrar Novo Usuario                            "Administrador"
    Custom On Session                                 GET                Usuarios/${usuario['_id']}
    Validar Status Code "200"
    Validar Estrutura Da Resposta "usuario_get_id"
    Validar Usuario "${usuario['_id']}"


CT12: Buscar Usuario Por Id Invalido
    [Tags]                                       GET                  Usuarios                           GET_Usuarios           Buscar_Usuario_Invalido
    ${usuario}                                   Pegar Key Do Json    usuarios.json                      usuario_id_invalido
    Custom On Session                            GET                  Usuarios/${usuario_id_invalido}
    Validar Status Code "400"
    Validar Mensagem "Usuário não encontrado"
    Validar Estrutura Da Resposta "message"

#######################
#    POST USUÁRIOS    #
#######################
CT13: Cadastrar Um Usuario Administrador Com Sucesso
    [Tags]                                                   POST               Usuarios    POST_Usuarios      Cadastrar_Usuario_Administrador
    Pegar quantidade de "Usuarios"
    Criar Dados Usuario Valido Do Tipo                       "Administrador"
    Custom On Session                                        POST               Usuarios    json=${usuario}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Usuarios E > ${quantidade}


CT14: Cadastrar Um Usuario Nao Administrador Com Sucesso
    [Tags]                                                   POST                   Usuarios    POST_Usuarios      Cadastrar_Usuario
    Pegar quantidade de "usuarios"
    Criar Dados Usuario Valido Do Tipo                       "Nao Administrador"
    Custom On Session                                        POST                   Usuarios    json=${usuario}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Estrutura Da Resposta "message_id"
    Validar Se A Quantidade De Usuarios E > ${quantidade}


CT15: Cadastrar Usuario Nome Com Acentos
    [Tags]                                                                    POST                   Usuarios    POST_Usuarios      Cadastrar_Usuario_Com_Acentos
    Criar Dados Usuario Nome Com Acentos                                      "Nao Administrador"
    Custom On Session                                                         POST                   Usuarios    json=${usuario}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Estrutura Da Resposta "message_id"
    Validar Nome do Usuario "${response_body['_id']}" "${usuario['nome']}"


CT16: Cadastrar 200 Usuarios
    [Tags]                                                                              POST                   Usuarios                     POST_Usuarios                Teste_Carga_Usuarios
    Pegar Quantidade de "Usuarios"
    Criar Lista de Usuarios                                                             "Nao Administrador"    ${teste_de_carga_usuario}
    Custom Theard Request                                                               POST                   Usuarios                     data=${lista_de_usuarios}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Estrutura Da Resposta "message_id"
    Validar Se A Key Nao Esta Vazia "_id"
    Validar Se A Quantidade De Usuarios E == ${quantidade+${teste_de_carga_usuario}}
    Validar Tempo De Resposta ${teste_de_carga_usuario}


CT17: Tentativa de Cadastrar Um Usuario Com Email Ja Cadastrado
    [Tags]                                                    POST               Usuarios    POST_Usuarios      Cadastrar_Usuario_Email_Ja_Utilizado
    Cadastrar Novo Usuario                                    "Administrador"
    Pegar quantidade de "usuarios"
    Custom On Session                                         POST               Usuarios    json=${usuario}
    Validar Status Code "400"
    Validar Mensagem "Este email já está sendo usado"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Usuarios E == ${quantidade}



CT18: Tentativa de Cadastrar Um Usuario Sem Nome
    [Tags]                                                    POST             Usuarios            POST_Usuarios               Cadastrar_Usuario_Sem_Nome
    Pegar Key Do Json                                         usuarios.json    usuario_sem_nome
    Pegar quantidade de "usuarios"
    Custom On Session                                         POST             Usuarios            json=${usuario_sem_nome}
    Validar Status Code "400"
    Validar Mensagem "Este email já está sendo usado"
    Validar Estrutura Da Resposta "message"
    #Validar "nome" Com O Valor "nome é obrigatório"
    Validar Se A Quantidade De Usuarios E == ${quantidade}


CT19: Tentativa de Cadastrar Um Usuario Sem Email
    [Tags]                                                    POST             Usuarios             POST_Usuarios                Cadastrar_Usuario_Sem_Email
    Pegar Key Do Json                                         usuarios.json    usuario_sem_email
    Pegar quantidade de "usuarios"
    Custom On Session                                         POST             Usuarios             json=${usuario_sem_email}
    Validar Status Code "400"
    Validar Mensagem "Este email já está sendo usado"
    Validar Estrutura Da Resposta "message"
    #Validar "email" Com O Valor "email é obrigatório"
    Validar Se A Quantidade De Usuarios E == ${quantidade}


CT20: Tentativa de Cadastrar Um Usuario Sem Senha
    [Tags]                                                    POST             Usuarios             POST_Usuarios                Cadastrar_Usuario_Sem_Senha
    Pegar Key Do Json                                         usuarios.json    usuario_sem_senha
    Pegar quantidade de "usuarios"
    Custom On Session                                         POST             Usuarios             json=${usuario_sem_senha}
    Validar Status Code "400"
    Validar Mensagem "Este email já está sendo usado"
    Validar Estrutura Da Resposta "message"
    #Validar "password" Com O Valor "password é obrigatório"
    Validar Se A Quantidade De Usuarios E == ${quantidade}


CT21: Tentativa de Cadastrar Um Usuario Sem Administrador
    [Tags]                                                    POST             Usuarios                     POST_Usuarios                        Cadastrar_Usuario_Sem_Administrador
    Pegar Key Do Json                                         usuarios.json    usuario_sem_administrador
    Pegar quantidade de "usuarios"
    Custom On Session                                         POST             Usuarios                     json=${usuario_sem_administrador}
    Validar Status Code "400"
    Validar Mensagem "Este email já está sendo usado"
    Validar Estrutura Da Resposta "message"
    #Validar "administrador" Com O Valor "administrador é obrigatório"
    Validar Se A Quantidade De Usuarios E == ${quantidade}



######################
#    PUT USUÁRIOS    #
######################
CT22: Atualizar Dados de Um Usuario Nao Cadastrado
    [Tags]                                               PUT                    Usuarios              PUT_Usuarios       Atualizar_Dados_Usuario_Nao_Cadastrado
    Criar Dados Usuario Valido Do Tipo                   "Nao Administrador"
    Custom On Session                                    PUT                    Usuarios/NaoExisto    json=${usuario}
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Estrutura Da Resposta "message_id"


CT23: Atualizar Nome Do Usuario
    [Tags]                                              PUT                    Usuarios                      PUT_Usuarios       Atualizar_Nome_Usuario
    Cadastrar Novo Usuario                              "Nao Administrador"
    Alterar Nome Do Usuario
    Custom On Session                                   PUT                    Usuarios/${usuario['_id']}    json=${usuario}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"


CT24: Atualizar Email Do Usuario
    [Tags]                                              PUT                    Usuarios                      PUT_Usuarios       Atualizar_Email_Usuario
    Cadastrar Novo Usuario                              "Nao Administrador"
    Alterar Email Do Usuario
    Custom On Session                                   PUT                    Usuarios/${usuario['_id']}    json=${usuario}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"


CT25: Atualizar Senha Do Usuario
    [Tags]                                              PUT                    Usuarios                      PUT_Usuarios       Atualizar_Senha_Usuario
    Cadastrar Novo Usuario                              "Nao Administrador"
    Alterar Senha Do Usuario
    Custom On Session                                   PUT                    Usuarios/${usuario['_id']}    json=${usuario}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"


CT26: Atualizar Privilegio Do Usuario
    [Tags]                                              PUT                    Usuarios                      PUT_Usuarios       Atualizar_Privelio_Usuario
    Cadastrar Novo Usuario                              "Nao Administrador"
    Alternar Tipo Do Usuario 
    Custom On Session                                   PUT                    Usuarios/${usuario['_id']}    json=${usuario}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"


CT27: Atualizar Nenhum Dado do Usuario
    [Tags]                                              PUT                    Usuarios                      PUT_Usuarios       Atualizar_Nenhum_Dado_Usuario
    Cadastrar Novo Usuario                              "Nao Administrador"
    Custom On Session                                   PUT                    Usuarios/${usuario['_id']}    json=${usuario}
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"
    Validar Estrutura Da Resposta "message"


CT28: Tentar Atualizar Usuario Existente Passando ID Invalido
    [Tags]                                               PUT                    Usuarios              PUT_Usuarios       Tentar_Atualizar_Usuario_Existente_Passando_ID_Invalido
    Cadastrar Novo Usuario                               "Nao Administrador"
    Custom On Session                                    PUT                    Usuarios/NaoExisto    json=${usuario}
    Validar Status Code "400"
    Validar Mensagem "Este email já está sendo usado"
    Validar Estrutura Da Resposta "message"



##########################
#    DELETE USUÁRIOS    #
#########################
CT29: Deletar Usuario Cadastrado Administrador
    [Tags]                                                   DELETE             Usuarios                      DELETE_Usuarios    Deletar_Usuario_Administrador
    Cadastrar Novo Usuario                                   "Administrador"
    Pegar quantidade de "usuarios"
    Custom On Session                                        DELETE             Usuarios/${usuario['_id']}
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se O Usuario Foi Removido "${usuario['_id']}"
    Validar Se A Quantidade De Usuarios E < ${quantidade}


CT30: Deletar Usuario Cadastrado Nao Administrador
    [Tags]                                                   DELETE                 Usuarios                      DELETE_Usuarios    Deletar_Usuario_Nao_Administrador
    Cadastrar Novo Usuario                                   "Nao Administrador"
    Pegar quantidade de "usuarios"
    Custom On Session                                        DELETE                 Usuarios/${usuario['_id']}
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"
    Validar Estrutura Da Resposta "message"
    Validar Se O Usuario Foi Removido "${usuario['_id']}"
    Validar Se A Quantidade De Usuarios E < ${quantidade}


CT31: Tentar Deletar Usuario Nao Cadastrado
    [Tags]                                                    DELETE    Usuarios                              DELETE_Usuarios    Deletar_Usuario_Nao_Cadastrado
    Pegar quantidade de "usuarios"
    Custom On Session                                         DELETE    Usuarios/${usuario_nao_cadastrado}
    Validar Status Code "200"
    Validar Mensagem "Nenhum registro excluído"
    Validar Estrutura Da Resposta "message"
    Validar Se A Quantidade De Usuarios E == ${quantidade}


CT32: Tentar Deletar Usuario Com Carrinho
    [Tags]                                                                        DELETE    Usuarios                      DELETE_Usuarios    Deletar_Usuario_Com_Carrinho
    Cadastrar Novo Carrinho                                                       
    Pegar quantidade de "usuarios"
    Custom On Session                                                             DELETE    Usuarios/${usuario['_id']}
    Validar Status Code "400"
    Validar Mensagem "Não é permitido excluir usuário com carrinho cadastrado"
    Validar Estrutura Da Resposta "message_idcarrinho"
    Validar "idCarrinho" Com O Valor "${carrinho['_id']}"
    Validar Se A Quantidade De Usuarios E == ${quantidade}
