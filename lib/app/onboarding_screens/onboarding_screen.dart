import 'package:flutter/material.dart';
import 'package:ems_offbeat/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Efficient HR Management \nin One Place",
      "subtitle":
          "Get ready to streamline your HR tasks, We helps you effortlessly manage employee attendance, departments and payroll",
      "image": "assets/images/onboarding_rec.png",
    },
    {
      "title": "Organize Departments \nand Payroll",
      "subtitle":
          "Lets you create and manage departements, handle automated payroll, and even initiate employee chats.",
      "image": "assets/images/onboarding_rec.png",
    },
    {
      "title": "Optimize Schedules and \nApprovals",
      "subtitle":
          "Lets you create and manage departements, handle automated payroll, and even initiate employee chats.",
      "image": "assets/images/onboarding_rec.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PAGEVIEW FOR ALL 3 ONBOARDING SCREENS
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() => currentPage = index);
            },
            itemBuilder: (context, index) {
              return buildOnboardingPage(
                onboardingData[index]["title"]!,
                onboardingData[index]["subtitle"]!,
                onboardingData[index]["image"]!,
                index,
              );
            },
          ),

  
          // DOTS + BUTTONS
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // DOTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (i) => dot(i == currentPage),
                  ),
                ),

                const SizedBox(height: 25),

                // BUTTON LOGIC
                currentPage == onboardingData.length - 1
                    ? buildGetStartedButton()
                    : buildNavButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // SINGLE ONBOARDING PAGE UI
  Widget buildOnboardingPage(
    String title,
    String subtitle,
    String image,
    int index,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            // TOP BLUE
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: AppThemeData.primary500,
              ),
            ),

            // BOTTOM WHITE
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    // TITLE
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // SUBTITLE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        
        // IMAGE HALF BLUE + HALF WHITE
        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/onboarding_rec.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  // DOT INDICATORS
  Widget dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: active ? 22 : 10,
      decoration: BoxDecoration(
        color: active ? AppThemeData.primary400 : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }


  // SKIP + NEXT BUTTONS
  Widget buildNavButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // SKIP
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppThemeData.primary400, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/signin");
          },
          child: const Text(
            "Skip",
            style: TextStyle(color: AppThemeData.primary400, fontSize: 16),
          ),
        ),

        // NEXT
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppThemeData.primary500,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onPressed: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          child: const Text(
            "Next",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }


  // GET STARTED BUTTON (LAST PAGE)
  Widget buildGetStartedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemeData.primary500,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, "/login");
      },
      child: const Text(
        "Get Started",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
