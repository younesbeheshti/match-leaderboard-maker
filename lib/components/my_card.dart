import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String imagePath;
  final String tableType;
  final String routeName;

  MyCard({
    super.key,
    required this.tableType,
    required this.routeName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){print(tableType);},
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              //icon
              Icon(
                Icons.arrow_back,
                size: 18,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [

                    //text
                    Text(
                      tableType,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,

                      ),
                      textDirection: TextDirection.rtl,
                    ),

                    SizedBox(width: 10,),

                    // image
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red,
                      ),
                      // child: Image.network(
                      //   imagePath,
                      // ),
                    ),
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
