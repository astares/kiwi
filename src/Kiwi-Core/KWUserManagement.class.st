"
The usermanagement 
"
Class {
	#name : #KWUserManagement,
	#superclass : #Object,
	#instVars : [
		'users'
	],
	#classVars : [
		'Default'
	],
	#category : #Kiwi-Core-Model
}

{ #category : #accessing }
KWUserManagement class >> default [

	^Default ifNil: [ Default := self new ]
]

{ #category : #initialize-release }
KWUserManagement class >> reset [
	<script>
	
	Default := nil
]

{ #category : #accessing }
KWUserManagement >> addUser: aUser [
	"Add a new user"
	
	^self users add: aUser
]

{ #category : #testing }
KWUserManagement >> hasUserWithUsername: aUsername [

	^self users anySatisfy: [:el | el username = aUsername ]
]

{ #category : #'private - accessing' }
KWUserManagement >> users [
	"Return the collection of users"
	
	^users ifNil: [ users := OrderedCollection new ]
]
