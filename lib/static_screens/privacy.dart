import 'package:flutter/material.dart';

class Privacy extends StatefulWidget {
  Privacy({Key key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 50),
                      child: Text(
                        "Privacy & Policy",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text("""
INFORMATION WE COLLECT
* Information you provide to us or allow others to provide to us
At various points in the Dolovery experience, you may provide us with information about yourself. For example, when you create an account with Dolovery, you provide us with personal information like your name, email address, phone number and your address.
* Technical information about usage of Dolovery
When you use the Dolovery services, either through a browser or mobile app, we automatically receive some technical information about the hardware and software that is being used.
COOKIES AND OTHER TRACKING TECHNOLOGIES:
We and our partners use various technologies to collect information, including cookies and device identifiers. Cookies are small text files that are sent by your computer when you access our services through a browser. We may use session cookies (which expire when you close your browser), persistent cookies (which expire when you choose to clear them from your browser), and other identifiers to collect information from your browser or device that helps us personalize your experience.
 We employ some third-party services to help us understand the usage of Dolovery and these third-parties may also deploy cookies on our site or collect information through our mobile applications. For example, we use Google Analytics to understand, in a non-personal way, how users interact with various portions of our site. You can learn more about information that Google may collect here (http://www.google.com/policies/privacy/).
LOG INFORMATION:
When you use Dolovery, our servers will record information about your usage of the service and information that is sent by your browser or device. Logs information can include things like the IP address of your device, information about the browser, operating system and/or app you are using, unique device identifiers, pages that you navigate to and links that you click, searches that you run on Dolovery, and other ways you interact with the service. If you are logged into the Dolovery service, this information is stored with your account information.
Some of the advertisements you see on the Site are selected and delivered by third parties, such as ad networks, advertising agencies, advertisers, and audience segment providers. These third parties may collect information about you and your online activities, either on the Site or on other websites, through cookies, web beacons, and other technologies in an effort to understand your interests and deliver to you advertisements that are tailored to your interests. Please remember that we do not have access to, or control over, the information these third parties may collect. The information practices of these third parties are not covered by this privacy policy.
HOW WE USE YOUR INFORMATION
We may use the information we collect for various purposes, including to:
* Provide the Dolovery service to you and to improve the quality of the service we’re able to offer.
* Offer you customized content (including advertising and promotions), such as prominently displaying items you purchase frequently.
* Understand how users interact with our service as a whole in order to test new features and improve Dolovery for everyone
* Provide customer service, respond to your communications and requests, and contact you about your use of Dolovery (
CHANGES TO THIS POLICY
This policy may change from time to time and any revised Policy will be posted at this page, so we encourage you to review it regularly. If we make changes, we will notify you by revising the date at the top of this Policy and, in some cases; we may provide you with additional notice (such as a notice on our homepage or sending you a notification).
CONTACT INFORMATION
CONTACT@DOLOVERY.COM

                    """)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
