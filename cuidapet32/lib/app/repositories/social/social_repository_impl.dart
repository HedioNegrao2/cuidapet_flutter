
import 'package:cuidapet32/app/models/social_network_model.dart';
import 'package:cuidapet32/app/repositories/social/social_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialRepositoryImpl implements SocialRepository{
  @override
  Future<SocialNetworkModel> facebookLogin() {
    // TODO: implement facebookLogin
    throw UnimplementedError();
  }

  @override
  Future<SocialNetworkModel> googleLogin() async {
    final googleSingIn = GoogleSignIn();

    if (await googleSingIn.isSignedIn()){
      await googleSingIn.disconnect();
    }

    final googleUser =  await googleSingIn.signIn();
    final googleAuth = await googleUser?.authentication;
    if (googleAuth != null && googleUser != null){
      return SocialNetworkModel(
        
        id: googleAuth.idToken ?? '',
        name: googleUser.displayName ?? '',
        email: googleUser.email,
        type: 'Google',
        avatar: googleUser.photoUrl ?? '',
        accessToken: googleAuth.accessToken ?? '',
      );
    } 
    else{
      throw Exception('Erro ao realizar login com Google');
    }

  }
  
}