


String? validateName(String? value) {
  String pattern = r'[!@#<>?":_`~;[\]\\|=+"′″€₹£)(*&^%0-9-]';
  String patternS = r"[']";
  RegExp regExp = new RegExp(pattern);
  RegExp regExpS = new RegExp(patternS);
  if (value!.length == 0) {
    return "Please enter Name";
  } else if (value.length < 2) {
    return "Name require atleast 2 characters";
  } else if (regExp.hasMatch(value)) {
    return "Special characters are not allowed in name";
  } else if (regExpS.hasMatch(value)) {
    return "Special characters are not allowed in name";
  }
  return null;
}

String? validateEmail(String? value) {
  final validCharacters = RegExp(
      r'^(([^<>()[\]\\...,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value!.length == 0) {
    return "Please enter your Email";
  } else if (!validCharacters.hasMatch(value)) {
    return "Invalid email";
  }
}

String? validateMobile(String? value) {
  final patttern = RegExp(r'(^[6-9][0-9]*$)');
  if (value!.length == 0) {
    return "Please enter Mobile Number";
  } else if (value.length != 10) {
    return "Mobile number must 10 digits";
  } else if (!patttern.hasMatch(value)) {
    return "Please enter valid Mobile Number";
  }
  return null;
}

String? validatePassword(String? value) {
  if (value!.length == 0) {
    return "Please enter Password";
  } else if (value.length < 4) {
    return "Password require atleast 4 characters";
  }
  return null;
}

String? validateHouse(String value) {
  if (value.length == 0) {
    return "Please Enter house number";
  }
  return null;
}

String? validateCommon(String? value) {
  if (value?.length == 0) {
    return "Please Enter Required Field";
  }
  return null;
}

String? validateSociety(String value) {
  if (value.length == 0) {
    return "Please Enter society name";
  }
  return null;
}

String? validateAddress(String value) {
  if (value.length == 0) {
    return "Please Enter street address";
  }
  return null;
}

String? validatePincode(String value) {
  if (value.length != 6 || value == "000000") {
    return "Enter 6-digit pincode";
  }
  return null;
}

String? validatePostcode(String value) {
  String patttern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Please enter Postcode";
  } else if (value.length != 6) {
    return "Enter 6-digit postcode";
  } else if (!regExp.hasMatch(value)) {
    return "Postcode must be digits";
  }
  return null;
}

String? validateMessage(String value) {
  if (value.length == 0) {
    return "Please enter your Message";
  }
  return null;
}

String? validateCity(String value) {
  if (value.length == 0) {
    return "Please enter City Name";
  }
  return null;
}

String? validateLastName(String value) {
  String pattern =  r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Please enter Last Name";
  } else if (value.length < 2) {
    return "Please enter at least 2 characters";
  }
  else if (regExp.hasMatch(value)) {
    return "Special characters and number are not allowed in name";
  }
  return null;
}

String? validateOrderId(String value) {
  if (value.length == 0) {
    return "Order Id Required";
  }
  return null;
}

String? validateEmailPhone(String value) {
  if (value.length == 0) {
    return "Enter order email or phone number";
  }
  return null;
}

