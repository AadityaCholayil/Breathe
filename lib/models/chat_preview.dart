import 'package:breathe/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatPreview extends Equatable{
  final String uid;
  final String content;
  final String senderId;
  final String receiverId;
  final MessageType messageType;
  final Timestamp timestamp;
  final bool seen;

  const ChatPreview({
    this.uid = '',
    this.content = '',
    this.senderId = '',
    this.receiverId = '',
    this.messageType = MessageType.special,
    required this.timestamp,
    this.seen = false,
  });

  static ChatPreview empty = ChatPreview(uid: '', timestamp: Timestamp(0, 0));

  ChatPreview.fromJson(Map<String, dynamic> json)
      : this(
    uid: json['uid'],
    content: json['content'],
    senderId: json['senderId'],
    receiverId: json['receiverId'],
    messageType: MessageType.values[json['messageType'] as int],
    timestamp: json['timestamp'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['content'] = content;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['messageType'] = messageType.index;
    data['timestamp'] = timestamp;
    return data;
  }

  ChatPreview copyWith(bool seen){
    return ChatPreview(
      uid: uid,
      content: content,
      senderId: senderId,
      receiverId: receiverId,
      messageType: messageType,
      timestamp: timestamp,
      seen: seen,
    );
  }

  bool get isEmpty => this == ChatPreview.empty;

  bool get isNotEmpty => this != ChatPreview.empty;

  @override
  String toString() {
    return 'ChatPreview($uid, $content, $senderId, $receiverId, $messageType, $seen, $timestamp)';
  }

  @override
  List<Object?> get props => [
    uid,
    content,
    senderId,
    receiverId,
    messageType,
    timestamp,
    seen,
  ];
}