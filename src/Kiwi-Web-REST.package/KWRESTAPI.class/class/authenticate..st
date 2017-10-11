api
authenticate: aRequest
	<REST_API: 'POST' versions: #('v1') pattern: 'authenticate'>
	
	|user pwd |
	user := aRequest entity at: #user ifAbsent: [ ^ZnResponse badRequest: aRequest ].
	pwd  := aRequest entity at: #password ifAbsent: [ ^ZnResponse badRequest: aRequest ].
	(self authenticate: user with: pwd)
		ifFalse: [ ^self unauthorized ].
	^ZnResponse ok: (ZnEntity text: self validToken).
	
	