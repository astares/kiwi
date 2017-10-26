"
A simple REST API

Following https://scotch.io/tutorials/authenticate-a-node-js-api-with-json-web-tokens
"
Class {
	#name : #KWRESTAPI,
	#superclass : #Object,
	#category : #Kiwi-Web-REST
}

{ #category : #'api - authorization' }
KWRESTAPI class >> authenticate: aRequest [
	<REST_API: 'POST' versions: #('v1') pattern: 'authenticate'>
	
	|user pwd credentials|
	[ credentials := STON fromString: aRequest entity ]
		on: Error
		do: [ ^ZnResponse badRequest: aRequest ].	
	user := credentials at: #username ifAbsent: [ ^ZnResponse badRequest: aRequest ].
	pwd  := credentials at: #password ifAbsent: [ ^ZnResponse badRequest: aRequest ].
	(self authenticate: user with: pwd)
		ifFalse: [ ^self unauthorized ].
	^ZnResponse ok: (ZnEntity text: self validToken).
]

{ #category : #private }
KWRESTAPI class >> authenticate: user with: pwd [
	"Authentication hook"
	^user = 'admin' & (pwd = '123')
]

{ #category : #'api - users' }
KWRESTAPI class >> createUser: aRequest [
	<REST_API: 'POST' versions: #('v1') pattern: 'users'>
	
	| userData |
	[ userData := STON fromString: aRequest entity ]
		on: Error
		do: [ ^ZnResponse badRequest: aRequest ].
		
	"Create a user from the user data"	
	userData halt.	
]

{ #category : #api }
KWRESTAPI class >> foo: aRequest [
	<REST_API: 'GET' versions: #('v1') pattern: 'foo'>
	
	^ZnResponse ok: (ZnEntity text: 'foo').
]

{ #category : #'private - testing' }
KWRESTAPI class >> hasValidAccessToken: aRequest [
	"Return true if the request has a valid token, therefore check 'x-access-token' in header."
	|token|
	token := aRequest headers at: 'x-access-token' ifAbsent: [ ^false ].
	^self isValidAccessToken: token.
]

{ #category : #initialization }
KWRESTAPI class >> initialize [

	self rebuild
]

{ #category : #'private - testing' }
KWRESTAPI class >> isValidAccessToken: token [
	"Return true if the given token is a valid access token"
	
	^token = self validToken
]

{ #category : #building }
KWRESTAPI class >> rebuild [
	<script: 'self initialize. TLWebserver teapot inspect'>
	self resetWebserver.
		
	TLRESTAPIBuilder buildAPI.
	
	"Add a filter to the API so it is secured and serve static files from the projects www folder"
	
	TLWebserver teapot  
		before: '/api/*' -> [ :req | 
			(self requestIsAllowedWithoutCredentials: req) 
				ifFalse: [ (self hasValidAccessToken: req) ifFalse: [ req abort: (self unauthorized) ] ]];
		serveStatic: '/' from: self staticFileDirectory.
]

{ #category : #'private - testing' }
KWRESTAPI class >> requestIsAllowedWithoutCredentials: req [
	"We allow authentication as well as registration. All other requests need an access token"
	
	| allowedPaths |
	allowedPaths := #('api/v1/authenticate' 'api/v1/users').
	^(allowedPaths includes: req uri path) and: [ req method = 'POST' ]
]

{ #category : #'private - utilities' }
KWRESTAPI class >> resetWebserver [
	"Reset the webserver by removing all installed routes and filters"
	
	TLWebserver teapot 
		removeAllDynamicRoutes;
		removeAllBeforeFilters;
		removeAllAfterFilters.
]

{ #category : #'private - accessing' }
KWRESTAPI class >> staticFileDirectory [
	|dir|
	dir := (IceRepository shareRepositoriesBetweenImages
		 	ifTrue: [ IceRepository sharedRepositoriesLocationString ]
 			ifFalse: [ IceRepository localRepositoriesLocation ]) asFileReference.
	^(dir / 'astares' / 'Kiwi' / 'www') fullName
]

{ #category : #'private - accessing' }
KWRESTAPI class >> unauthorized [ 
	^(ZnResponse statusLine: ZnStatusLine unauthorized)
			entity: (ZnEntity textCRLF: '{ "succcess" : false, "message" : "You are not authorized to access this service." }')
]

{ #category : #'private - accessing' }
KWRESTAPI class >> validToken [
	^'TOKEN123'
]
