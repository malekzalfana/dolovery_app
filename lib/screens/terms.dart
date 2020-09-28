import 'package:flutter/material.dart';

class Terms extends StatefulWidget {
  Terms({Key key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Terms> {
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
                        "Terms & Conditions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          fontFamily: 'Axiforma',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text("""
1. TERMS
By accessing this web site, you are agreeing to be bound by these web site Terms and Conditions of Use, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this site. The materials contained in this web site are protected by applicable copyright and trademark law.

2. DISCLAIMER
Dolovery does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its Internet web site or otherwise relating to such materials or on any sites linked to this site.

3. REVISIONS AND ERRATA
The materials appearing on Dolovery’s web site could include technical, typographical, or photographic errors. Dolovery does not warrant that any of the materials on its web site are accurate, complete, or current. Dolovery may make changes to the materials contained on its web site at any time without notice. Dolovery does not, however, make any commitment to update the materials.

4. SERVICE
– This service will only be used for promotional purposes for your photo’s on Instagram.
– You will not upload anything into this service’s rotation that includes nudity or any material that is not accepted or suitable for the Instagram community.
– You shall not knowingly exploit the system.
– The service sometimes might deliver later than the planned date stated on the website’s order page. This can be completely normal. Contact our support team if your order isn’t delivered in time, they will most likely find a suitable solution. Late delivery does not mean you will get a refund.
– People might in some cases unfollow your account. If this happens, feel free to contact our support. They will probably find a suitable solution to replace them.
– Minority of Instagram users might be inactive. You don’t have the right to claim a refund in this case.

5. PAYMENT
– You agree that upon purchasing ‘likes’ or ‘followers’, you clearly understand and agree what you are purchasing and will not file a fraudulent dispute via PayPal, Credit card company, or Bank.
– Upon a fraudulent attempt to file a dispute, claim, unauthorized transaction or chargeback, we grant the right, if necessary, to ban your IP address from this website and you allow us to take legal actions against you. Also, we remain the right to (attempt to) terminate your Instagram account.
– No partial or full refunds will be issued for service interruption, failure or anything else unless your order does not get delivered at all.
– By purchasing anything from this website, you agree to PayPal’s and card payment companies Terms of Service and state to not break any of their rules.

6. REFUND POLICY
If delivery of our service is not started within 120 hours after purchase without having received an e-mail from us, we can fully refund the cost of your order upon customer request.

7. SITE TERMS OF USE MODIFICATIONS
Dolovery may revise these terms of use for its web site at any time without notice. By using this web site you are agreeing to be bound by the then current version of these Terms and Conditions of Use.



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
