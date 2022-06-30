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
    [Tags]                                                 POST                      Login              Login_Administrador
    ${usuario_valido} =                                    Cadastrar Novo Usuario    "Administrador"
    Remove From Dictionary                                 ${usuario_valido}         nome               administrador          _id
    POST Endpoint "/login" Com Body "${usuario_valido}"
    Validar Status Code "200"
    Validar Mensagem "Login realizado com sucesso"
    Validar Token

Cenario: Realizar Login Com Sucesso Usuario Nao Administrador
    [Tags]                                                 POST                      Login                  Login_Nao_Administrador
    ${usuario_valido} =                                    Cadastrar Novo Usuario    "Nao Administrador"
    Remove From Dictionary                                 ${usuario_valido}         nome                   administrador              _id
    POST Endpoint "/login" Com Body "${usuario_valido}"
    Validar Status Code "200"
    Validar Mensagem "Login realizado com sucesso"
    Validar Token

Cenario: Tentativa De Login Com Usuario Invalido
    [Tags]                                                   POST                                  Login              Login_Usuario_Invalido
    ${usuario_invalido} =                                    Criar Dados Usuario Valido Do Tipo    "Administrador"
    Remove From Dictionary                                   ${usuario_invalido}                   nome               administrador             _id
    POST Endpoint "/login" Com Body "${usuario_invalido}"
    Validar Status Code "401"
    Validar Mensagem "Email e/ou senha inválidos"

Cenario: Tentativa De Login Sem Email
    [Tags]                                                 POST                                  Login              POST_Login       Login_Usuario_Email
    ${usuario_valido} =                                    Criar Dados Usuario Valido Do Tipo    "Administrador"
    Remove From Dictionary                                 ${usuario_valido}                     nome               administrador    _id                    email
    POST Endpoint "/login" Com Body "${usuario_valido}"
    Validar Status Code "400"
    Validar "email" Com O Valor "email é obrigatório"

Cenario: Tentativa De Login Sem Senha
    [Tags]                                                     POST                                  Login              POST_Login       Login_Usuario_Senha
    ${usuario_valido} =                                        Criar Dados Usuario Valido Do Tipo    "Administrador"
    Remove From Dictionary                                     ${usuario_valido}                     nome               administrador    _id                    password
    POST Endpoint "/login" Com Body "${usuario_valido}"
    Validar Status Code "400"
    Validar "password" Com O Valor "password é obrigatório"