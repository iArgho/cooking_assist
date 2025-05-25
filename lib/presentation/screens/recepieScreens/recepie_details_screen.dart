import 'package:audioplayers/audioplayers.dart';
import 'package:cooking_assist/presentation/screens/recepiescreens/edit_recipie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final String recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.recipeId,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  List<int?> _remainingSeconds = [];
  List<bool> _isTimerRunning = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    final steps = (widget.recipe['steps'] as List<dynamic>?) ?? [];
    _remainingSeconds = steps
        .map<int?>((step) => (step['duration'] as int? ?? 0) * 60)
        .toList();
    _isTimerRunning = List.filled(steps.length, false);
  }

  Future<void> _playBell() async {
    await _audioPlayer.play(AssetSource('sounds/popup.mp3'));
  }

  void _startCooking() {
    final steps = (widget.recipe['steps'] as List<dynamic>?) ?? [];
    if (steps.isEmpty) {
      Get.snackbar('Error', 'No steps available to start cooking.');
      return;
    }

    int currentStepIndex = 0;

    void showStepDialog(int stepIndex) {
      if (stepIndex >= steps.length) {
        Get.snackbar('Completed', 'All steps finished! Enjoy your meal!');
        return;
      }

      final step = steps[stepIndex];
      final description = step['description']?.toString() ?? '';
      final duration = step['duration'] ?? 0;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              void startDialogTimer() {
                if (_remainingSeconds[stepIndex]! > 0 &&
                    !_isTimerRunning[stepIndex]) {
                  setDialogState(() {
                    _isTimerRunning[stepIndex] = true;
                  });
                  Future.doWhile(() async {
                    await Future.delayed(const Duration(seconds: 1));
                    if (_remainingSeconds[stepIndex]! > 0 &&
                        _isTimerRunning[stepIndex]) {
                      setDialogState(() {
                        _remainingSeconds[stepIndex] =
                            _remainingSeconds[stepIndex]! - 1;
                      });
                      setState(() {});
                      return true;
                    }
                    if (_remainingSeconds[stepIndex] == 0) {
                      await _playBell();
                      Get.snackbar(
                          'Timer', 'Step ${stepIndex + 1} is complete!');
                      setDialogState(() {
                        _isTimerRunning[stepIndex] = false;
                      });
                      setState(() {});
                    }
                    return false;
                  });
                }
              }

              void stopDialogTimer() {
                setDialogState(() {
                  _isTimerRunning[stepIndex] = false;
                });
                setState(() {});
              }

              final totalSeconds = duration * 60;
              final secondsLeft = _remainingSeconds[stepIndex]!;
              final percentComplete =
                  totalSeconds > 0 ? (1 - secondsLeft / totalSeconds) : 1.0;

              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.all(20),
                title: Text(
                  'Step ${stepIndex + 1}',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    if (duration > 0) ...[
                      LinearProgressIndicator(
                        value: percentComplete,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        color: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isTimerRunning[stepIndex]
                            ? '${(secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(secondsLeft % 60).toString().padLeft(2, '0')}'
                            : '$duration:00',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _isTimerRunning[stepIndex]
                            ? stopDialogTimer
                            : startDialogTimer,
                        icon: Icon(_isTimerRunning[stepIndex]
                            ? Icons.stop
                            : Icons.play_arrow),
                        label: Text(_isTimerRunning[stepIndex]
                            ? 'Stop Timer'
                            : 'Start Timer'),
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      stopDialogTimer();
                      Navigator.pop(ctx);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      stopDialogTimer();
                      Navigator.pop(ctx);
                      showStepDialog(stepIndex + 1);
                    },
                    child:
                        Text(stepIndex + 1 == steps.length ? 'Finish' : 'Next'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    showStepDialog(currentStepIndex);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.recipe['name'] ?? "Unnamed Recipe";
    final description =
        widget.recipe['description'] ?? "No description available.";
    final imageUrl = widget.recipe['imageUrl'];
    final steps = (widget.recipe['steps'] as List<dynamic>?) ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(() => EditRecipeScreen(
                    recipeId: widget.recipeId,
                    recipe: widget.recipe,
                  ));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          imageUrl != null && imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      Image.network(imageUrl, height: 250, fit: BoxFit.cover),
                )
              : Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.fastfood, size: 80, color: Colors.grey),
                ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _startCooking,
            icon: const Icon(Icons.kitchen),
            label: const Text('Start Cooking'),
          ),
          const SizedBox(height: 12),
          const Text(
            "Steps",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (steps.isEmpty)
            const Text(
              "No steps provided.",
              style: TextStyle(fontSize: 16),
            )
          else
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final description = step['description']?.toString() ?? '';
              final duration = step['duration'] ?? 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${index + 1}. $description",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Duration: $duration minutes",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
