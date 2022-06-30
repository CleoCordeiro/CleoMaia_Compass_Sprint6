#Sessão para configuração, documentação, importação de aquivos e librarys
*** Settings ***
Documentation    Arquivo De Configuração Das Variáveis Da API ServeRest
Library          Collections
Library          FakerLibrary
Library          String                                                    
Library          RequestsLibrary
Library          OperatingSystem
Library          JSONLibrary
Resource         ./common/common.resource
Resource         ./fixtures/dynamics.resource
Resource         ./variables/serverest.resource
Resource         ../keywords/login_keywords.resource
Resource         ../keywords/usuarios_keywords.resource
Resource         ../keywords/produtos_keywords.resource
Resource         ../keywords/carrinhos_keywords.resource