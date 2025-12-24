import 'package:flutter/material.dart';
import 'package:google_speech/google_speech.dart';

class VoiceAssistantWidget extends StatefulWidget {
  final void Function(String command) onCommandRecognized;
  const VoiceAssistantWidget({Key? key, required this.onCommandRecognized})
    : super(key: key);

  @override
  State<VoiceAssistantWidget> createState() => _VoiceAssistantWidgetState();
}

class _VoiceAssistantWidgetState extends State<VoiceAssistantWidget> {
  bool _isListening = false;
  String _recognizedText = '';

  // TODO: Replace with your Google Cloud API key
  final String _apiKey = 'YOUR_GOOGLE_CLOUD_API_KEY';

  void _startListening() async {
    setState(() => _isListening = true);
    // This is a placeholder for actual Google Speech-to-Text integration
    // You need to set up Google Cloud Speech-to-Text and use the google_speech package
    // For demo, we simulate a recognized command after a delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _recognizedText = 'Turn on climate';
      _isListening = false;
    });
    widget.onCommandRecognized(_recognizedText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
          label: Text(_isListening ? 'Listening...' : 'Start Voice Command'),
          onPressed: _isListening ? null : _startListening,
        ),
        if (_recognizedText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Recognized: $_recognizedText'),
          ),
      ],
    );
  }
}
