"
A simple REST API

Following https://scotch.io/tutorials/authenticate-a-node-js-api-with-json-web-tokens
"
Class {
	#name : #KWRESTAPI,
	#superclass : #Object,
	#category : 'Kiwi-Web-REST'
}

{ #category : #api }
KWRESTAPI class >> authenticate: aRequest [
	<REST_API: 'POST' versions: #('v1') pattern: 'authenticate'>
	
	|user pwd credentials|
	credentials := STON fromString: aRequest entity.
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

{ #category : #building }
KWRESTAPI class >> homepage [

	^'<h1>Hello</h1>'
]

{ #category : #'private - testing' }
KWRESTAPI class >> isValidAccessToken: token [
	"Return true if the given token is a valid access token"
	
	^token = self validToken
]

{ #category : #building }
KWRESTAPI class >> rebuild [
	<script>
	TLWebserver teapot removeAllDynamicRoutes.
	TLRESTAPIBuilder buildAPI.
	TLWebserver teapot  
		before: '/api/*' -> [ :req | (req uri path = 'api/v1/authenticate') ifFalse: [ (self hasValidAccessToken: req) ifFalse: [ req abort: (self unauthorized) ] ]];
		serveStatic: '/' from: self staticFileDirectory.
	TLWebserver teapot inspect
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
	^ZnResponse unauthorized: 'Basic realm=Kiwi'
]

{ #category : #'private - accessing' }
KWRESTAPI class >> validToken [
	^'TOKEN123'
]
