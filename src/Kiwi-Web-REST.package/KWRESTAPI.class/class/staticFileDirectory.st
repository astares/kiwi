private - accessing
staticFileDirectory
	|dir|
	dir := (IceRepository shareRepositoriesBetweenImages
		 	ifTrue: [ IceRepository sharedRepositoriesLocationString ]
 			ifFalse: [ IceRepository localRepositoriesLocation ]) asFileReference.
	^(dir / 'astares' / 'Kiwi' / 'www') fullName