
import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';



class JwtHelper {
  static final String _jwtSecret = env['jwt.secret']?? env['jwtSecret']!; 

  JwtHelper._();

  static String genereteJWT(int userId, int? supplierId) {
    final claimsSet = JwtClaim(
      issuer: 'cuidapet',
      subject: userId.toString(),
      expiry: DateTime.now().add(const Duration(days: 1)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
      
      otherClaims: <String, dynamic>{
        'supplier': supplierId,
      },
      maxAge: const Duration(days: 1),
    );
       return  'Bearer ${issueJwtHS256(claimsSet, _jwtSecret)}';   
  } 
  
  static JwtClaim getClaims(String token) {
    return verifyJwtHS256Signature(token, _jwtSecret);
   }

}