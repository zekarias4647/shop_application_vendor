import 'dart:io';
import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_application_vendor/firebase_services.dart';
import 'package:shop_application_vendor/screen/landing_screen.dart';



class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseServices _services =FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _email = TextEditingController();
  final _gstNumber = TextEditingController();
  final _pinCode = TextEditingController();
  final _landMark= TextEditingController();
  String? _bName;
  String? _taxStatus;
  XFile? _shopImage;
  XFile? _logo;
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? address = "";
  String? _shopImageUrl;
  String? _logoUrl;

  final ImagePicker _picker = ImagePicker();

  Widget _formField({TextEditingController? controller, String? label,TextInputType? type,String? Function(String?)? validation}){
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixText:controller == _contactNumber ? '+251' : null,
      ),
      validator: validation,
      onChanged: (value){
       if(controller==_businessName){
         setState((){
           _bName=value;
         });
       }
      },
    );
  }

  Future<XFile?>_pickImage()async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  _scaffold(message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,),action: SnackBarAction(
      label: 'OK',
      onPressed: (){
        ScaffoldMessenger.of(context).clearSnackBars();
      },
    ),));
  }

  _saveToDB(){
    if(_shopImage==null){
      _scaffold('Shop Image not selected');
      return;
    }
    if(_logo==null){
      _scaffold('Shop logo image not selected');
      return;
    }

    if(_formKey.currentState!.validate()){
      if(countryValue==null||stateValue==null||cityValue==null){
        _scaffold('Select address field completely');
        return;
      }
      EasyLoading.show(status: 'Please wait ....');
      _services.uploadImage(_shopImage, 'vendors/${_services.user!.uid}/shopImage.jpg').then((String? url){
        if(url!=null){
          setState((){
            _shopImageUrl = url;
          });
        }
      }).then((value){
        _services.uploadImage(_logo, 'vendors/${_services.user!.uid}/logo.jpg').then((url){
          setState((){
            _logoUrl = url;
          });
        }).then((value) {
          _services.addVendor(
              data: {
                'shopImage':_shopImageUrl,
                'logo':_logoUrl,
                'businessName':_businessName.text,
                'mobile':'+251${_contactNumber.text}',
                'email' :_email.text,
                'taxRegistered' : _taxStatus,
                'tinNumber':_gstNumber.text.isEmpty?null:_gstNumber.text,
                'pinCode':_pinCode.text,
                'landMark':_landMark.text,
                'country':countryValue,
                'state':stateValue,
                'city':cityValue,
                'approved': false,
                'uid':_services.user!.uid,
                'time':DateTime.now()

              }
          ).then((value) {
            EasyLoading.dismiss();
            return Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const LandingScreen()));
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primary =  const Color(0xffC8B7A6);
    Color secondary= const Color(0xff2B3336);

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: primary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 240,
                child: Stack (
                  children: [
                    _shopImage==null?
                    Container(
                      color: secondary,
                      height: 240,
                      child: TextButton(
                        child: Center(
                          child: Text(
                            'Tap to add shop image',
                            style: TextStyle(color: primary),
                          ),
                        ),
                        onPressed: (){
                            _pickImage().then((value){
                              setState((){
                                _shopImage = value;
                              });
                            });
                        },
                      ),
                    ):InkWell(
                      onTap: (){
                        _pickImage().then((value){
                          setState((){
                            _shopImage = value;
                          });
                        });
                      },
                      child: Container(
                        height: 240,
                        decoration: BoxDecoration(
                          color: secondary,
                          image: DecorationImage(
                            opacity: 80,
                            image: FileImage(File(_shopImage!.path),),
                            fit: BoxFit.cover,

                          )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        actions: [
                          IconButton(
                              icon: const Icon(Icons.exit_to_app),color: Colors.white,
                              onPressed: (){
                                FirebaseAuth.instance.signOut();
                              }),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             InkWell(
                               onTap: (){
                                 _pickImage().then((value){
                                   setState((){
                                     _logo = value;
                                   });
                                 });
                               },
                               child: Card(
                                elevation: 4,
                                child: _logo == null ? const SizedBox(
                                  height: 50,
                                    width: 50,
                                    child: Center(
                                        child: Text('+'),
                                            ),
                                    ):ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.file(File(_logo!.path),),
                                ),
                                    )
                            ),
                             ),
                            const SizedBox(width: 10,),
                            Text(
                              _bName==null ? ' ': _bName!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                              fontSize:20 ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],

                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                children: [
                  _formField(
                    controller: _businessName,
                    label: 'Business Name',
                    type: TextInputType.text,
                    validation: (value){
                      if(value!.isEmpty){
                        return 'Enter Business Name';
                      }
                    }
                  ),

                  _formField(
                      controller: _contactNumber,
                      label: 'Contact number',
                      type: TextInputType.phone,
                      validation: (value){
                        if(value!.isEmpty){
                          return 'Enter Contact number';
                        }
                      }
                  ),

                  _formField(
                      controller: _email,
                      label: 'Email Address',
                      type: TextInputType.emailAddress,
                      validation: (value){
                        if(value!.isEmpty){
                          return 'Enter Email Address';
                        }
                         bool _isValid = (EmailValidator.validate(value));
                        if(_isValid==false){
                          return 'Invalid Email';
                        }
                      }
                  ),


                  const SizedBox(height: 10,),

                  Row(
                    children: [
                      const Text('Tax Registered : '),
                     Expanded(
                       child: DropdownButtonFormField(
                           value: _taxStatus,
                           validator: (String? value){
                             if(value==null){
                               return "Select Tax status";
                             }
                           },
                           hint: const Text('Select'),
                           items:  <String>['Yes', 'No']
                               .map<DropdownMenuItem<String>>((String value) {
                             return DropdownMenuItem<String>(
                               value: value,
                               child: Text(value),
                             );
                           }).toList(),
                           onChanged: (String? value){
                             setState((){
                               _taxStatus=value;
                             });
                       }),
                     )
                    ],
                  ),
                  if(_taxStatus=="Yes")
                    _formField(
                        controller: _gstNumber,
                        label: 'GST Number',
                        type: TextInputType.number,
                        validation: (value){
                          if(value!.isEmpty){
                            return 'Enter GST Number';
                          }

                        }
                    ),

                  _formField(
                      controller: _pinCode,
                      label: 'PIN Code',
                      type: TextInputType.number,
                      validation: (value){
                        if(value!.isEmpty){
                          return 'Enter PIN Code';
                        }
                      }
                  ),

                  _formField(
                      controller: _landMark,
                      label: 'Landmark',
                      type: TextInputType.text,
                      validation: (value){
                        if(value!.isEmpty){
                          return 'Enter a Landmark';
                        }
                      }
                  ),
                  const SizedBox(height: 20,),
                  CSCPicker(
                    ///Enable disable state dropdown [OPTIONAL PARAMETER]
                    showStates: true,

                    /// Enable disable city drop down [OPTIONAL PARAMETER]
                    showCities: true,

                    ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                    flagState: CountryFlag.ENABLE,

                    ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                    dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: secondary,
                        border:
                        Border.all(color: secondary, width: 1)),

                    ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                    disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color:secondary,
                        border:
                        Border.all(color: secondary, width: 1)),

                    ///placeholders for dropdown search field
                    countrySearchPlaceholder: "Country",
                    stateSearchPlaceholder: "State",
                    citySearchPlaceholder: "City",

                    ///labels for dropdown
                    countryDropdownLabel: "*Country",
                    stateDropdownLabel: "*State",
                    cityDropdownLabel: "*City",

                    ///Default Country
                    defaultCountry: DefaultCountry.Ethiopia,

                    ///Disable country dropdown (Note: use it with default country)
                    //disableCountry: true,

                    ///selected item style [OPTIONAL PARAMETER]
                    selectedItemStyle: TextStyle(
                      color: primary,
                      fontSize: 14,
                    ),

                    ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                    dropdownHeadingStyle: TextStyle(
                        color: primary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),

                    ///DropdownDialog Item style [OPTIONAL PARAMETER]
                    dropdownItemStyle: TextStyle(
                      color: primary,
                      fontSize: 14,
                    ),

                    ///Dialog box radius [OPTIONAL PARAMETER]
                    dropdownDialogRadius: 10.0,

                    ///Search bar radius [OPTIONAL PARAMETER]
                    searchBarRadius: 10.0,

                    ///triggers once country selected in dropdown
                    onCountryChanged: (value) {
                      setState(() {
                        ///store value in country variable
                        countryValue = value;
                      });
                    },

                    ///triggers once state selected in dropdown
                    onStateChanged: (value) {
                      setState(() {
                        ///store value in state variable
                        stateValue = value;
                      });
                    },

                    ///triggers once city selected in dropdown
                    onCityChanged: (value) {
                      setState(() {
                        ///store value in city variable
                        cityValue = value;
                      });
                    },
                  ),
                ],
              ),
              )
            ],
          ),
        ),
        persistentFooterButtons:[
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding:  const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        child: const Text('Register'),
                        onPressed:_saveToDB,
                    ),

                  ))
            ],
          ),

        ],
      ),
    );
  }
}
