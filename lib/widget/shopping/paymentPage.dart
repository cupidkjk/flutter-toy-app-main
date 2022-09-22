import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myfatoorah_flutter/model/initsession/SDKInitSessionResponse.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';
import 'package:myfatoorah_flutter/utils/MFCountry.dart';
import 'package:myfatoorah_flutter/utils/MFEnvironment.dart';
import 'package:toy_app/components/components.dart';

import 'package:toy_app/helper/constant.dart';

import 'package:provider/provider.dart';
import 'package:toy_app/provider/index.dart';

class Payment extends StatefulWidget {
  const Payment({Key key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  // provider setting
  AppState _appState;

  String _response = '';
  final String _loading = "Loading...";
  var sessionIdValue = "";
  MFPaymentCardView mfPaymentCardView;

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<AppState>(context, listen: false);
    if (paymentAPIKey.isEmpty) {
      setState(() {
        _response =
            "Missing API Token Key.. You can get it from here: https://myfatoorah.readme.io/docs/test-token";
      });
      return;
    }

    MFSDK.init(paymentAPIKey, MFCountry.KUWAIT, MFEnvironment.TEST);
    initiateSession();
    // (Optional) un comment the following lines if you want to set up properties of AppBar.

    // MFSDK.setUpAppBar(
    //     title: AppLocalizations.of(context).paymentpage_atext,
    //     titleColor: Colors.black, // Color(0xFFFFFFFF)
    //     backgroundColor: Colors.lightBlue, // Color(0xFF000000)
    //     isShowAppBar: true); // For Android platform only

    // (Optional) un comment this line, if you want to hide the AppBar.
    // Note, if the platform is iOS, this line will not affected

    MFSDK.setUpAppBar(isShowAppBar: false);
  }

  void initiateSession() {
    MFSDK.initiateSession((MFResult<MFInitiateSessionResponse> result) => {
          if (result.isSuccess())
            {mfPaymentCardView.load(result.response)}
          else
            {
              setState(() {
                print(
                    "Response: " + result.error.toJson().toString().toString());
                _response = result.error.message;
              })
            }
        });
  }

  void payWithEmbeddedPayment() {
    double totalPrice = double.parse(_appState.cartTotalPrice);
    var request =
        MFInitiatePaymentRequest(totalPrice, MFCurrencyISO.UNITED_STATE_USD);

    MFSDK.initiatePayment(
        request,
        MFAPILanguage.EN,
        (MFResult<MFInitiatePaymentResponse> result) => {
              if (result.isSuccess())
                {print(result.response.toJson().toString())}
              else
                {print(result.error.message)}
            });
    var request1 = MFExecutePaymentRequest.constructor(totalPrice);

    mfPaymentCardView.pay(
        request1,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    print("Response: " + result.response.toJson().toString());
                    _response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print("invoiceId: " + invoiceId);
                    print("Error: " + result.error.toJson().toString());
                    _response = result.error.message;
                  })
                }
            });
  }

  void getPaymentStatus() {
    var request = MFPaymentStatusRequest(invoiceId: "1209756"); // 1209773

    MFSDK.getPaymentStatus(
        MFAPILanguage.EN,
        request,
        (MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print("Response: " + result.response.toJson().toString());
                    _response = result.response.toJson().toString().toString();
                  })
                }
              else
                {
                  setState(() {
                    print("Response: " + result.error.toJson().toString());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          AppLocalizations.of(context).paymentpage_pdetail,
          style: const TextStyle(color: Colors.black),
        ),
        leadingAction: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(bottom: 25),
            height: MediaQuery.of(context).size.height - 150,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: createPaymentCardView(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).paymentpage_subtotal,
                            style: const TextStyle(
                              fontFamily: 'Avenir Next',
                              fontSize: 14,
                              color: Color(0xff999999),
                            ),
                          ),
                          Text(
                            "\$" + _appState.cartTotalPrice ?? "0",
                            style: const TextStyle(
                              fontFamily: 'Avenir Next',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1d1d1d),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          payWithEmbeddedPayment();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff283488)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(83.0),
                              side: const BorderSide(color: Color(0xff283488)),
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context).paymentpage_confirm,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   child: Text('Pay (Embedded Payment)'),
                    //   onPressed: payWithEmbeddedPayment,
                    // ),
                    // ElevatedButton(
                    //   child: Text('Get Payment Status'),
                    //   onPressed: getPaymentStatus,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        _response,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createPaymentCardView() {
    mfPaymentCardView = MFPaymentCardView(
//      inputColor: Colors.red,
//      labelColor: Colors.yellow,
//      errorColor: Colors.blue,
//      borderColor: Colors.green,
//      fontSize: 14,
//      borderWidth: 1,
//      borderRadius: 10,
//      cardHeight: 220,
//      cardHolderNameHint: "card holder name hint",
//      cardNumberHint: "card number hint",
//      expiryDateHint: "expiry date hint",
//      cvvHint: "cvv hint",
//      showLabels: true,
//      cardHolderNameLabel: "card holder name label",
//      cardNumberLabel: "card number label",
//      expiryDateLabel: "expiry date label",
//      cvvLabel: "cvv label",
        );

    return mfPaymentCardView;
  }
}
