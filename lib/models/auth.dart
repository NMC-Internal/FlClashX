// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/auth.freezed.dart';
part 'generated/auth.g.dart';

/// Authenticated session returned by the backend after login/register
/// followed by a `GET /v1/me` lookup.
@freezed
class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String token,
    @Default("") String email,
    @Default("") String subscriptionUrl,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, Object?> json) =>
      _$AuthSessionFromJson(json);
}
