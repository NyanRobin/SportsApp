import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/services/service_locator.dart';
import '../../../core/services/realtime_service.dart';
import '../../../core/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String roomType; // 'game', 'team', 'general'

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.roomType,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<RealtimeMessage> _messages = [];
  bool _isConnected = false;
  String? _currentUserId;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    final realtimeService = ServiceLocator.getRealtimeService(context);
    
    // 연결 상태 확인
    _isConnected = realtimeService.isConnected;
    _currentUserId = realtimeService.userId;
    
    // 연결되지 않은 경우 초기화
    if (!_isConnected) {
      await realtimeService.initialize();
    }

    // 게임 룸인 경우 게임 룸 참가 (현재 비활성화)
    if (widget.roomType == 'game') {
      // realtimeService.joinGame(widget.roomId); // 임시 비활성화
      print('Game room join requested: ${widget.roomId}');
    }

    // 메시지 스트림 구독
    realtimeService.messageStream.listen((data) {
      final message = RealtimeMessage.fromJson(data);
      if (message.room == widget.roomId) {
        setState(() {
          _messages.add(message);
        });
        _scrollToBottom();
      }
    });

    // 연결 상태 스트림 구독
    realtimeService.connectionStatusStream.listen((connected) {
      setState(() {
        _isConnected = connected;
      });
    });

    // Mock 사용자 이름 설정
    _currentUserName = _getUserName(_currentUserId ?? 'user1');
  }

  String _getUserName(String userId) {
    final userNames = {
      'user1': 'Kim Minseok',
      'user2': 'Park Jisung',
      'coach1': 'Lee Junho',
    };
    return userNames[userId] ?? 'Unknown User';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty || !_isConnected) return;

    // 채팅 기능 임시 비활성화
    print('Message send requested: $message to room ${widget.roomId}');
    
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.roomName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isConnected ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  _isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    color: _isConnected ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (widget.roomType == 'game') {
              // 게임 룸 나가기 기능 임시 비활성화
              print('Game room leave requested: ${widget.roomId}');
            }
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              _showChatOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 메시지 목록
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMyMessage = message.senderId == _currentUserId;
                      
                      return _buildMessageBubble(message, isMyMessage);
                    },
                  ),
          ),
          
          // 메시지 입력
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: _isConnected ? 'Type a message...' : 'Connecting...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: _isConnected ? AppTheme.primaryColor : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _isConnected ? _sendMessage : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(RealtimeMessage message, bool isMyMessage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                message.senderName.isNotEmpty ? message.senderName[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMyMessage ? AppTheme.primaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMyMessage) ...[
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: isMyMessage ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatTime(message.timestamp),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text('Clear Chat'),
              onTap: () {
                Navigator.pop(context);
                _showClearChatDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Mute Notifications'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement mute notifications
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mute notifications coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Chat Info'),
              onTap: () {
                Navigator.pop(context);
                _showChatInfo();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.roomName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room ID: ${widget.roomId}'),
            Text('Type: ${widget.roomType}'),
            Text('Messages: ${_messages.length}'),
            Text('Status: ${_isConnected ? 'Connected' : 'Disconnected'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 