(function () {
    'use strict';

    angular
        .module('app')
        .factory('AuthenticationService', AuthenticationService);

    AuthenticationService.$inject = ['$http', '$cookies', '$rootScope', '$timeout', 'UserService'];
    function AuthenticationService($http, $cookies, $rootScope, $timeout, UserService) {
		///////////////////////////////////////////////////////////
		// SERVICE API 
		///////////////////////////////////////////////////////////
		var service = {};
        
		service.Login = Login;
        service.SetCredentials = SetCredentials;
        service.ClearCredentials = ClearCredentials;
        
		return service;
        
		///////////////////////////////////////////////////////////
		// SERVICE IMPLEMENTATION 
		///////////////////////////////////////////////////////////

        // Login the user
        function Login(username, password, callback) {
            $http.post('/api/v1/authenticate', { username: username, password: password })
                 .then(function successCallback(response) {
					callback(response);					
				}, function errorCallback(response) {
					callback(response);
			}).catch(function (err) { alert(err); });
        }

		// Set the credentials after successful login
        function SetCredentials(username, password, token) {            
            $rootScope.globals = {
                currentUser: {
                    username: username,
                    authdata: token
                }
            };

            // set default auth header for http requests
            $http.defaults.headers.common['x-access-token'] = token;

            // store user details in globals cookie that keeps user logged in for 1 week (or until they logout)
            var cookieExp = new Date();
            cookieExp.setDate(cookieExp.getDate() + 7);
            $cookies.putObject('globals', $rootScope.globals, { expires: cookieExp });
        }

		// Clear credentials
        function ClearCredentials() {
            $rootScope.globals = {};
            $cookies.remove('globals');
            $http.defaults.headers.common['x-access-token'] = '';
        }
    }

    

})();