import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id = 'welcome_screen';


  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}
//mixins to inherit multiple properties
class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin { //now our class can act as a single ticker

  AnimationController controller ;

  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 1),
    vsync: this,
    upperBound: 1.0);//keyword to show that this class will act as ticker

    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);  //curves cant have an upper bound greater than 1 in their controller

    animation = ColorTween(begin: Colors.blueGrey, end: bgcolor).animate(controller); //to transition from one color to another

    controller.forward();
    // can also go controller.reverse(from: 1.0);
    
    animation.addStatusListener((status) { //to check for when the animation has completed
      // print(status);
      // if(status == AnimationStatus.completed)
      //   {
      //     controller.reverse(from: 1.0);
      //   }
      // else if(status == AnimationStatus.dismissed){
      //   controller.forward();
      // }
    });
    
    controller.addListener(() {
      setState(() {

      });
      //print(controller.value); //these values can be used at multiple places
      //print(animation.value);
    });

    @override
    void dispose(){ //to actually stop the animation loop from going to infinity and costing us resources
      controller.dispose();
      super.dispose();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red.withOpacity(controller.value), //application of the ticker value
      // backgroundColor: Colors.white,
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'Logo',
                  child: Container(
                    child: Image.asset('images/chatbox.png'),
                    // height: animation.value * 100,
                    height: 40.0,
                    padding: EdgeInsets.only(right: 10.0),
                  ),
                ),
                TypewriterAnimatedTextKit(  //new animation text kit
                  // '${controller.value.toInt()}%', //another application of controller values
                  text:['oyus chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
           RoundedButton(title: 'Login',color: Colors.lightBlueAccent,onPressed: (){Navigator.pushNamed(context, LoginScreen.id);}),
            RoundedButton(onPressed: (){Navigator.pushNamed(context, RegistrationScreen.id);},title: 'Register',color: Colors.blueAccent,)
          ],
        ),
      ),
    );
  }
}



