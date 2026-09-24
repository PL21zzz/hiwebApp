enum RequestStatus {
  initial,
  loading,
  refreshing,
  success,
  empty,
  error,
}

class AsyncState<T> {
  const AsyncState({
    required this.status,
    this.data,
    this.errorMessage,
  });

  const AsyncState.initial() : this(status: RequestStatus.initial);

  factory AsyncState.success(T value) => AsyncState<T>(
        status: value is Iterable && value.isEmpty
            ? RequestStatus.empty
            : RequestStatus.success,
        data: value,
      );

  final RequestStatus status;
  final T? data;
  final String? errorMessage;

  bool get isLoading =>
      status == RequestStatus.loading || status == RequestStatus.refreshing;
  bool get hasData => data != null;
  bool get hasError => status == RequestStatus.error;

  AsyncState<T> loading({bool keepData = true}) => AsyncState<T>(
        status: keepData && data != null
            ? RequestStatus.refreshing
            : RequestStatus.loading,
        data: keepData ? data : null,
      );

  AsyncState<T> withSuccess(T value) => AsyncState.success(value);

  AsyncState<T> error(String message, {T? fallbackData}) => AsyncState<T>(
        status: RequestStatus.error,
        data: fallbackData ?? data,
        errorMessage: message,
      );
}
