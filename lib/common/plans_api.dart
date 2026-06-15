import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flclashx/common/constant.dart';
import 'package:flclashx/models/models.dart';

/// Thin client for the PUBLIC plan catalog `GET /v1/plans` (ADR 0010).
///
/// Unauthenticated by design — guests browse plans before signing in — so this
/// uses its own [Dio] with no Authorization header.
class PlansApi {
  PlansApi({Dio? dio, String? baseUrl})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? backendBaseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                responseType: ResponseType.json,
                validateStatus: (_) => true,
              ),
            );

  final Dio _dio;

  /// Returns the visible plan catalog ordered by sort order. Throws on
  /// network/server failure so callers can surface a retry state.
  Future<List<Plan>> list() async {
    final response = await _dio.get<dynamic>('/v1/plans');
    if ((response.statusCode ?? 0) != HttpStatus.ok) {
      throw Exception('PlansApi - list - HTTP ${response.statusCode}');
    }
    final data = response.data;
    if (data is! Map) {
      throw Exception('PlansApi - list - unexpected body');
    }
    final raw = data['plans'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Plan.fromJson(Map<String, Object?>.from(e)))
        .toList();
  }
}

final plansApi = PlansApi();
