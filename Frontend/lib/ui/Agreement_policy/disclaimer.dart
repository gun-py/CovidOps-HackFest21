
import 'package:covigenix/ui/Agreement_policy/acc_use_policy.dart';
import 'package:flutter/material.dart';

import '../../helper.dart';


  class disclaimer extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MyTextPage();
    }
  }

  class MyTextPage extends StatelessWidget {
  @override
     Widget build(BuildContext context) {
            return SingleChildScrollView(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    Container(
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(12.0),

                      child: Text("Disclaimer",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(12.0),
                      child: Text("This application is not a substitute for medical advice. Users of this application should consult their healthcare professional before making any health, medical or other decisions based upon the data contained herein and the results of this application cannot be used for medico legal purposes."
                          "Persons using the data within for medical purposes should not rely solely on the accuracy of the data herein. While the data may be updated periodically, users should talk to their healthcare professional for the latest information."
                          "Any and all liability arising directly or indirectly from the use of this application is hereby disclaimed. The information herein is provided “as is” and without any warranty expressed or implied. All direct, indirect, special, incidental, consequential or punitive damages arising from any use of this application or data contained herein is disclaimed or excluded.",
                           maxLines: 20,
                          style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(12.0),

                      child: Text("अस्वीकरण",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(12.0),
                      child: Text("यह आवेदन चिकित्सा सलाह का विकल्प नहीं है। इस एप्लिकेशन के उपयोगकर्ताओं को यहां निहित डेटा के आधार पर किसी भी स्वास्थ्य, चिकित्सा या अन्य निर्णय लेने से पहले अपने स्वास्थ्य पेशेवर से परामर्श करना चाहिए और इस एप्लिकेशन के परिणामों का उपयोग मेडिको कानूनी उद्देश्यों के लिए नहीं किया जा सकता है।"
                          "चिकित्सा प्रयोजनों के लिए भीतर डेटा का उपयोग करने वाले व्यक्तियों को केवल यहां डेटा की सटीकता पर भरोसा नहीं करना चाहिए। हालांकि डेटा को समय-समय पर अपडेट किया जा सकता है, लेकिन उपयोगकर्ताओं को नवीनतम जानकारी के लिए अपने हेल्थकेयर पेशेवर से बात करनी चाहिए। "
                          "इस एप्लिकेशन के उपयोग से प्रत्यक्ष या अप्रत्यक्ष रूप से उत्पन्न होने वाली कोई भी और सभी देयता इसके द्वारा अस्वीकार कर दी गई है। यहां दी गई जानकारी जैसा है और बिना किसी वारंटी के व्यक्त या निहित है। इस आवेदन या यहां निहित डेटा के किसी भी उपयोग से उत्पन्न होने वाले सभी प्रत्यक्ष, अप्रत्यक्ष, विशेष, आकस्मिक, परिणामी या दंडात्मक क्षति को अस्वीकार या बाहर रखा गया है",
                        maxLines: 20,
                        style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
                    ),
                    Container(
                      height:50,
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(12.0),

                      decoration: BoxDecoration(
                           image:DecorationImage(
                           image:AssetImage("assets/images/logo.png"),
                             fit:BoxFit.fitHeight

                    ),
                      ),
                    ),


                  ]
              ),

            );
        }
     }

