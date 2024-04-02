import 'package:flutter/material.dart';

import 'Payment/paystack_payment_page.dart';


class YourParentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: PayStack(
          initialPrice: 500, // Set the initial price value
          initialEmail: "user@example.com", // Set the initial email value
        ),
      ),
    );
  }
}

class PayStack extends StatefulWidget {
  final int initialPrice;
  final String initialEmail;

  const PayStack({
    Key? key,
    required this.initialPrice,
    required this.initialEmail,
  }) : super(key: key);

  @override
  _PayStackState createState() => _PayStackState();
}

class _PayStackState extends State<PayStack> {
  late int selectedIndex = -1;
  late int price;
  late String email;

  @override
  void initState() {
    super.initState();
    price = widget.initialPrice;
    email = widget.initialEmail;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (selectedIndex == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select a plan")));
                } else {
                  //Call Paystack payment
                  print(price);
                  MakePayment(ctx: context, email: email, price: price)
                      .chargeCardAndMakePayment();
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.green),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //icon
                    Icon(Icons.security, color: Colors.white),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Proceed to payment",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}
