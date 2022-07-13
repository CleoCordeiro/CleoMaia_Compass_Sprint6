from typing import Union
from mimesis.locales import Locale
from mimesis.schema import Field, Schema
from mimesis.providers.person import *
from robot.api.deco import keyword
from robot.api.logger import console
from robot.libraries.BuiltIn import BuiltIn


class Dynamics:
    """ Geração de massa de dados para uso nos testes da API ServeRest.
    
        Gera dados de: Usuários, Produtos e Carrinhos.

        Cada método retorna uma lista de dicionários ou um dicionário.
    """
    @keyword(name="Criar Dados Usuario Do Tipo")
    def criar_usuario(self, administrador: str = "false", quantidade: int = 1)-> Union[list, dict]:
        """Cria um ou mais usuários do tipo especificado

        Args:
            administrador (str, optional): Define se o usuario será administrador ou nao (default: "false").
            quantidade (int, optional): Define a quantidade de usuários a serem criados (default: 1).

        Returns:  Lista de usuários criados ou um dicionário com o usuário criado
            
        """
        if administrador == '"Administrador"' or administrador == "Administrador":
            administrador = "true"
        elif administrador == '"Nao Administrador"' or administrador == "Nao Administrador":
            administrador = "false"
        _ = Field(locale=Locale.PT_BR)
        schema = Schema(schema=lambda: {
            "nome": _("full_name"),
            "email": _("email"),
            "password": _("password", length = 8),
            "administrador": administrador,
            })
        if quantidade == 1:
            return schema.create(iterations=quantidade)[0]
        else:
            return schema.create(iterations=quantidade)
  

    @keyword(name="Criar Dados Produto")
    def produtos(self, quantidade: int = 1)-> Union[list, dict]:
        """Cria um ou mais produtos

        Args:
            quantidade (int, optional): Define a quantidade de produtos a serem criados (default: 1).

        Returns:
            Returns: Lista de produtos criados ou um dicionário com o produto criado
        """        
        _ = Field(locale=Locale.PT_BR)
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


    def _criar_lista_produtos_para_carrinho(self, quantidade_produtos: int) -> list:
        """Cria uma lista de produtos para o carrinho

        Args:
            quantidade_produtos (int): Define a quantidade de produtos contidos no carrinho.

        Returns:
            list: Lista de produtos
        """              
        _ = Field(locale=Locale.PT_BR)
        produtos = BuiltIn().run_keyword("Lista De Todos Produtos")
        
        
        lista_id_quantidade = Schema(schema=lambda: {
        "idProduto": produtos['produtos'].pop()['_id'],
        "quantidade": _("integer_number", start=1, end=3)
        })
        return lista_id_quantidade.create(iterations=quantidade_produtos)


    @keyword(name="Criar Dados Carrinho")
    def criar_carrinho_valido(self, quantidade: int = 1)-> Union[list, dict]:
        """ Cria um ou mais carrinhos válidos

        Args:
            quantidade (int, optional): Define a quantidade de carrinhos a serem criados (default: 1).

        Returns: Lista de carrinhos criados ou um dicionário com o carrinho criado
        """ 
        _ = Field(locale=Locale.PT_BR)
        quantidade_aleatoria = _("integer_number", start=1, end=10)
        carrinho = Schema(schema=lambda: {
            "produtos": self._criar_lista_produtos_para_carrinho(quantidade_aleatoria)
            })

        if quantidade == 1:
            return carrinho.create(iterations=quantidade)[0]
        else:
            return carrinho.create(iterations=quantidade)


    @keyword(name="Gerar Dado Randomico")
    def gerar_dado_randomico(self, dado, **kwargs: int):
        """ Gera e retorna um dado randomico.

        Args:
            dado (_type_): Define o tipo do dado a ser gerado.

        kwargs: Parâmetros opcionais para o dado a ser gerado.
        
        Returns:
            _type_: Retorna o dado gerado.
        """        
        return eval(f" Person().{dado}(**kwargs)")