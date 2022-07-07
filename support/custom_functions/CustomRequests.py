import concurrent.futures
import time
import RequestsLibrary
from Dynamics import *
from requests import Response
from robot.api.deco import keyword
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn


class CustomRequests:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.requestslibrary = RequestsLibrary.RequestsOnSessionKeywords()
        self.alias = None


    def set_robot_variables(self, response: Response):
        BuiltIn().set_test_variable("${response_time}", response.elapsed.total_seconds())
        BuiltIn().set_test_variable("${response}", response)
        BuiltIn().set_test_variable("${response_body}", response.json())

    @keyword(name="Custom Create Session")
    def custom_session(self, alias:str , base_uri: str, verify: bool = True, **kwargs: Dict)-> None:
        """Create a session with the given alias and base_uri.

        Args:
            alias (str): The alias of the session.
            base_uri (str): The base_uri of the session.
            verify (bool, optional): Whether to verify the SSL certificate. Defaults to True.
        """
        self.requestslibrary.create_session("serverest", base_uri, verify=True, **kwargs)
        self.alias = alias

    @keyword(name="Custom On Session")
    def custom_request(self, method:str , endpoint: str, **kwargs: Dict) -> None:
        """ Custom Request function call RequestLibrary function

        Args:
            method (str): Method to be called(GET, POST, PUT, DELETE)
            endpoint (str): Endpoint to call for the request
            expected_status (str, (optional)): Expected status of the request (default: 'any')

        Returns:
            JSON: Response of the request
        """   

        #Create String used to call the RequestLibrary function
        call_method =  "self.requestslibrary."+method.lower()+"_on_session(self.alias, endpoint, expected_status='any', **kwargs)"
        response = eval(call_method)
        self.set_robot_variables(response)


    @keyword(name="Custom Theard Request")
    def custon_theard_request(self, method:str , endpoint: str, data:list = None ,expected_status='any', **kwargs: Dict) -> None:
        """ Custon Theard Request function call RequestLibrary function in a pool of threads

        Args:
            method (str): Method to be called(GET, POST, PUT, DELETE)
            endpoint (str): Endpoint to call for the request
            expected_status (str, (optional)): Expected status of the request (default: 'any')

        Returns:
            JSON: Response of the request
        """        
        headers = kwargs.pop("headers")
        headers.update({"monitor": "false"})
        kwargs.update({"headers": headers})
        self.requestslibrary.post_on_session
        threaded_start = time.time()
        with concurrent.futures.ThreadPoolExecutor(500) as executor:
            for itens in data:
                executor.submit(self.custom_request(method, endpoint, json= itens, **kwargs))
        logger.console("\nForam Cradastrados: {} Produtos".format(len(data)))
        logger.console("Stop threaded: {}".format(time.time() - threaded_start))
        
           
