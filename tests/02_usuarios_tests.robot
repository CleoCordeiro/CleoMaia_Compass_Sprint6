#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo De Testes Relacionandos Ao EndPoint Usuarios
Resource         ../keywords/usuarios_keywords.resource
Suite Setup      Criar Sessao


*** Test Cases ***
######################
#    GET USUÁRIOS    #
######################
Cenario: Listar Todos Os Usuarios Cadastrados
    [Tags]                                       GET                    Usuarios    GET_Usuarios    Buscar_Todos_Usuarios
    Cadastrar Novo Usuario                       "Nao Administrador"
    Custom On Session                            GET                    Usuarios
    Validar Status Code "200"
    Validar Se A Quantidade De Usuarios E > 0

Cenario: Buscar Usuario Por ID Valido Nao Administrador
    [Tags]                                 GET                    Usuarios                      GET_Usuarios    Buscar_usuario_Nao_Administrador
    Cadastrar Novo Usuario                 "Nao Administrador"
    Custom On Session                      GET                    Usuarios/${usuario['_id']}
    Validar Status Code "200"
    Validar Usuario "${usuario['_id']}"

Cenario: Buscar Usuario Por ID Valido Administrador
    [Tags]                                 GET          Usuarios       GET_Usuarios    Buscar_usuario_Administrador
    Cadastrar Novo Usuario                 "Administrador"
    Custom On Session                      GET                Usuarios/${usuario['_id']}
    #Create Session                         serverest    ${BASE_URI}
    #GET Endpoint "/Usuarios"
    Validar Status Code "200"
    Validar Usuario "${usuario['_id']}"

Cenario: Buscar Usuario Por Id Invalido
    [Tags]                                       GET                  Usuarios                           GET_Usuarios           Buscar_Usuario_Invalido
    ${usuario}                                   Pegar Key Do Json    usuarios.json                      usuario_id_invalido
    Custom On Session                            GET                  Usuarios/${usuario_id_invalido}
    Validar Status Code "400"
    Validar Mensagem "Usuário não encontrado"

#######################
#    POST USUÁRIOS    #
#######################
Cenario: Cadastrar Um Usuario Administrador Com Sucesso
    [Tags]                                                   POST               Usuarios    POST_Usuarios    Cadastrar_Usuario_Administrador
    Pegar quantidade de "usuarios"
    Criar Dados Usuario Valido Do Tipo                       "Administrador"
    POST Endpoint "/usuarios" Com Body "${usuario}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Quantidade De Usuarios E > ${quantidade}

Cenario: Cadastrar Um Usuario Nao Administrador Com Sucesso
    [Tags]                                                   POST                   Usuarios    POST_Usuarios    Cadastrar_Usuario
    Pegar quantidade de "usuarios"
    Criar Dados Usuario Valido Do Tipo                       "Nao Administrador"
    POST Endpoint "/usuarios" Com Body "${usuario}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Se A Quantidade De Usuarios E > ${quantidade}

Cenario: Cadastrar Usuario Nome Com Acentos
    [Tags]                                                                    POST                   Usuarios    POST_Usuarios    Cadastrar_Usuario_Com_Acentos
    Criar Dados Usuario Nome Com Acentos                                      "Nao Administrador"
    POST Endpoint "/usuarios" Com Body "${usuario}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"
    Validar Nome do Usuario "${response_body['_id']}" "${usuario['nome']}"

Cenario: Tentativa de Cadastrar Um Usuario Com Email Ja Cadastrado
    [Tags]                                                    POST               Usuarios    POST_Usuarios    Cadastrar_Usuario_Email_Ja_Utilizado
    Cadastrar Novo Usuario                                    "Administrador"
    Pegar quantidade de "usuarios"
    POST Endpoint "/usuarios" Com Body "${usuario}"
    Validar Status Code "400"
    Validar Mensagem "Este email já está sendo usado"
    Validar Se A Quantidade De Usuarios E == ${quantidade}

Cenario: Tentativa de Cadastrar Um Usuario Sem Nome
    [Tags]                                                      POST             Usuarios            POST_Usuarios    Cadastrar_Usuario_Sem_Nome
    Pegar Key Do Json                                           usuarios.json    usuario_sem_nome
    Pegar quantidade de "usuarios"
    POST Endpoint "/usuarios" Com Body "${usuario_sem_nome}"
    Validar Status Code "400"
    Validar "nome" Com O Valor "nome é obrigatório"
    Validar Se A Quantidade De Usuarios E == ${quantidade}

Cenario: Tentativa de Cadastrar Um Usuario Sem Email
    [Tags]                                                       POST             Usuarios             POST_Usuarios    Cadastrar_Usuario_Sem_Email
    Pegar Key Do Json                                            usuarios.json    usuario_sem_email
    Pegar quantidade de "usuarios"
    POST Endpoint "/usuarios" Com Body "${usuario_sem_email}"
    Validar Status Code "400"
    Validar "email" Com O Valor "email é obrigatório"
    Validar Se A Quantidade De Usuarios E == ${quantidade}

