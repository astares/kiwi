"
A user
"
Class {
	#name : #KWUser,
	#superclass : #Object,
	#instVars : [
		'username',
		'firstName',
		'lastName',
		'hashedPassword'
	],
	#category : #Kiwi-Core-Model
}

{ #category : #accessing }
KWUser class >> named: aName [

	^(self new)
		username: aName;
		yourself
]

{ #category : #accessing }
KWUser >> firstName [
	^ firstName
]

{ #category : #accessing }
KWUser >> firstName: anObject [
	firstName := anObject
]

{ #category : #accessing }
KWUser >> hashedPassword [
	^ hashedPassword
]

{ #category : #accessing }
KWUser >> hashedPassword: anObject [
	hashedPassword := anObject
]

{ #category : #accessing }
KWUser >> lastName [
	^ lastName
]

{ #category : #accessing }
KWUser >> lastName: anObject [
	lastName := anObject
]

{ #category : #printing }
KWUser >> printOn: aStream [
	self username ifNil: [ ^super printOn: aStream ].
	aStream << self username 
]

{ #category : #accessing }
KWUser >> username [
	^ username
]

{ #category : #accessing }
KWUser >> username: anObject [
	username := anObject
]
