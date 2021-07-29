import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            backgroundColor: Color(0xFF0a0a23),
          ),
        ),
        body: Column(
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 152,
                        width: 114,
                      ),
                    ),
                  ),
                ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 42.0),
                      child: Text(
                        'LOGIN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'RobotoMono'),
                      ),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                    width: 290,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(0xDF, 0xDF, 0xE2, 1),
                          side: BorderSide(width: 2, color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      onPressed: null,
                      child: Text(
                        'CONTINUE WITH GOOGLE',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                    width: 290,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          //#DFDFE2;
                          primary: Color.fromRGBO(0xDF, 0xDF, 0xE2, 1),
                          side: BorderSide(width: 2, color: Colors.black),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      onPressed: null,
                      child: Text(
                        'CONTINUE WITH GITHUB',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 105,
                          child: Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "or",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 105,
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 290,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide:
                                  BorderSide(width: 4, color: Colors.black)),
                          hintText: 'email'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: 290,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            //#DFDFE2;
                            primary: Color.fromRGBO(0xDF, 0xDF, 0xE2, 1),
                            side: BorderSide(width: 2, color: Colors.black),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
                        onPressed: null,
                        child: Text(
                          'EMAIL A SIGN IN CODE',
                          style: TextStyle(color: Colors.black),
                        ),
                      ))
                ],
              ),
            )
          ],
        ));
  }
}
