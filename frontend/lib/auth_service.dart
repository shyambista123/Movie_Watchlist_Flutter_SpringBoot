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
        // Decode the token to get the payload
        Map<String, dynamic> payload = Jwt.parseJwt(token);

        // Extract the expiration date from the payload
        DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

        // Check if the token is expired
        if (expirationDate.isBefore(DateTime.now())) {
          await deleteToken();
        }
      } catch (e) {
        // Handle error if token is invalid or decoding fails
        print("Error decoding token: $e");
        await deleteToken();
      }
    }
  }
}
