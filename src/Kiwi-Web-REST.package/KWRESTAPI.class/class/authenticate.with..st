private
authenticate: user with: pwd
	"Authentication hook"
	^user = 'admin' & (pwd = '123')