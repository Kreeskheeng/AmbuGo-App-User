import 'package:flutter/material.dart';
import 'package:last_minute/app/modules/pay_stack/Payment/paystack_payment_page.dart';

class YourParentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            //Choose a plan
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Choose\nYour Plan",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //GridView
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10),
                children: List.generate(plans.length, (index) {
                  final data = plans[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        price = data["price"]!;
                      });
                    },
                    child: Card(
                      shadowColor: Colors.green,
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: selectedIndex == null
                              ? null
                              : selectedIndex == index
                                  ? Colors.green
                                  : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "N ${data["price"]}",
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              "Get ${data["items"]} More",
                            ),
                            Text(
                              "Items",
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

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

  final plans = [
    {"price": 500, "items": 4},
    {"price": 1000, "items": 6},
    {"price": 3500, "items": 9},
    {"price": 5600, "items": 10},
  ];
}
