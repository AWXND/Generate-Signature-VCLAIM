import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() {
  String consid = '';
  String secretKey = '';
  String userkey = '';

  MembuatSignature bpjs =
      MembuatSignature(consid: consid, secretKey: secretKey, userkey: userkey);

  String timeStamp = bpjs.timeStamp();

  String signature = bpjs.generateHmacSignatue(consid, timeStamp, secretKey);

  String encodedSignature = base64Encode(utf8.encode(signature));

  print("X-cons-id: $consid");
  print("X-timestamp: $timeStamp");
  print("X-signature: $encodedSignature");
  print("X-Userkey : $userkey");
}

class MembuatSignature {
  final String consid;
  final String secretKey;
  final String userkey;

  MembuatSignature(
      {required this.consid, required this.secretKey, required this.userkey});

  //generate hmac
  String generateHmacSignatue(
      String consid, String timestamp, String secretkey) {
    String toSign = '$consid&$timestamp';

    var key = utf8.encode(toSign);
    var bytes = utf8.encode(consid);

    var hmac = Hmac(sha256, key);
    var digest = hmac.convert(bytes);

    return digest.toString();
  }

  //generate timestamp

  String timeStamp() {
    DateTime now = DateTime.now().toUtc();
    int timestamp = now.millisecondsSinceEpoch ~/ 1000;
    return timestamp.toString();
  }
}
