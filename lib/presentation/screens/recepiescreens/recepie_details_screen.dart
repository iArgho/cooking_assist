import 'dart:async';
import 'package:cooking_assist/presentation/screens/recepiescreens/edit_recipie.dart';
import 'package:cooking_assist/utility/path_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

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
  int _currentStep = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _countdown = 0;
  int _totalCountdownTime = 0; // Holds the total time for the countdown
  Timer? _timer;

  List<Map<String, String>> get steps {
    final rawSteps = widget.recipe['steps'] ?? [];
    return List<Map<String, String>>.from(
      rawSteps.map((step) => Map<String, String>.from(step)),
    );
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource(Paths().popUp));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  int? _parseTime(String time) {
    final lower = time.toLowerCase();
    final match = RegExp(r'\d+').firstMatch(lower);
    if (match == null) return null;
    final number = int.parse(match.group(0)!);

    if (lower.contains("min")) return number * 60;
    if (lower.contains("sec")) return number;
    return number;
  }

  void _startCountdown(int seconds) {
    debugPrint("Starting countdown for $seconds seconds.");
    _totalCountdownTime = seconds;
    _countdown = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
          debugPrint("Countdown: $_countdown sec");
        } else {
          timer.cancel();
          _nextStepPrompt();
          debugPrint("Countdown ended, moving to next step.");
        }
      });
    });
  }

  void _nextStepPrompt() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Step Completed!"),
        content: const Text("Are you ready for the next step?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentStep++;
              });
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  void _markStepAsDone() async {
    await _playSound();

    if (_currentStep < steps.length - 1) {
      final stepTime = steps[_currentStep]['time'] ?? '';
      final duration = _parseTime(stepTime);

      if (duration != null && duration > 0) {
        _startCountdown(duration);
      } else {
        _nextStepPrompt();
      }
    } else {
      Get.snackbar("Recipe Completed", "All steps are done!");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text("You've completed the recipe."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentStep = 0;
                  _countdown = 0;
                });
              },
              child: const Text("Restart"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.recipe['name'] ?? "Unnamed Recipe";
    final description =
        widget.recipe['description'] ?? "No description available.";
    final imageUrl = widget.recipe['imageUrl'];

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(imageUrl, height: 250, fit: BoxFit.cover)
              : Container(
                  height: 250,
                  color: Colors.grey[300],
                  child:
                      const Icon(Icons.fastfood, size: 80, color: Colors.grey),
                ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(description, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 10),
          if (steps.isNotEmpty)
            LinearProgressIndicator(
              value: (_currentStep + 1) / steps.length,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
          const SizedBox(height: 20),
          if (steps.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    "Step ${_currentStep + 1} of ${steps.length}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    steps[_currentStep]['instruction'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  if ((steps[_currentStep]['time'] ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Estimated Time: ${steps[_currentStep]['time']}",
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ),
                  // Countdown progress bar
                  if (_totalCountdownTime > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: LinearProgressIndicator(
                        value: _countdown /
                            _totalCountdownTime, // Updates based on countdown
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _countdown == 0 ? _markStepAsDone : null,
                    icon: const Icon(Icons.check),
                    label: const Text("Mark Step as Done"),
                  ),
                  const SizedBox(height: 10),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentStep = 0;
                          _countdown = 0;
                          _timer?.cancel();
                        });
                      },
                      child: const Text("Restart Recipe"),
                    ),
                ],
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("No steps provided for this recipe."),
            ),
        ],
      ),
    );
  }
}
