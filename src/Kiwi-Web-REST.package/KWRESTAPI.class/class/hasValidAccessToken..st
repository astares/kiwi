private - testing
hasValidAccessToken: aRequest
	"Return true if the request has a valid token, therefore check 'x-access-token' in header."
	|token|
	token := aRequest headers at: 'x-access-token' ifAbsent: [ ^false ].
	^self isValidAccessToken: token.
	