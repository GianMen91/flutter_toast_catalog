import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';
import 'item.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    required this.itemIndex,
    required this.item,
  }) :  super(key: key);

  final int itemIndex;
  final Item item;

  @override
  Widget build(BuildContext context) {
    // It  will provide us total height and width of our screen
    Size size = MediaQuery.of(context).size;

    String formattedLastSold = item.lastSold;

    if(formattedLastSold!=''){
      formattedLastSold = DateFormat('dd MMMM yyyy').format(DateTime.parse(formattedLastSold));
    }


    var itemName = item.name;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      height: 150,
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    blurRadius: 20.0, // soften the shadow
                    offset: const Offset(
                      5.0,
                      5.0,
                    ),
                  )
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 140,
                width: size.width-50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: 10),
                      child: Text(
                        itemName.trim(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'OPEN SANS'),
                      ),
                    ),
                    // it use the available space
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: 10),
                      child: Text(
                        "Starts: $formattedLastSold",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: 10),
                      child: Text(
                        "Price: €${item.price}",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
