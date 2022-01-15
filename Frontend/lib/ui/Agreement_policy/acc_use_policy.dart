
import 'package:flutter/material.dart';

import '../../helper.dart';


class acc_use_policy extends StatelessWidget {
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
          children:<Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Acceptable Use Policy",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''This acceptable use policy "("Policy") sets forth the general guidelines and acceptable and prohibited uses of the "CovidOps" mobile application ("Mobile Application" or "Service") and any of its related products and services (collectively, "Services"). This Policy is a legally binding agreement between you ("User", "you" or "your") and this Mobile Application developer ("Operator", "we", "us" or "our").By accessing and using the Mobile Application and Services, you acknowledge that you have read, understood, and agree to be bound by the terms of this Agreement. If you are entering into this Agreement on behalf of a business or other legal entity, you represent that you have the authority to bind such entity to this Agreement, in which case the terms "User", "you" or "your" shall refer to such entity. If you do not have such authority, or if you do not agree with the terms of this Agreement, you must not accept this Agreement and may not access and use the Mobile Application and Services. You acknowledge that this Agreement is a contract between you and the Operator, even though it is electronic and is not physically signed by you, and it governs your use of the Mobile Application and Services.''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),

              child: Text("Prohibited activities and uses",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''You may not use the Mobile Application and Services to publish content or engage in activity that is illegal under applicable law, that is harmful to others, or that would subject us to liability, including, without limitation, in connection with any of the following, each of which is prohibited under this Policy:''',
                maxLines: 20,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(

              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(18.0),
              child: Text('''  1.   Distributing malware or other malicious code.
  2.  Disclosing sensitive personal information about others.
  3.  Collecting, or attempting to collect, personal information about third parties without their knowledge or consent. 
  4.  Distributing pornography or adult related content.
  5.  Promoting or facilitating prostitution or any escort services.
  6.  Hosting, distributing or linking to child pornography or content that is harmful to minors. 
  7.  Promoting or facilitating gambling, violence, terrorist activities or selling weapons or ammunition.
  8.  Engaging in the unlawful distribution of controlled substances, drug contraband or prescription medications. 
  9.  Managing payment aggregators or facilitators such as processing payments on behalf of other businesses or charities.
 10.  Facilitating pyramid schemes or other models intended to seek payments from public actors. 
 11. Threatening harm to persons or property or otherwise harassing behavior.
 12. Infringing the intellectual property or other proprietary rights of others.
 13. Facilitating, aiding, or encouraging any of the above activities through the Mobile Application and Services.''',
                maxLines: 20,
                textAlign:TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Security Abuse",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''Any User in violation of the Mobile Application and Services security is subject to criminal and civil liability, as well as immediate account termination. Examples include, but are not limited to the following:''',
                maxLines: 20,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),

            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(18.0),
              child: Text('''  1.  Use or distribution of tools designed for compromising security of the Mobile Application and Services.
  2.  Disclosing sensitive personal information about othersIntentionally or negligently transmitting files containing a computer virus or corrupted data.
  3.  Accessing another network without permission, including to probe or scan for vulnerabilities or breach security or authentication measures.
  4.  Unauthorized scanning or monitoring of data on any network or system without proper authorization of the owner of the system or network.''',
                maxLines: 20,
                textAlign:TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Service resources",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''You may not consume excessive amounts of the resources of the Mobile Application and Services or use the Mobile Application and Services in any way which results in performance issues or which interrupts the Services for other Users. Prohibited activities that contribute to excessive use, include without limitation:''',
                maxLines: 20,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),


            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(18.0),
              child: Text(''' 1. Deliberate attempts to overload the Mobile Application and Services and broadcast attacks (i.e. denial of service attacks).
  2.  Engaging in any other activities that degrade the usability and performance of the Mobile Application and Services.''',
                maxLines: 20,
                textAlign:TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("No spam policy",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''You may not use the Mobile Application and Services to send spam or bulk unsolicited messages. We maintain a zero tolerance policy for use of the Mobile Application and Services in any manner associated with the transmission, distribution or delivery of any bulk e-mail, including unsolicited bulk or unsolicited commercial e- mail, or the sending, assisting, or commissioning the transmission of commercial e-mail that does not comply with the U.S. CAN-SPAM Act of 2003 ("SPAM").Your products or services advertised via SPAM (i.e. Spamvertised) may not be used in conjunction with the Mobile Application and Services. This provision includes, but is not limited to, SPAM sent via fax, phone, postal mail, email, instant messaging, or newsgroups. Sending emails through the Mobile Application and Services to purchased email lists ("safe lists") will be treated as SPAM.''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Defamation and objectionable content",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''We value the freedom of expression and encourage Users to be respectful with the content they post. We are not a publisher of User content and are not in a position to investigate the veracity of individual defamation claims or to determine whether certain material, which we may find objectionable, should be censored. However, we reserve the right to moderate, disable or remove any content to prevent harm to others or to us or the Mobile Application and Services, as determined in our sole discretion.''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Copyrighted content",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''Copyrighted material must not be published via the Mobile Application and Services without the explicit permission of the copyright owner or a person explicitly authorized to give such permission by the copyright owner. Upon receipt of a claim for copyright infringement, or a notice of such violation, we will immediately run full investigation. However, we generally require a court order from a court of competent jurisdiction, as determined by us in our sole discretion, to take down alleged infringing material from the Mobile Application and Services. We may terminate the Service of Users with repeated copyright infringements. Further procedures may be carried out if necessary. We will assume no liability to any User of the Mobile Application and Services for the removal of any such material. If you believe your copyright is being infringed by a person or persons using the Mobile Application and Services, please get in touch with us to report copyright infringement.''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Security",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''You take full responsibility for maintaining reasonable security precautions for your account. You are responsible for protecting and updating any login account provided to you for the Mobile Application and Services.''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Enforcement",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''We reserve our right to be the sole arbiter in determining the seriousness of each infringement and to immediately take corrective actions, including but not limited to:''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(

              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(18.0),
              child: Text('''  1. Suspending or terminating your Service with or without notice upon any violation of this Policy. Any violations may also result in the immediate suspension or termination of your account.
  2. Disabling or removing any content which is prohibited by this Policy, including to prevent harm to others or to us or the Mobile Application and Services, as determined by us in our sole discretion. 
  3. Reporting violations to law enforcement as determined by us in our sole discretion.
  4. A failure to respond to an email from our abuse team within 2 days, or as otherwise specified in the communication to you, may result in the suspension or termination of your account.''',
                maxLines: 20,
                textAlign:TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''Suspended and terminated User accounts due to violations will not be re-activated.Nothing contained in this Policy shall be construed to limit our actions or remedies in any way with respect to any of the prohibited activities. In addition, we reserve at all times all rights and remedies available to us with respect to such activities at law or in equity.''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Reporting violations",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''If you have discovered and would like to report a violation of this Policy, please contact us immediately. We will investigate the situation and provide you with full assistance.''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Changes and amendments",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''We reserve the right to modify this Policy or its terms relating to the Mobile Application and Services at any time, effective upon posting of an updated version of this Policy in the Mobile Application. When we do, we will revise the updated date at the bottom of this page. Continued use of the Mobile Application and Services after any such changes shall constitute your consent to such changes.''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Acceptance of this policy",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''You acknowledge that you have read this Policy and agree to all its terms and conditions. By accessing and using the Mobile Application and Services you agree to be bound by this Policy. If you do not agree to abide by the terms of this Policy, you are not authorized to access or use the Mobile Application and Services. This acceptable use policy was created with the acceptable use policy generator.''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text("Contacting us",style: TextStyle(color:Colors.black,fontSize:Helper.headSize,fontWeight:FontWeight.bold),textAlign:TextAlign.left),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(12.0),
              child: Text('''If you would like to contact us to understand more about this Policy or wish to contact us concerning any matter relating to it, you may do so via the contact form or send an email to covidops2021@gmail.com. This document was last updated on May 5, 2021''',
                maxLines: 20,
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.black,fontSize:Helper.textSize),),
            ),
            Container(
              height:50,
              alignment: Alignment.center,
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

