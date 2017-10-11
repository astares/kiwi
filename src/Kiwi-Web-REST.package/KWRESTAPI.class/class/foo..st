api
foo: aRequest
	<REST_API: 'GET' versions: #('v1') pattern: 'foo'>
	
	^ZnResponse ok: (ZnEntity text: 'foo').
	
	