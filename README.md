# Rails Messaging Service
Api service to serve messaging feature

## ERD
![image](https://user-images.githubusercontent.com/9213955/147844350-6cadb576-86dd-4610-b289-c4b772211f52.png)

## Feature
- User can send message to another user
- Users can list all messages in a conversation between them and another user.
- Users can reply to a conversation they are involved with.
- User can list all their conversations (if user A has been chatting with user C & D, the list for A will shows A-C & A-D)
- Each conversation is accompanied by unread count.
- Each conversation is accompanied by its last message

## Postman
[![Run in Postman](https://run.pstmn.io/button.svg)](https://god.postman.co/run-collection/3de17b18d15309df5b61?action=collection%2Fimport)


### install bundle
```md
bundle install
```
### Migration
```md
rails db:migrate
```
### Testing
```md
rspec
```
### Run this app
```md
rails s
```


