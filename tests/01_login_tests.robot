#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo De Testes Relacionandos Ao EndPoint Login
Resource         ../keywords/login_keywords.resource
Suite Setup      Criar Sessao


*** Test Cases ***
###################
#    GET LOGIN    #
###################
Cenario: Realizar Login Com Sucesso Administrador
    [Tags]                                            POST               Login    Login_Administrador
    Cadastrar Novo Usuario                            "Administrador"
    Pegar Dados Para Login "${usuario}"
    POST Endpoint "/login" Com Body "${usuario}"
    Validar Status Code "200"
    Validar Mensagem "Login realizado com sucesso"
    Validar Token

Cenario: Realizar Login Com Sucesso Usuario Nao Administrador
    [Tags]                                            POST                   Login    Login_Nao_Administrador
    Cadastrar Novo Usuario                            "Nao Administrador"
    Pegar Dados Para Login "${usuario}"
    POST Endpoint "/login" Com Body "${usuario}"
    Validar Status Code "200"
    Validar Mensagem "Login realizado com sucesso"
    Validar Token

Cenario: Tentativa De Login Com Usuario Nao Cadastrado
    [Tags]                                                         POST             Login                     Login_Usuario_Nao_Cadastrado
    Pegar Key Do Json                                              usuarios.json    usuario_nao_cadastrado    
    Pegar Dados Para Login "${usuario_nao_cadastrado}"
    POST Endpoint "/login" Com Body "${usuario_nao_cadastrado}"
    Validar Status Code "401"
    Validar Mensagem "Email e/ou senha inválidos"

Cenario: Tentativa De Login Com Senha Invalida
    [Tags]                                           POST               Login    Login_Senha_Invalida
    Cadastrar Novo Usuario                           "Administrador"
    Pegar Dados Para Login "${usuario}"
    Alterar Senha Do Usuario
    POST Endpoint "/login" Com Body "${usuario}"
    Validar Status Code "401"
    Validar Mensagem "Email e/ou senha inválidos"

Cenario: Tentativa De Login Sem Email
    [Tags]                                                    POST             Login                POST_Login    Login_Usuario_Email
    Pegar Key Do Json                                         usuarios.json    usuario_sem_email
    Pegar Dados Para Login "${usuario_sem_email}"
    POST Endpoint "/login" Com Body "${usuario_sem_email}"
    Validar Status Code "400"
    Validar "email" Com O Valor "email é obrigatório"

Cenario: Tentativa De Login Sem Senha
    [Tags]                                                     POST             Login                POST_Login    Login_Usuario_Senha
    Pegar Key Do Json                                          usuarios.json    usuario_sem_senha
    Pegar Dados Para Login "${usuario_sem_senha}"
    POST Endpoint "/login" Com Body "${usuario_sem_senha}"
    Validar Status Code "400"
    Validar "password" Com O Valor "password é obrigatório"

Cenario: Testes
    [Tags]     Testes
    Pegar Key Do Json           acentos.json        acentos
    Log to Console             ${acentos}