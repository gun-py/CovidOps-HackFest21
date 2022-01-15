import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/custom_widgets/contact_card.dart';
import 'package:flutter/material.dart';

class contact_us extends StatefulWidget {
  @override
  _contact_usState createState() => _contact_usState();
}

class _contact_usState extends State<contact_us> {

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/contact_us.png"),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.4), BlendMode.dstATop),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Expanded(
                    child: ContactCard(
                      name: "Akash Mahapatra",
                      path: "assets/images/akash.png",
                      numberMail: "7809601401\nmahapatraakash@gmail.com",
                      description: "Contact me for Technical Assistance",
                      onTap: () => Helper.call("7809601401"),
                    ),
                    flex: 1),
                Expanded(
                    child: ContactCard(
                      name: "Aman Mittal",
                      path: "assets/images/aman.png",
                      numberMail: "9835063191\namaniit2109@gmail.com",
                      description:
                          "Contact me for Collaboration and Legal Assistance",
                      onTap: () => Helper.call("9835063191"),
                    ),
                    flex: 1),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: ContactCard(
                      name: "Gunjan Haldar",
                      path: "assets/images/gunjan.png",
                      numberMail: "9674766482\ngunjanhaldar1999@gmail.com",
                      description: "Contact me for General Assistance",
                      onTap: () => Helper.call("9674766482"),
                    ),
                    flex: 1),
                Expanded(
                    child: ContactCard(
                      name: "Kunal Agarwal",
                      path: "assets/images/kunal.png",
                      numberMail: "9352269233\nagarwal.kunal2305@gmail.com",
                      description: "Contact me for Technical Assistance",
                      onTap: () => Helper.call("9352269233"),
                    ),
                    flex: 1),
              ],
            ),
          ],
        ),
    );
  }
}
