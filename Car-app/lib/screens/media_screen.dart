import 'package:flutter/material.dart';
import '../utils/app_design_system.dart';

/// Media Control Screen - Tesla Style
class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  bool _isPlaying = false;
  double _volume = 50.0;
  final String _songTitle = 'Electric Dreams';
  final String _artist = 'Neon Waves';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'MEDIA',
          style: AppTextStyles.heading3.copyWith(letterSpacing: 2),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Album Art Placeholder
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1a1a),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2a2a2a), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF64FFDA).withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.album,
                  size: 120,
                  color: const Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 40),

              // Song Info
              Text(
                _songTitle,
                style: AppTextStyles.heading2.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _artist,
                style: AppTextStyles.body2.copyWith(
                  color: const Color(0xFF6B7280),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              // Playback Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_previous),
                    color: Colors.white,
                    iconSize: 48,
                  ),
                  const SizedBox(width: 24),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF64FFDA), Color(0xFF14B8A6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF64FFDA).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() => _isPlaying = !_isPlaying);
                      },
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                      ),
                      iconSize: 40,
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_next),
                    color: Colors.white,
                    iconSize: 48,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Volume Control
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1a1a),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2a2a2a)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.volume_down, color: const Color(0xFF6B7280)),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: const Color(0xFF64FFDA),
                              inactiveTrackColor: const Color(0xFF0a0a0a),
                              thumbColor: const Color(0xFF64FFDA),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: _volume,
                              min: 0,
                              max: 100,
                              onChanged: (value) {
                                setState(() => _volume = value);
                              },
                            ),
                          ),
                        ),
                        Icon(Icons.volume_up, color: Colors.white),
                      ],
                    ),
                    Text(
                      'Volume: ${_volume.toInt()}%',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Source Selection
              Row(
                children: [
                  Expanded(
                    child: _buildSourceButton('Bluetooth', Icons.bluetooth),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSourceButton('Spotify', Icons.music_note),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSourceButton('Radio', Icons.radio)),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceButton(String label, IconData icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white70,
        side: BorderSide(color: Colors.grey[700]!),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
