import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'chat_bot_page.dart';
import 'session1_question_page.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final List<String> images = const [
    'assets/session1.jpg',
    'assets/session2.jpg',
    'assets/session3.jpg',
    'assets/session4.jpg',
    'assets/session5.jpg',
    'assets/session6.jpg',
    'assets/session7.jpg',
  ];

  final List<String> sessionTitles = const [
    'Mindful Breathing',
    'Gratitude Journal',
    'Positive Affirmations',
    'Self Reflection',
    'Stress Relief',
    'Goal Setting',
    'Daily Review',
  ];

  late PageController _pageController;
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.5);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleSessionTap(int index) {
    final routes = [
      '/session1',
      '/session2',
      '/session3',
      '/session4',
      '/session5',
      '/session6',
      '/session7',
    ];
    Navigator.pushNamed(context, routes[index]);
  }

  void _goToPage(int offset) {
    final newPage = (currentPage + offset).clamp(0, images.length - 1);
    _pageController.animateToPage(
      newPage.toInt(),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildCarouselItem(BuildContext context, int index) {
    double delta = index - currentPage;
    double rotation = delta.clamp(-1.0, 1.0) * 0.5;
    double scale = max(0.85, 1 - delta.abs() * 0.2);

    return GestureDetector(
      onTap: () => _handleSessionTap(index),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(rotation),
        alignment: Alignment.center,
        child: Opacity(
          opacity: delta.abs() > 2 ? 0.3 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Transform.scale(
              scale: scale,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              size: 28,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text(
          'Sessions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/user_home');
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: screenHeight * 0.5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  itemBuilder: _buildCarouselItem,
                ),
                Positioned(
                  left: 20,
                  child: _buildNavButton(Icons.arrow_back_ios_rounded, () {
                    _goToPage(-1);
                  }),
                ),
                Positioned(
                  right: 20,
                  child: _buildNavButton(Icons.arrow_forward_ios_rounded, () {
                    _goToPage(1);
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            sessionTitles[currentPage.round()],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Session1QuestionPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C2C2C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.white24),
              ),
            ),
            icon: const Icon(Icons.assignment),
            label: const Text(
              'Go to Assessment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatBotPage()),
            );
          },
          backgroundColor: const Color(0xFF2C2C2C),
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white70, width: 2),
          ),
          icon: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 1.5),
              image: const DecorationImage(
                image: AssetImage('assets/character.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          label: const Text(
            'Chat with Us',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
