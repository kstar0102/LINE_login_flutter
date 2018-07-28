import 'package:flutter/services.dart';

class FlutterLineLogin {
  static const MethodChannel _methodChannel =
      const MethodChannel('net.granoeste/flutter_line_login');
  static const EventChannel _eventChannel =
      const EventChannel('net.granoeste/flutter_line_login_result');

  FlutterLineLogin() {
    // Receive Login Result
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  Function _onLoginSuccess;
  Function _onLoginError;

  /// Success callback for LINE login result.
  ///
  /// Event is Map
  /// Attributes of LineProfile & LineCredential of LINE login result is set in map
  ///
  /// * userID - The user's user ID.
  /// * displayName - The user’s display name.
  /// * pictureUrl - The user’s profile media URL.
  /// * statusMessage - The user’s status message.
  /// * accessToken - User access token.
  /// * expiresIn - The amount of time in milliseconds until the user access token expires.
  /// * permissions - The set of permissions that the access token holds. The following is a list of the permission codes.
  void _onEvent(Object event) {
    _onLoginSuccess(event);
  }

  /// Error callback for LINE login result.
  ///
  /// Error is PlatformException
  /// Attributes of Error of LINE login result is set in PlatformException
  /// Content differs between Android and iOS.
  void _onError(Object error) {
    _onLoginError(error);
  }

  /// Start LINE login
  /// The result is obtained by a callback function.
  startLogin(Function onSuccess, Function onError) async {
    _onLoginSuccess = onSuccess;
    _onLoginError = onError;
    await _methodChannel.invokeMethod('startLogin');
  }

  /// Start LINE login with web
  /// The result is obtained by a callback function.
  startWebLogin(Function onSuccess, Function onError) async {
    _onLoginSuccess = onSuccess;
    _onLoginError = onError;
    await _methodChannel.invokeMethod('startWebLogin');
  }

  /// Logout
  /// If not login, throw PlatformException.
  logout() async {
    await _methodChannel.invokeMethod('logout');
  }

  /// Get Profile
  ///
  /// Return the map obtained from LineProfile.
  ///
  /// * userID - The user's user ID.
  /// * displayName - The user’s display name.
  /// * pictureUrl - The user’s profile media URL.
  /// * statusMessage - The user’s status message.
  ///
  /// If not login, throw PlatformException.
  getProfile() async {
    return await _methodChannel.invokeMethod('getProfile');
  }

  /// Get current access token
  ///
  /// Return a access token. If not login, return null.
  currentAccessToken() async {
    return await _methodChannel.invokeMethod('currentAccessToken');
  }

  /// Verify token
  /// Return null only. That means it is successful.
  /// If not login or error, throw PlatformException.
  verifyToken() async {
    return await _methodChannel.invokeMethod('verifyToken');
  }

  /// Refresh token
  ///
  /// Return the map obtained from LineAccessToken.
  ///
  /// * accessToken - User access token.
  /// * expiresIn - The amount of time in milliseconds until the user access token expires.
  ///
  /// If not login or error, throw PlatformException.
  refreshToken() async {
    return await _methodChannel.invokeMethod('refreshToken');
  }
}
