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
    [Tags]                                GET                    Usuarios    GET_Usuarios    Buscar_Todos_Usuarios
    Cadastrar Novo Usuario                "Nao Administrador"
    Get Endpoint "/usuarios"
    Validar Status Code "200"
    Validar Quantidade De Usuarios > 0

Cenario: Buscar Usuario Por ID Valido Nao Administrador
    [Tags]                                               GET                    Usuarios    GET_Usuarios    Buscar_Usuario_Valido_Nao_Administrador
    Cadastrar Novo Usuario                               "Nao Administrador"
    GET Endpoint "/usuarios/${usuario_valido['_id']}"
    Validar Status Code "200"
    Validar Usuario "${usuario_valido['_id']}"

Cenario: Buscar Usuario Por ID Valido Administrador
    [Tags]                                               GET                Usuarios    GET_Usuarios    Buscar_Usuario_Valido_Administrador
    Cadastrar Novo Usuario                               "Administrador"
    GET Endpoint "/usuarios/${usuario_valido['_id']}"
    Validar Status Code "200"
    Validar Usuario "${usuario_valido['_id']}"

Cenario: Buscar Usuario Por Id Invalido
    [Tags]                                       GET                  Usuarios         GET_Usuarios           Buscar_Usuario_Invalido
    ${usuario}                                   Pegar Key Do Json    usuarios.json    usuario_id_invalido
    GET Endpoint "/usuarios/${usuario}"
    Validar Status Code "400"
    Validar Mensagem "Usuário não encontrado"


#######################
#    POST USUÁRIOS    #
#######################
Cenario: Cadastrar Um Usuario Administrador Com Sucesso
    [Tags]                                               POST               Usuarios    POST_Usuarios    Cadastrar_Usuario_Administrador
    Criar Dados Usuario Valido Do Tipo                   "Administrador"
    POST Endpoint "/usuarios" Com Body "${usuario}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"

Cenario: Cadastrar Um Usuario Nao Administrador Com Sucesso
    [Tags]                                               POST                   Usuarios    POST_Usuarios    Cadastrar_Usuario
    Criar Dados Usuario Valido Do Tipo                   "Nao Administrador"
    POST Endpoint "/usuarios" Com Body "${usuario}"
    Validar Status Code "201"
    Validar Mensagem "Cadastro realizado com sucesso"

Cenario: Tentativa de Cadastrar Um Usuario Com Email Ja Cadastrado
    [Tags]                                               POST               Usuarios    POST_Usuarios    Cadastrar_Usuario_Email_Ja_Utilizado
    Cadastrar Novo Usuario                               "Administrador"
    POST Endpoint "/usuarios" Com Body "${usuario}"
    Validar Status Code "400"
    Validar Mensagem "Este email já está sendo usado"


Cenario: Tentativa de Cadastrar Um Usuario Sem Nome
    [Tags]                                                      POST             Usuarios            POST_Usuarios    Cadastrar_Usuario_Sem_Nome
    Pegar Key Do Json                                           usuarios.json    usuario_sem_nome
    POST Endpoint "/usuarios" Com Body "${usuario_sem_nome}"
    Validar Status Code "400"
    Validar "nome" Com O Valor "nome é obrigatório"

Cenario: Tentativa de Cadastrar Um Usuario Sem Email
    [Tags]                                                       POST             Usuarios             POST_Usuarios    Cadastrar_Usuario_Sem_Email
    Pegar Key Do Json                                            usuarios.json    usuario_sem_email
    POST Endpoint "/usuarios" Com Body "${usuario_sem_email}"
    Validar Status Code "400"
    Validar "email" Com O Valor "email é obrigatório"

Cenario: Tentativa de Cadastrar Um Usuario Sem Senha
    [Tags]                                                       POST             Usuarios             POST_Usuarios    Cadastrar_Usuario_Sem_Senha
    Pegar Key Do Json                                            usuarios.json    usuario_sem_senha
    POST Endpoint "/usuarios" Com Body "${usuario_sem_senha}"
    Validar Status Code "400"
    Validar "password" Com O Valor "password é obrigatório"

Cenario: Tentativa de Cadastrar Um Usuario Sem Administrador
    [Tags]                                                               POST             Usuarios                     POST_Usuarios    Cadastrar_Usuario_Sem_Administrador
    Pegar Key Do Json                                                    usuarios.json    usuario_sem_administrador
    POST Endpoint "/usuarios" Com Body "${usuario_sem_administrador}"
    Validar Status Code "400"
    Validar "administrador" Com O Valor "administrador é obrigatório"


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
Cenario: Deletar Usuario Cadastrado
    [Tags]                                                   DELETE                 Usuarios    DELETE_Usuarios    Deletar_Usuario_Cadastrado
    Cadastrar Novo Usuario                                   "Nao Administrador"
    DELETE Endpoint "/usuarios/${usuario['_id']}"
    Validar Status Code "200"
    Validar Mensagem "Registro excluído com sucesso"
    Validar Se O Usuario Foi Removido "${usuario['_id']}"


Cenario: Deletar Usuario Nao Cadastrado
    [Tags]                                                   DELETE    Usuarios    DELETE_Usuarios    Deletar_Usuario_Nao_Cadastrado
    DELETE Endpoint "/usuarios/${usuario_nao_cadastrado}"
    Validar Status Code "200"
    Validar Mensagem "Nenhum registro excluído"