# Challagen Sprint 6 <img align="center" height="30" width="40" src="https://raw.githubusercontent.com/CleoCordeiro/Asserts/main/Asserts/robot-framework.svg" />
[![Licence](https://img.shields.io/github/license/Ileriayo/markdown-badges?style=for-the-badge)](./LICENSE)


# Testes Automatizados ServeRest API Usando Robot Framework

:shopping_cart: https://serverest.dev/


<img src="https://raw.githubusercontent.com/CleoCordeiro/Asserts/main/Asserts/dacing.gif" alt="">


## Endpoints
- [x] Login
- [x] Usuarios
- [x] Produtos
- [x] Carrinhos

## Instalação

- Instalar o Python
- Instalar as dependências do Robot Framework: `pip install -r requirements.txt`

## Bibliotecas externas utilizadas

- RequestsLibrary
- FakerLibrary
- JSONLibrary

### Obtendo uma cópia:

```shell
$ git clone https://github.com/CleoCordeiro/RoboTron_CleoMaia_Compass.git
```

## Execução dos testes
- Abrir o terminal dentro da pasta realização

Todos os testes
- Executar no terminal: `robot -d .\reports  .\test-cases`

Testes por Tags
- Executar no terminal: `robot -d .\reports -i "Tag" .\test-cases`
Subistitua o "Tag" pelo Tag desejada:
```shell
Principais Tags

    Login           Executa todos os testes relacionados ao Endpoint /Login

    Usuarios        Executa todos os testes relacionados ao Endpoint /Usuarios

    Produtos        Executa todos os testes relacionados ao Endpoint /Produtos

    Carrinhos       Executa todos os testes relacionados ao Endpoint /Carrinhos
```
-  Exemplo `robot -d .\reports -i Login .\test-cases`

- Cada Endpoint possui subtags que podem executar testes individuais

## Resultado dos testes

- Acessar o arquivo *log.html* na pasta *reports*

![alt](https://raw.githubusercontent.com/CleoCordeiro/Asserts/main/Asserts/testes%20log.png)


## Autor
Cléo Maia Cordeiro
</br>

[![Linkedin](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/cleocordeiro/)
[![Facebook](https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/cleo.m.cordeiro/)
[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/cleomaiacordeiro/)
