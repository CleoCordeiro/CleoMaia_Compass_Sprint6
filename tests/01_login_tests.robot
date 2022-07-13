#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo De Testes Relacionandos Ao EndPoint Login
Resource         ../keywords/login_keywords.resource
Suite Setup      Criar Sessao

*** Test Cases ***
###################
#    GET LOGIN    #
###################
CT01: Realizar Login Com Sucesso Administrador
    [Tags]                                             POST               Login    Login_Administrador
    Cadastrar Novo Usuario                             "Administrador"
    Pegar Dados Para Login "${usuario}"
    Custom On Session                                  POST               Login    json=${dados_login}
    Validar Status Code "200"
    Validar Mensagem "Login realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "authorization"
    Validar Estrutura Da Resposta "login_get"


CT02: Realizar Login Com Sucesso Usuario Nao Administrador
    [Tags]                                             POST                   Login    Login_Nao_Administrador
    Cadastrar Novo Usuario                             "Nao Administrador"
    Pegar Dados Para Login "${usuario}"
    Custom On Session                                  POST                   Login    json=${dados_login}
    Validar Status Code "200"
    Validar Mensagem "Login realizado com sucesso"
    Validar Se A Key Nao Esta Vazia "authorization"
    Validar Estrutura Da Resposta "login_get"


CT03: Tentativa De Login Com Usuario Nao Cadastrado
    [Tags]                                                POST             Login                     Login_Usuario_Nao_Cadastrado
    Pegar Key Do Json                                     usuarios.json    usuario_nao_cadastrado    
    Pegar Dados Para Login "${usuario_nao_cadastrado}"
    Custom On Session                                     POST             Login                     json=${dados_login}
    Validar Status Code "400"
    Validar Mensagem "Email e/ou senha inválidos"
    Validar Estrutura Da Resposta "message"

CT04: Tentativa De Login Com Senha Invalida
    [Tags]                                           POST               Login    Login_Senha_Invalida
    Cadastrar Novo Usuario                           "Administrador"
    Pegar Dados Para Login "${usuario}"
    Alterar Senha Do Usuario
    Custom On Session                                POST               Login    json=${dados_login}
    Validar Status Code "400"
    Validar Mensagem "Email e/ou senha inválidos"
    Validar Estrutura Da Resposta "message"

CT05: Tentativa De Login Sem Email
    [Tags]                                           POST             Login                POST_Login             Login_Usuario_Email
    Pegar Key Do Json                                usuarios.json    usuario_sem_email
    Pegar Dados Para Login "${usuario_sem_email}"
    Custom On Session                                POST             Login                json=${dados_login}
    Validar Status Code "400"
    Validar Mensagem "Email e/ou senha inválidos"
    #Validar "email" Com O Valor "email é obrigatório"
    Validar Estrutura Da Resposta "message"

CT06: Tentativa De Login Sem Senha
    [Tags]                                           POST             Login                POST_Login             Login_Usuario_Senha
    Pegar Key Do Json                                usuarios.json    usuario_sem_senha
    Pegar Dados Para Login "${usuario_sem_senha}"
    Custom On Session                                POST             Login                json=${dados_login}
    Validar Status Code "400"
    Validar Mensagem "Email e/ou senha inválidos"
    #Validar "password" Com O Valor "password é obrigatório"
    Validar Estrutura Da Resposta "message"

CT07: Tentativa Login Sem Nenhum Sem Email e Sem Senha
    [Tags]                                           POST    Login    POST_Login    Login_Usuario_Email_Senha
    Custom On Session                                POST    Login    
    Validar Status Code "400"
    Validar Mensagem "Email e/ou senha inválidos"
    #Validar "email" Com O Valor "email é obrigatório"
    #Validar "password" Com O Valor "password é obrigatório"
    Validar Estrutura Da Resposta "message"

CT08: Tentativa de Login Com Email Invalido
    [Tags]                                                POST             Login                     POST_Login             Login_Usuario_Email_Invalido
    Pegar Key Do Json                                     usuarios.json    usuario_email_invalido
    Pegar Dados Para Login "${usuario_email_invalido}"
    Custom On Session                                     POST             Login                     json=${dados_login}
    Validar Status Code "400"
    Validar Mensagem "Email e/ou senha inválidos"
    Validar Estrutura Da Resposta "message"
