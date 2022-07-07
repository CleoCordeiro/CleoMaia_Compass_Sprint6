from threading import Thread
from typing import Dict, List, Union
from faker import Faker
from mimesis.enums import Gender
from mimesis.locales import Locale
from mimesis.schema import Field, Schema
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword


_PlainJSON = Union[
    None, bool, int, float, str, List["_PlainJSON"], Dict[str, "_PlainJSON"]
]
JSON = Union[_PlainJSON, Dict[str, "JSON"], List["JSON"]]

class Dynamics:

    # def __init__(self):
    #     self.usuario = self.criar_usuario()

    # @keyword(name="Criar Dados Usuario Valido Do Tipo")
    # def criar_usuario(admin: bool=False)-> JSON:
        
    #     nome = g.name()
    #     email = nome+g.email()
    #     senha = g.password()
    #     administrador = admin
    #     usuario = {
    #         "nome": nome,
    #         "email": email,
    #         "senha": senha,
    #         "administrador": administrador
    #     }

    #     BuiltIn().set_test_variable("${usuario}", usuario)
    #     return usuario
  
    @keyword(name="Criar Dados Produto")
    def produtos(self, quantidade: int = 1)-> JSON:
        _ = Field(locale=Locale.EN)
        schema = Schema(schema=lambda: {
            "nome": _("text.word")+_("text.word"),
            "descricao": _("sentence"),
            "preco": _("integer_number", start=30, end=1000),
            "quantidade": _("integer_number", start=1000, end=9999),
            })
        if quantidade == 1:
            return schema.create(iterations=quantidade)[0]
        else:
            return schema.create(iterations=quantidade)

    

# Criar Dados Carrinho Valido
#     [Documentation]                Gera um carrinho aleatório e retorna um dicionário com os dados do carrinho
#     ${produtos} =                  Lista De Todos Produtos
#     Set Test Variable              ${lista_de_produtos}                                                           ${produtos['produtos']}
#     ${quantidade_de_produtos} =    Get length                                                                     ${lista_de_produtos}
#     ${quantidade_aleatoria}        FakerLibrary.Random Int                                                        min=1                              max=10
#     @{nova_lista_produtos}         Create List
#     ${carrinho}=                   Create Dictionary
#     FOR                            ${i}                                                                           IN RANGE                           ${quantidade_aleatoria}
#     ${quantidade_de_produtos} =    Get length                                                                     ${lista_de_produtos}
#     ${index_produto}               FakerLibrary.Random Int                                                        min=0                              max=${quantidade_de_produtos-1 }
#     ${produto} =                   Remove From List                                                               ${lista_de_produtos}               ${index_produto}
#     IF                             ${produto['quantidade']} < 3                                                   CONTINUE
#     ${quantidade}                  FakerLibrary.Random Int                                                        min=1                              max=3
#     &{novo_produto}                Create Dictionary                                                              idProduto=${produto['_id']}        quantidade=${quantidade}
#     Append To List                 ${nova_lista_produtos}                                                         ${novo_produto}
#     END
#     ${carrinho} =                  Create Dictionary                                                              produtos=${nova_lista_produtos}
#     Set Test Variable              ${carrinho}

def criar_carrinho_valido()-> JSON:
    fake = Faker()
    produtos = BuiltIn().run_keyword("Lista De Todos Produtos")
    quantidade_de_produtos = len(produtos['produtos'])
    quantidade_aleatoria = fake.random_int(min=1, max=10)
    nova_lista_produtos = []

    for i in range(quantidade_aleatoria):
        quantidade_de_produtos = len(produtos['produtos'])
        index_produto = fake.random_int(min=0, max=quantidade_de_produtos-1)
        produto = produtos['produtos'].pop(index_produto)
        if produto['quantidade'] < 3:
            continue
        quantidade = fake.random_int(min=1, max=3)
        novo_produto = {
            "idProduto": produto['_id'],
            "quantidade": quantidade
        }
        nova_lista_produtos.append(novo_produto)

    carrinho = {
        "produtos": nova_lista_produtos
    }

    BuiltIn().set_test_variable("${carrinho}", carrinho)
    return carrinho