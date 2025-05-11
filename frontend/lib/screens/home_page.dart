import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_chatbot/screens/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _videoIdController = TextEditingController();
  bool _isIndexing = false;
  String _indexingStatus = '';
  bool _videoIndexed = false;

  @override
  void dispose() {
    _videoIdController.dispose();
    super.dispose();
  }

  String _extractVideoId(String input) {
    // Clean the input by trimming whitespace
    input = input.trim();

    // If it's already just an ID (11 characters), return it
    if (RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(input)) {
      return input;
    }

    // Try to extract from various YouTube URL formats
    RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    );

    final match = regExp.firstMatch(input);
    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? '';
    }

    // If we can't extract an ID, return the original input
    // The backend can handle the error
    return input;
  }

  Future<void> _indexVideo() async {
    final videoId = _extractVideoId(_videoIdController.text);
    if (videoId.isEmpty) {
      _showSnackBar('Please enter a valid YouTube video ID or URL');
      return;
    }

    setState(() {
      _isIndexing = true;
      _indexingStatus = 'Indexing video...';
      _videoIndexed = false;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/index-youtube'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'video_id': videoId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isIndexing = false;
          _indexingStatus = 'Video indexed successfully!';
          _videoIndexed = true;
        });
        _showSnackBar('Video indexed successfully!');
      } else {
        final error = jsonDecode(response.body);
        setState(() {
          _isIndexing = false;
          _indexingStatus = 'Error: ${error['detail'] ?? 'Unknown error'}';
          _videoIndexed = false;
        });
        _showSnackBar(
          'Failed to index video: ${error['detail'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      setState(() {
        _isIndexing = false;
        _indexingStatus = 'Error: $e';
        _videoIndexed = false;
      });
      _showSnackBar('Failed to connect to server: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YouTube RAG Chat',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Video ID Input Section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Index YouTube Video',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter a YouTube video ID or URL to index its transcript',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _videoIdController,
                            decoration: InputDecoration(
                              hintText: 'YouTube video ID or URL',
                              prefixIcon: const Icon(Icons.link),
                              suffixIcon:
                                  _videoIdController.text.isNotEmpty
                                      ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _videoIdController.clear();
                                          setState(() {});
                                        },
                                      )
                                      : null,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed:
                              _videoIdController.text.isNotEmpty && !_isIndexing
                                  ? _indexVideo
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          child: const Text('Index'),
                        ),
                      ],
                    ),
                    if (_indexingStatus.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (_isIndexing)
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            )
                          else
                            Icon(
                              _videoIndexed ? Icons.check_circle : Icons.error,
                              size: 16,
                              color: _videoIndexed ? Colors.green : Colors.red,
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _indexingStatus,
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    _videoIndexed ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Button to start chatting
            ElevatedButton.icon(
              onPressed:
                  _videoIndexed
                      ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatPage(),
                        ),
                      )
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.chat),
              label: const Text(
                'Start Chatting',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),

            const SizedBox(height: 24),

            // Example section
            Text(
              'Example YouTube Video IDs:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _buildExampleVideoCard(
              context,
              'dQw4w9WgXcQ',
              'Rick Astley - Never Gonna Give You Up',
              'Music Video',
            ),
            const SizedBox(height: 8),
            _buildExampleVideoCard(
              context,
              '9bZkp7q19f0',
              'PSY - Gangnam Style',
              'Music Video',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleVideoCard(
    BuildContext context,
    String videoId,
    String title,
    String category,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _videoIdController.text = videoId;
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(Icons.play_arrow, color: colorScheme.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          videoId,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.content_copy, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: videoId));
                  _showSnackBar('Video ID copied to clipboard');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About RAG YouTube Chat'),
            content: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'This app uses RAG (Retrieval Augmented Generation) to chat with YouTube video transcripts.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'How to use:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. Enter a YouTube video ID or URL'),
                  Text('2. Click "Index" to process the transcript'),
                  Text('3. Once indexed, start chatting!'),
                  SizedBox(height: 16),
                  Text(
                    'The app will extract information from the transcript to answer your questions.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
