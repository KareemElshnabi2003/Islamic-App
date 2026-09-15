import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network_info.dart';
import 'network_state.dart';

class NetworkCubit extends Cubit<NetworkStatus> {
  final NetworkInfo networkInfo;

  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;

  NetworkCubit(this.networkInfo) : super(NetworkStatus.initial);

  Future<void> checkConnection() async {
    final isConnected = await networkInfo.isConnected;

    emit(
      isConnected
          ? NetworkStatus.connected
          : NetworkStatus.disconnected,
    );
  }

  void startListening() {
    _connectionSubscription?.cancel();

    _connectionSubscription = networkInfo.onStatusChange.listen(
          (status) {
        if (status == InternetConnectionStatus.connected) {
          emit(NetworkStatus.connected);
        } else {
          emit(NetworkStatus.disconnected);
        }
      },
    );
  }

  @override
  Future<void> close() {
    _connectionSubscription?.cancel();
    return super.close();
  }
}