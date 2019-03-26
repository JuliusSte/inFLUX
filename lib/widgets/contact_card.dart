import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({Key key}) : super(key: key);

  @override
  ContactCardState createState() {
    return new ContactCardState();
  }
}

class ContactCardState extends State<ContactCard> {
  var issueFormKey = GlobalKey<FormFieldState>();
  var contactDetailsFormKey = GlobalKey<FormState>();
  FocusScopeNode cardFocus;
  FocusNode phoneNumberFocusNode;
  FocusNode issueFocusNode;

  String email;
  bool autoValidateMail = false;
  final emailFormFieldKey = GlobalKey<FormFieldState>();

  String phoneNumber;
  bool autoValidatePhone = false;
  final phoneFormFieldKey = GlobalKey<FormFieldState>();

  String issue;
  bool autoValidateIssue = false;
  bool showMessageForm = false;

  void initState() {
    super.initState();
    this.phoneNumberFocusNode = FocusNode();
    this.issueFocusNode = FocusNode();
    this.cardFocus = FocusScopeNode();
  }

  @override
  void dispose() {
    this.phoneNumberFocusNode.dispose();
    this.issueFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text("Let's get in contact.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            AnimatedCrossFade(
              firstChild: Form(
                key: contactDetailsFormKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(FontAwesomeIcons.envelope,
                              size: 24, color: Colors.white),
                        ),
                        Expanded(
                          child: TextFormField(
                              key: emailFormFieldKey,
                              autovalidate: autoValidateMail,
                              validator: (text) =>
                                  RegExp("^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$")
                                              .stringMatch(text) ==
                                          text
                                      ? null
                                      : "Please enter a valid e-mail",
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              maxLength: 50,
                              onFieldSubmitted: (text) {
                                if (emailFormFieldKey.currentState.validate()) {
                                  FocusScope.of(context)
                                      .requestFocus(phoneNumberFocusNode);
                                } else {
                                  this.setState(
                                      () => this.autoValidateMail = true);
                                }
                              },
                              onSaved: (email) => this.email = email,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              keyboardType: TextInputType.emailAddress,
                              decoration: _buildFormFieldDecoration("E-Mail")),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(FontAwesomeIcons.phoneVolume,
                              size: 24, color: Colors.white),
                        ),
                        Expanded(
                            child: TextFormField(
                          key: phoneFormFieldKey,
                          autovalidate: autoValidatePhone,
                          validator: (text) => (text.length > 5 &&
                                  RegExp("^[0-9]*\$").stringMatch(text) == text)
                              ? null
                              : "Please enter a valid phone number",
                          focusNode: phoneNumberFocusNode,
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          maxLength: 20,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          keyboardType: TextInputType.phone,
                          decoration: _buildFormFieldDecoration("Phone number"),
                          onFieldSubmitted: (text) {
                            if (phoneFormFieldKey.currentState.validate()) {
                              // do nothing
                              phoneNumberFocusNode.unfocus();
                            } else {
                              FocusScope.of(context)
                                  .requestFocus(phoneNumberFocusNode);
                              this.setState(
                                  () => this.autoValidatePhone = true);
                            }
                          },
                          onSaved: (phoneNumber) =>
                              this.phoneNumber = phoneNumber,
                        )),
                      ],
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      child: new RaisedButton(
                        color: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        onPressed: () {
                          if (!contactDetailsFormKey.currentState.validate()) {
                            this.setState(() {
                              autoValidateMail = true;
                              autoValidatePhone = true;
                            });
                          } else {
                            contactDetailsFormKey.currentState.save();
                            FocusScope.of(context).requestFocus(issueFocusNode);
                            this.setState(() {
                              this.showMessageForm = true;
                            });
                          }
                        },
                        child: Center(
                            child: Text("Next",
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 18,
                                    letterSpacing: 1.5))),
                      ),
                    )
                  ],
                ),
              ),
              secondChild: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autovalidate: autoValidateIssue,
                    validator: (text) =>
                        text.length > 0 ? null : "Please enter a message",
                    key: issueFormKey,
                    focusNode: issueFocusNode,
                    textInputAction: TextInputAction.done,
                    maxLines: 5,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Tell us about your issue \u{1f60A}',
                        border: InputBorder.none),
                    onSaved: (issue) => this.issue = issue,
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: new RaisedButton(
                      color: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () {
                        if (issueFormKey.currentState.validate()) {
                          issueFormKey.currentState.save();
                          print(
                              "saving data... email: ${this.email}, phone number: ${this.phoneNumber}, issue: ${this.issue}");
                        } else {
                          this.setState(() => this.autoValidateIssue = true);
                        }
                      },
                      child: Center(
                          child: Text("Send",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 18,
                                  letterSpacing: 1.5))),
                    ),
                  )
                ],
              )),
              duration: Duration(milliseconds: 1500),
              crossFadeState: showMessageForm
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }

  _buildFormFieldDecoration(String text) {
    return InputDecoration(
        labelText: text,
        labelStyle: TextStyle(
            decorationColor: Colors.white,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18),
        counterStyle: TextStyle(color: Colors.white),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
  }
}
