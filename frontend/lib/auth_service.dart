import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<void> checkAndDeleteExpiredToken() async {
    String? token = await getToken();
    if (token != null) {
      try {
        Map<String, dynamic> payload = Jwt.parseJwt(token);

        DateTime expirationDate =
            DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

        if (expirationDate.isBefore(DateTime.now())) {
          await deleteToken();
        }
      } catch (e) {
        print("Error decoding token: $e");
        await deleteToken();
      }
    }
  }
}