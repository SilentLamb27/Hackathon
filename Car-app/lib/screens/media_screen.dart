import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_design_system.dart';
import '../providers/car_provider.dart';

/// Media Control Screen - Tesla Style
class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CarProvider>(context);
    final isRadio = carProvider.mediaSource == 'Radio';

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

              // Album Art / Radio Icon
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
                  isRadio ? Icons.radio : Icons.album,
                  size: 120,
                  color: const Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 40),

              // Display Info (Radio Station or Song)
              if (isRadio) ...[
                Text(
                  'FM ${carProvider.currentRadioStation['frequency']}',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  carProvider.currentRadioStation['name'] ?? 'Radio',
                  style: AppTextStyles.body2.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 16,
                  ),
                ),
              ] else ...[
                Text(
                  carProvider.currentTrack['title'] ?? 'Unknown',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  carProvider.currentTrack['artist'] ?? 'Unknown Artist',
                  style: AppTextStyles.body2.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 16,
                  ),
                ),
              ],

              const SizedBox(height: 40),

              // Playback Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (isRadio) {
                        carProvider.previousRadioStation();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'FM ${carProvider.currentRadioStation['frequency']} - ${carProvider.currentRadioStation['name']}',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color(0xFF64FFDA),
                            duration: const Duration(milliseconds: 1200),
                          ),
                        );
                      } else {
                        carProvider.previousTrack();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Previous: ${carProvider.currentTrack['title']}',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color(0xFF64FFDA),
                            duration: const Duration(milliseconds: 1200),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      isRadio ? Icons.arrow_back : Icons.skip_previous,
                    ),
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
                        carProvider.togglePlayPause();
                      },
                      icon: Icon(
                        carProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                      ),
                      iconSize: 40,
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: () {
                      if (isRadio) {
                        carProvider.nextRadioStation();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'FM ${carProvider.currentRadioStation['frequency']} - ${carProvider.currentRadioStation['name']}',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color(0xFF64FFDA),
                            duration: const Duration(milliseconds: 1200),
                          ),
                        );
                      } else {
                        carProvider.nextTrack();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Next: ${carProvider.currentTrack['title']}',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: const Color(0xFF64FFDA),
                            duration: const Duration(milliseconds: 1200),
                          ),
                        );
                      }
                    },
                    icon: Icon(isRadio ? Icons.arrow_forward : Icons.skip_next),
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
                              value: carProvider.volume,
                              min: 0,
                              max: 100,
                              onChanged: (value) {
                                carProvider.setVolume(value);
                              },
                            ),
                          ),
                        ),
                        Icon(Icons.volume_up, color: Colors.white),
                      ],
                    ),
                    Text(
                      'Volume: ${carProvider.volume.toInt()}%',
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
                    child: _buildSourceButton(
                      context,
                      carProvider,
                      'Bluetooth',
                      Icons.bluetooth,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSourceButton(
                      context,
                      carProvider,
                      'Spotify',
                      Icons.music_note,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSourceButton(
                      context,
                      carProvider,
                      'Radio',
                      Icons.radio,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceButton(
    BuildContext context,
    CarProvider carProvider,
    String label,
    IconData icon,
  ) {
    final isActive = carProvider.mediaSource == label;

    return SizedBox(
      height: 80,
      child: OutlinedButton(
        onPressed: () {
          carProvider.setMediaSource(label);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Switched to $label',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFF64FFDA),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isActive ? const Color(0xFF64FFDA) : Colors.white70,
          side: BorderSide(
            color: isActive ? const Color(0xFF64FFDA) : const Color(0xFF2a2a2a),
            width: 2,
          ),
          backgroundColor: isActive
              ? const Color(0xFF64FFDA).withOpacity(0.1)
              : null,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
