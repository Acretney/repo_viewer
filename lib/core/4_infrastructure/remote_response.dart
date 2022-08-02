import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_response.freezed.dart';

// This class helps us determine whether to take data from the API or local database

@freezed
class RemoteResponse<T> with _$RemoteResponse<T> {
  const RemoteResponse._();
  // will use data from local storage but will also present popup saying info may be outdated
  const factory RemoteResponse.noConnection() = _NoConnection<T>;
  // will use data from local storage
  const factory RemoteResponse.notModified({required int maxPage}) =
      _NotModified<T>;
  // will perform API call
  const factory RemoteResponse.withNewData(T data, {required int maxPage}) =
      _WithNewData<T>;
}
