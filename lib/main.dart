import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';
import 'package:naviga/view/navigate-progress.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool internet = true; // Assume internet is initially available

  @override
  void initState() {
    super.initState();
    checkInitialConnectivity();

    // Listen for changes in connectivity
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      handleConnectivityChange(result);
    });
  }

  Future<void> checkInitialConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    handleConnectivityChange(connectivityResult);
  }

  void handleConnectivityChange(ConnectivityResult result) {
    var logger = Logger();

    if (result == ConnectivityResult.none) {
      // No internet connection
      logger.d('No internet connection');
      setState(() {
        internet = false;
      });

      // Show the no internet connection dialog
      _showNoInternetDialog(context);
    } else {
      // Internet connection available
      logger.d('Connected to the internet');
      setState(() {
        internet = true;
      });
    }
  }

  // Function to show the no internet connection modal dialog
  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Builder(
        builder: (BuildContext context) {
          if (!internet) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('No Internet'),
              ),
              body: const Center(
                child: Text(
                    'No internet connection. Please check your connection.'),
              ),
            );
          }

          return Scaffold(
            // appBar: AppBar(
            //   title: const Text('Naviga Visual'),
            //   backgroundColor: const Color(0xFF9B50E7),
            // ),
            body: NavigationProgress(),
          );
        },
      ),
    );
  }
}
