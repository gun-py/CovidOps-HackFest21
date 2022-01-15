import 'package:covigenix/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ContactCard extends StatelessWidget {
  final String name, path, description, numberMail;
  final Function onTap;
  ContactCard(
      {required this.name, required this.path, required this.numberMail, required this.description, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(path),
                      fit: BoxFit.fill,
                    )),
              ),
              Center(child: Text(name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),)),
              GestureDetector(child: Center(child: Text(numberMail, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0,color:Colors.blue),)), onTap: () => onTap(),),
              Center(child: Text(description, textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12.0),)),
            ],
          )),
    );
  }
}
