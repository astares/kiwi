building
rebuild
	<script>
	TLWebserver teapot removeAllDynamicRoutes.
	TLRESTAPIBuilder buildAPI.
	TLWebserver teapot  
		before: '/api/*' -> [ :req | (req uri path = 'api/v1/authenticate') ifFalse: [ (self hasValidAccessToken: req) ifFalse: [ req abort: (self unauthorized) ] ]];
		serveStatic: '/' from: self staticFileDirectory.
	TLWebserver teapot inspect
	 