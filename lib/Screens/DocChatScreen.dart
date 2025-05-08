import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:digixcare/utils/user_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

class DocChatScreen extends StatefulWidget {
  const DocChatScreen({super.key});

  @override
  State<DocChatScreen> createState() => _DocChatScreenState();
}

class _DocChatScreenState extends State<DocChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _chats = [];
  Map<String, dynamic>? _selectedChat;
  bool _isDoctor = false;
  String? _currentUserId;
  String? _currentUsername;
  bool _isLoading = true;
  File? _pendingImage;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadChats();
    _setupRealtimeSubscription();
  }

  void _setupRealtimeSubscription() {
    _supabase
        .channel('doctor_chats')
        .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'doctor_chats',
      callback: (payload) {
        if (_selectedChat != null) {
          final newData = payload.newRecord;
          if (newData != null && newData['id'] == _selectedChat!['id']) {
            _loadMessages();
          }
        }
      },
    )
        .subscribe();
  }

  Future<void> _loadUserInfo() async {
    try {
      print('=== Loading User Info ===');
      final userId = await UserStorage.getUserId();
      final username = await UserStorage.getUserName();
      final role = await UserStorage.getUserRole();

      print('Retrieved User Info:');
      print('User ID: $userId');
      print('Username: $username');
      print('Role: $role');

      setState(() {
        _currentUserId = userId;
        _currentUsername = username;
        _isDoctor = role == 'doctor';
      });
      print('=== End Loading User Info ===');
    } catch (e) {
      print('ERROR loading user info: $e');
    }
  }

  Future<void> _loadChats() async {
    try {
      print('=== Loading Chats ===');
      setState(() => _isLoading = true);

      if (_isDoctor) {
        print('Loading chats for doctor...');
        print('Current doctor ID: $_currentUserId');

        // Fetch all high severity cases that haven't been responded to by a doctor
        final response = await _supabase
            .from('doctor_chats')
            .select()
            .eq('severity', 'high')
            .order('created_at', ascending: false);

        print('Raw doctor chats response: $response');

        if (response == null) {
          print('ERROR: Null response from Supabase');
          return;
        }

        // Filter to show only chats that need doctor's attention
        final filteredChats = List<Map<String, dynamic>>.from(response)
            .where((chat) => chat['doctor_message'] == null)
            .toList();

        print('Filtered chats for doctor:');
        for (var chat in filteredChats) {
          print('Chat ID: ${chat['id']}');
          print('User ID: ${chat['user_id']}');
          print('User Name: ${chat['user_name']}');
          print('User Message: ${chat['user_message']}');
          print('AI Response: ${chat['ai_response']}');
          print('Doctor Message: ${chat['doctor_message']}');
          print('Severity: ${chat['severity']}');
          print('---');
        }

        setState(() {
          _chats = filteredChats;
          _isLoading = false;
        });
      } else {
        print('Loading chats for user...');
        print('Current user ID: $_currentUserId');

        // Fetch all high severity cases for the current user
        final response = await _supabase
            .from('doctor_chats')
            .select()
            .eq('user_id', _currentUserId ?? '')
            .eq('severity', 'high')
            .order('created_at', ascending: false);

        print('Raw user chats response: $response');

        if (response == null) {
          print('ERROR: Null response from Supabase');
          return;
        }

        print('User chats:');
        for (var chat in response) {
          print('Chat ID: ${chat['id']}');
          print('User ID: ${chat['user_id']}');
          print('User Name: ${chat['user_name']}');
          print('User Message: ${chat['user_message']}');
          print('AI Response: ${chat['ai_response']}');
          print('Doctor Message: ${chat['doctor_message']}');
          print('Severity: ${chat['severity']}');
          print('---');
        }

        setState(() {
          _chats = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('ERROR loading chats: $e');
      setState(() => _isLoading = false);
    }
    print('=== End Loading Chats ===');
  }

  Future<void> _loadMessages() async {
    if (_selectedChat == null) return;

    try {
      print('=== Loading Messages ===');
      final response = await _supabase
          .from('doctor_chats')
          .select()
          .eq('id', _selectedChat!['id'])
          .single();

      if (response != null) {
        setState(() {
          _selectedChat = response;
          _messages = [];

          // Add AI response first if it exists
          if (response['ai_response'] != null) {
            _messages.add({
              'message': response['ai_response'],
              'isDoctor': true,
              'isAI': true,
              'timestamp': response['created_at'],
            });
          }

          // Add user's message if it exists
          if (response['user_message'] != null) {
            _messages.add({
              'message': response['user_message'],
              'isDoctor': false,
              'timestamp': response['updated_at'],
            });
          }

          // Add doctor's response if it exists
          if (response['doctor_message'] != null) {
            _messages.add({
              'message': response['doctor_message'],
              'isDoctor': true,
              'timestamp': response['updated_at'],
            });
          }
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
      print('=== End Loading Messages ===');
    } catch (e) {
      print('ERROR loading messages: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pendingImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _selectedChat == null) return;

    try {
      print('=== Sending Message ===');
      print('Current User ID: $_currentUserId');
      print('Is Doctor: $_isDoctor');
      print('Selected Chat ID: ${_selectedChat!['id']}');
      
      final updateData = _isDoctor
          ? {
              'doctor_id': _currentUserId,
              'doctor_message': _messageController.text.trim(),
              'updated_at': DateTime.now().toIso8601String(),
            }
          : {
              'user_message': _messageController.text.trim(),
              'updated_at': DateTime.now().toIso8601String(),
            };

      print('Update Data: $updateData');

      final response = await _supabase
          .from('doctor_chats')
          .update(updateData)
          .eq('id', _selectedChat!['id'])
          .select();

      print('Update Response: $response');

      if (response != null) {
        print('Message saved successfully');
        setState(() {
          _messageController.clear();
        });
        await _loadMessages();
      } else {
        print('ERROR: Failed to save message');
      }
      print('=== End Sending Message ===');
    } catch (e) {
      print('ERROR sending message: $e');
      if (e is PostgrestException) {
        print('Postgrest Error Details:');
        print('Message: ${e.message}');
        print('Code: ${e.code}');
        print('Details: ${e.details}');
      }
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final timestamp = DateTime.parse(message['timestamp']);
    final isDoctor = message['isDoctor'];
    final isAI = message['isAI'] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: isDoctor ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isAI ? Colors.green[100] : (isDoctor ? Colors.white : Colors.blue),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAI)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'AI Diagnosis',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              if (message['message'] != null && message['message'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    message['message'],
                    style: TextStyle(
                      color: isAI ? Colors.black : (isDoctor ? Colors.black : Colors.white),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 10,
                    color: isAI ? Colors.green[800] : (isDoctor ? Colors.black54 : Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_chats.isEmpty) {
      return Center(
        child: Text(
          _isDoctor
              ? 'No pending cases'
              : 'No high severity cases',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        final isSelected = _selectedChat?['id'] == chat['id'];
        final userMessage = chat['user_message'] as String?;
        final doctorMessage = chat['doctor_message'] as String?;
        final aiResponse = chat['ai_response'] as String?;
        final timestamp = DateTime.parse(chat['created_at']);
        final hasDoctorResponse = doctorMessage != null;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: isSelected ? Colors.blue[50] : null,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    chat['user_name']?[0].toUpperCase() ?? 'U',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(chat['user_name'] ?? 'Unknown User'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Your Message: $userMessage',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    if (aiResponse != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'AI Diagnosis: $aiResponse',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    if (hasDoctorResponse)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Doctor\'s Response: $doctorMessage',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    Text(
                      '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: _isDoctor && !hasDoctorResponse
                    ? const Chip(
                        label: Text('New', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedChat = chat;
                  });
                  _loadMessages();
                },
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (aiResponse != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Diagnosis:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                              Text(aiResponse),
                            ],
                          ),
                        ),
                      if (hasDoctorResponse)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Doctor\'s Response:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              Text(doctorMessage!),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatArea() {
    if (_selectedChat == null) {
      return const Center(
        child: Text(
          'Select a chat to start conversation',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.blue[50],
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  _selectedChat!['user_name']?[0].toUpperCase() ?? 'U',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedChat!['user_name'] ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Case ID: ${_selectedChat!['id']}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_selectedChat!['ai_response'] != null)
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Diagnosis:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_selectedChat!['ai_response']),
                ),
              ],
            ),
          ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
            ),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
        ),
        if (_pendingImage != null)
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _pendingImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _pendingImage = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: _pickImage,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: _isDoctor ? 'Type your response...' : 'Type your message...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isDoctor ? 'Patient Cases' : 'Doctor Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChats,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_isDoctor)
              Expanded(
                child: _selectedChat == null
                    ? _buildChatList()
                    : _buildChatArea(),
              )
            else
              Expanded(child: _buildChatList()),
            if (_isDoctor && _selectedChat != null)
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo),
                      onPressed: _pickImage,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: _isDoctor ? 'Type your response...' : 'Type your message...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
