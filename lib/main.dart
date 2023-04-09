import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    const MaterialApp(
        home: WhackAMoleGame(
      title: '두더지 게임',
    )),
  );
}

class WhackAMoleGame extends StatefulWidget {
  final String title;

  const WhackAMoleGame({super.key, required this.title});

  @override
  _WhackAMoleGameState createState() => _WhackAMoleGameState();
}

class _WhackAMoleGameState extends State<WhackAMoleGame> {
  int _score = 0;
  int _timeLeft = 30;
  bool _gameOver = false;
  Timer? _timer;
  final Random _random = Random();
  List<bool> _moleLocations = List.generate(9, (index) => false);
  int _currentMoleIndex = -1;

  void _increaseScore() {
    if (!_gameOver) {
      setState(() {
        _score++;
      });
    }
  }

  void _generateMole() {
    int previousMoleIndex = _currentMoleIndex;
    _currentMoleIndex = _random.nextInt(9);
    if (previousMoleIndex != -1) {
      _moleLocations[previousMoleIndex] = false;
    }
    _moleLocations[_currentMoleIndex] = true;
  }

  void startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _gameOver = false;
    });

    _moleLocations = List.generate(9, (index) => false);
    _currentMoleIndex = -1;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _gameOver = true;
          _timer?.cancel();
        }
        _generateMole();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score: $_score',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Time left: $_timeLeft',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMole(0),
                _buildMole(1),
                _buildMole(2),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMole(3),
                _buildMole(4),
                _buildMole(5),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMole(6),
                _buildMole(7),
                _buildMole(8),
              ],
            ),
            const SizedBox(height: 30),
            if (_gameOver)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _score = 0;
                    _timeLeft = 30;
                    _gameOver = false;
                  });
                  startGame();
                },
                child: const Text('Play again'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMole(int index) {
    return GestureDetector(
      onTap: () {
        if (_moleLocations[index]) {
          _increaseScore();
          _moleLocations[index] = false;
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: _moleLocations[index] ? Colors.brown : Colors.grey,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: _moleLocations[index]
              ? const Icon(Icons.pets, size: 50, color: Colors.white)
              : null,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
