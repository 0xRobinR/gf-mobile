import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';

Uint8List deriveKey(String password, Uint8List salt) {
  var pkcs = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
    ..init(Pbkdf2Parameters(salt, 1000, 32));
  return pkcs.process(Uint8List.fromList(utf8.encode(password)));
}

String encrypt(String plainText, String password) {
  final salt = Uint8List.fromList(List.generate(16, (index) => index));
  final key = deriveKey(password, salt);

  final iv = Uint8List(16);
  final params = ParametersWithIV<KeyParameter>(KeyParameter(key), iv);

  final cipher =
      PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESFastEngine()))
        ..init(
            true,
            params as PaddedBlockCipherParameters<CipherParameters?,
                CipherParameters?>);

  final inputBytes = utf8.encode(plainText);
  final encrypted = cipher.process(Uint8List.fromList(inputBytes));
  final encodedEncryptedData = base64Encode(encrypted);
  final encodedSalt = base64Encode(salt);

  return '$encodedEncryptedData:$encodedSalt';
}

String decrypt(String encryptedDataWithSalt, String password) {
  final parts = encryptedDataWithSalt.split(':');
  final encryptedData = base64Decode(parts[0]);
  final salt = base64Decode(parts[1]);

  final key = deriveKey(password, salt);

  final iv = Uint8List(16);
  final params = ParametersWithIV<KeyParameter>(KeyParameter(key), iv);

  final cipher =
      PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESFastEngine()))
        ..init(
            false,
            params as PaddedBlockCipherParameters<CipherParameters?,
                CipherParameters?>);

  final decrypted = cipher.process(Uint8List.fromList(encryptedData));
  return utf8.decode(decrypted);
}

String generateMD5Hash(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
