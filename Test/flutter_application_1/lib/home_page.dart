import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/imgs/anime-4k.png",
                fit: BoxFit.cover,
              ),
            ),
              Container(color: Colors.black.withOpacity(0.5), height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,),
              SizedBox(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                const FlutterLogo(
                size: 150,
                textColor: Colors.white,
                style: FlutterLogoStyle.horizontal,
              ),
                ElevatedButton(
                  onPressed: (){}, 
                  child: const Text('Entrar no app'),
                ),
              ],
              ),
              ),
          ],
        ),
      ),
    );
  }
}
