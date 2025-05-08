import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:digixcare/utils/user_storage.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _chatMessages = [];
  final ImagePicker _picker = ImagePicker();
  File? _pendingImage;
  bool _showDisclaimer = true;
  final SupabaseClient _supabase = Supabase.instance.client;

  final String backendUrl =
      "http://192.168.69.100:5000/analyze"; // Change to your PC's IP

  Future<void> _saveToSupabase(
      String userMessage, String aiResponse, String severity) async {
    try {
      print('=== Starting _saveToSupabase ===');
      print('User Message: $userMessage');
      print('AI Response: $aiResponse');
      print('Severity: $severity');

      final userId = await UserStorage.getUserId();
      final username = await UserStorage.getUserName();

      print('User Info - ID: $userId, Username: $username');

      if (userId == null || username == null) {
        print('ERROR: Missing user information');
        return;
      }

      // Normalize the severity string
      final normalizedSeverity = severity.trim().toLowerCase();
      print('Normalized Severity: $normalizedSeverity');

      if (normalizedSeverity == 'high') {
        print('=== Saving High Severity Case ===');
        
        final dataToSave = {
          'user_id': userId,
          'user_name': username,
          'user_message': userMessage,
          'ai_response': aiResponse,
          'severity': 'high',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        print('Data to save: $dataToSave');

        try {
          final response = await _supabase
              .from('doctor_chats')
              .insert(dataToSave)
              .select();

          print('Supabase Response: $response');

          if (response != null && response.isNotEmpty) {
            print('Successfully saved to Supabase');
            print('Saved record ID: ${response[0]['id']}');
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('High severity detected. Your case has been forwarded to a doctor.'),
                  duration: Duration(seconds: 5),
                ),
              );
            }
          } else {
            print('ERROR: Empty response from Supabase');
          }
        } catch (e) {
          print('ERROR inserting into Supabase: $e');
          if (e is PostgrestException) {
            print('Postgrest Error Details:');
            print('Message: ${e.message}');
            print('Details: ${e.details}');
            print('Hint: ${e.hint}');
          }
        }
      } else {
        print('Not saving to Supabase - Severity is not high');
      }
    } catch (e) {
      print('ERROR in _saveToSupabase: $e');
    }
    print('=== End _saveToSupabase ===');
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pendingImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text("Take a Photo"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from Gallery"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty && _pendingImage == null) return;

    setState(() {
      _showDisclaimer = false;
    });

    if (_pendingImage != null) {
      if (message.isNotEmpty) {
        _chatMessages.add({"user": message});
      }
      _chatMessages.add({"user_image": _pendingImage!.path});
      _chatMessages.add({"ai": "Analyzing your input..."});
      setState(() {});

      final uri = Uri.parse(backendUrl);
      var request = http.MultipartRequest('POST', uri);
      if (message.isNotEmpty) {
        request.fields['message'] = message;
      }

      var mimeType = lookupMimeType(_pendingImage!.path);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _pendingImage!.path,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      ));

      setState(() {
        _pendingImage = null;
        _messageController.clear();
      });

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var data = json.decode(responseData.body);
        final aiResponse =
            "\nSeverity: ${data['seriousness']}\n\nDiagnosis: ${data['disease_prediction']}\n\nRemedy: ${data['remedy_info']}";

        setState(() {
          _chatMessages.removeLast();
          _chatMessages.add({"ai": aiResponse});
        });

        // Save to Supabase if severity is High
        print('API Response - Severity: ${data['seriousness']}');
        await _saveToSupabase(message, aiResponse, data['seriousness']);
      } else {
        setState(() {
          _chatMessages.removeLast();
          _chatMessages.add({"ai": "Failed to process input."});
        });
      }
    } else if (message.isNotEmpty) {
      _chatMessages.add({"user": message});
      _chatMessages.add({"ai": "Analyzing your input..."});
      setState(() {});
      final uri = Uri.parse(backendUrl);
      var response = await http.post(uri, body: {"message": message});

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final aiResponse =
            "\nSeverity: ${data['seriousness']}\n\nDiagnosis: ${data['disease_prediction']}\n\nRemedy: ${data['remedy_info']}";

        setState(() {
          _chatMessages.removeLast();
          _chatMessages.add({"ai": aiResponse});
        });

        // Save to Supabase if severity is High
        print('API Response - Severity: ${data['seriousness']}');
        await _saveToSupabase(message, aiResponse, data['seriousness']);
      } else {
        setState(() {
          _chatMessages.removeLast();
          _chatMessages.add({"ai": "Failed to process input."});
        });
      }

      _messageController.clear();
    }
  }

  Widget _buildChatBubble(String text, {required bool isUser}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: isUser ? Colors.white : Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Health Chat")),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = _chatMessages[index];
                    if (message.containsKey("user")) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: _buildChatBubble(message["user"]!, isUser: true),
                      );
                    } else if (message.containsKey("user_image")) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(message["user_image"]!),
                              height: 150,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: _buildChatBubble(message["ai"]!, isUser: false),
                      );
                    }
                  },
                ),
                if (_showDisclaimer)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "We do not store or share your data.\nSelf-care suggestions are provided only for Low and Medium severity levels.\nFor High severity, please consult a doctor — your case will be redirected to professionals.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (_pendingImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _pendingImage!,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _pendingImage = null);
                        },
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child:
                              Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  const Text("Image selected"),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _showImagePickerOptions,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (_) {
                      if (_showDisclaimer) {
                        setState(() {
                          _showDisclaimer = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: Colors.blue,
                  mini: true,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