Cenario: Tentativa de Cadastrar Um Usuario Sem Senha
    [Tags]                                                       POST             Usuarios             POST_Usuarios    Cadastrar_Usuario_Sem_Senha
    Pegar Key Do Json                                            usuarios.json    usuario_sem_senha
    Pegar quantidade de "usuarios"
    POST Endpoint "/usuarios" Com Body "${usuario_sem_senha}"
    Validar Status Code "400"
    Validar "password" Com O Valor "password é obrigatório"
    Validar Se A Quantidade De Usuarios E == ${quantidade}

Cenario: Tentativa de Cadastrar Um Usuario Sem Administrador
    [Tags]                                                               POST             Usuarios                     POST_Usuarios    Cadastrar_Usuario_Sem_Administrador
    Pegar Key Do Json                                                    usuarios.json    usuario_sem_administrador
    Pegar quantidade de "usuarios"
    POST Endpoint "/usuarios" Com Body "${usuario_sem_administrador}"
    Validar Status Code "400"
    Validar "administrador" Com O Valor "administrador é obrigatório"
    Validar Se A Quantidade De Usuarios E == ${quantidade}

######################
#    PUT USUÁRIOS    #
######################
Cenerario: Atualizar Dados de Um Usuario Nao Cadastrado
    [Tags]                                                      PUT                    Usuarios    PUT_Usuarios    Atualizar_Dados_Usuario_Nao_Cadastrado
    Criar Dados Usuario Valido Do Tipo                          "Nao Administrador"
    PUT Endpoint "/usuarios/NaoExisto" Com Body "${usuario}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"

Cenario: Atualizar Nome Do Usuario
    [Tags]                                                              PUT                    Usuarios    PUT_Usuarios    Atualizar_Nome_Usuario
    Cadastrar Novo Usuario                                              "Nao Administrador"
    Alterar Nome Do Usuario
    PUT Endpoint "/usuarios/${usuario['_id']}" Com Body "${usuario}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"

Cenario: Atualizar Email Do Usuario
    [Tags]                                                              PUT                    Usuarios    PUT_Usuarios    Atualizar_Email_Usuario
    Cadastrar Novo Usuario                                              "Nao Administrador"
    Alterar Email Do Usuario
    PUT Endpoint "/usuarios/${usuario['_id']}" Com Body "${usuario}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"

Cenario: Atualizar Senha Do Usuario
    [Tags]                                                              PUT                    Usuarios    PUT_Usuarios    Atualizar_Senha_Usuario
    Cadastrar Novo Usuario                                              "Nao Administrador"
    Alterar Senha Do Usuario
    PUT Endpoint "/usuarios/${usuario['_id']}" Com Body "${usuario}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"

Cenario: Atualizar Privelio Do Usuario
    [Tags]                                                              PUT                    Usuarios    PUT_Usuarios    Atualizar_Privelio_Usuario
    Cadastrar Novo Usuario                                              "Nao Administrador"
    Alternar Tipo Do Usuario 
    PUT Endpoint "/usuarios/${usuario['_id']}" Com Body "${usuario}"
    Validar Status Code "200"
    Validar Mensagem "Registro alterado com sucesso"

##########################
#    DELETE USUÁRIOS    #
#########################
Cenario: Deletar Usuario Cadastrado Administrador
    [Tags]                                                   DELETE             Usuarios    DELETE_Usuarios    Deletar_Usuario_Administrador
    Cadastrar Novo Usuario                                   "Administrador"
    Pegar quantidade de "usuarios"
    DELETE Endpoint "/usuarios/${usuario['_id']}"
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"
    Validar Se O Usuario Foi Removido "${usuario['_id']}"
    Validar Se A Quantidade De Usuarios E < ${quantidade}

Cenario: Deletar Usuario Cadastrado Nao Administrador
    [Tags]                                                   DELETE                 Usuarios    DELETE_Usuarios    Deletar_Usuario_Nao_Administrador
    Cadastrar Novo Usuario                                   "Nao Administrador"
    Pegar quantidade de "usuarios"
    DELETE Endpoint "/usuarios/${usuario['_id']}"
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"
    Validar Se O Usuario Foi Removido "${usuario['_id']}"
    Validar Se A Quantidade De Usuarios E < ${quantidade}

Cenario: Tentar Deletar Usuario Nao Cadastrado
    [Tags]                                                    DELETE    Usuarios    DELETE_Usuarios    Deletar_Usuario_Nao_Cadastrado
    Pegar quantidade de "usuarios"
    DELETE Endpoint "/usuarios/${usuario_nao_cadastrado}"
    Validar Status Code "200"
    Validar Mensagem "Nenhum registro excluído"
    Validar Se A Quantidade De Usuarios E == ${quantidade}