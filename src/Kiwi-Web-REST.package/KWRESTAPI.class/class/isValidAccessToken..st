private - testing
isValidAccessToken: token
	"Return true if the given token is a valid access token"
	
	^token = self validToken
	