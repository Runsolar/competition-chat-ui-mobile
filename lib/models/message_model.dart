import 'package:competition_chat_ui_mobile/models/user_model.dart';

class Message {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

// YOU - current user
final User currentUser =
    User(id: 0, name: 'Person', imageUrl: 'assets/images/person.jpg', isBot: false);

// Bot
final User bot = User(id: 1, name: 'CoCo', imageUrl: 'assets/images/bot.png', isBot: true);

// FAVORITE CONTACTS
//List<User> favorites = [sam, steven, olivia, john, greg];

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: bot,
    time: '00:00 PM',
    text: 'Hey, how\'s it going?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '00:00 PM',
    text: 'Nice!',
    isLiked: false,
    unread: true,
  )];