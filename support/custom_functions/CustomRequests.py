import concurrent.futures
import RequestsLibrary
from requests import Response
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn



class CustomRequests:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.requestslibrary = RequestsLibrary.RequestsOnSessionKeywords()
        self.alias = None
        

    def _set_robot_variables(self, response: Response) -> None:
        """ Seta as variáveis do robot com base na resposta da requisição

        Args:
            response (Response): Resposta da requisição
        """        
        BuiltIn().set_test_variable("${response_time}", response.elapsed.total_seconds())
        BuiltIn().set_test_variable("${response}", response)
        BuiltIn().set_test_variable("${response_body}", response.json())

    @keyword(name="Custom Create Session")
    def custom_session(self, alias:str , base_uri: str, verify: bool = True, **kwargs: dict)-> None:
        """ Cria uma sessão customizada

        Args:
            alias (str): Apelido da sessão
            base_uri (str): Base URI da sessão
            verify (bool, optional): Define se o certificado SSL deve ser verificado. (default: True)
        """
        self.requestslibrary.create_session("serverest", base_uri, verify=True, **kwargs)
        self.alias = alias

    @keyword(name="Custom On Session")
    def custom_request(self, method:str , endpoint: str, expected_status: str ='any', **kwargs: dict) -> None:
        """ Função personalizada para fazer requisições
        Args:
            method (str): Método a ser chamado(GET, POST, PUT, DELETE)
            endpoint (str): Endpoint para chamar o método
            expected_status (str, (optional)): Status esperado do request (default: 'any')
        """   

        #Create String used to call the RequestLibrary function

        if kwargs.__contains__('json')  and  kwargs['json'].__contains__('_id') :
            kwargs['json'].__delitem__('_id')

        call_method =  "self.requestslibrary."+method.lower()+"_on_session(self.alias, endpoint, expected_status=expected_status, **kwargs)"
        response = eval(call_method)
        self._set_robot_variables(response)


    @keyword(name="Custom Theard Request")
    def custon_theard_request(self, method: str, endpoint: str, data:list = None ,expected_status: str ='any', new_user: bool = False, **kwargs: dict) -> None:  
        """ Função Customizada para fazer requisições em threads

        Args:
            method (str): Método a ser chamado(GET, POST, PUT, DELETE)
            endpoint (str): Endpoint para chamar o método
            data (list, optional): Lista de dados para o request
            expected_status (str, (optional)): Status esperado do request (default: 'any')
            new_user (bool, optional): Criar um novo usuário para cada requisição (default: False)
        """    
        #threaded_start = time.time()       

        with concurrent.futures.ThreadPoolExecutor(200) as executor:
            for itens in data:
                
                if  new_user:
                    BuiltIn().run_keyword("Logar E Salvar Token Como","Nao Administrador")
                    headers = BuiltIn().get_variable_value('$headers')
                    kwargs.update({"headers": headers})
                if kwargs.__contains__('headers'):
                    kwargs['headers'].update({"monitor": "false"})
                   
                
                executor.submit(self.custom_request(method, endpoint, json= itens, **kwargs))
        #logger.console("\nForam Cradastrados: {} {}".format(len(data),endpoint))
        #logger.console("\nTempo de execução: {}".format(time.time() - threaded_start))

        
           
