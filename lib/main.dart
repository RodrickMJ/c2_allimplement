import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/http_client.dart';

import 'feature/auth/data/datasource/service_auth.dart';
import 'feature/auth/data/repository/auth_repository_impl.dart';
import 'feature/auth/domain/usecase/login.dart';
import 'feature/auth/domain/usecase/register.dart';
import 'feature/auth/presentation/providers/auth_provider.dart';

import 'feature/home/data/datasource/service_clients.dart';
import 'feature/home/data/repository/client_repository_impl.dart';
import 'feature/home/domain/usecase/get_clients.dart';
import 'feature/home/domain/usecase/create_client_and_loan.dart';
import 'feature/home/domain/usecase/delete_client.dart';
import 'feature/home/presentation/providers/clients_provider.dart';

import 'myapp.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  final httpClient = HttpClient().client;

  final authService = ServiceAuthImpl(); 
  final authRepository = AuthRepositoryImpl(authService);
  final loginUseCase = Login(authRepository);
  final registerUseCase = Register(authRepository);

  final clientRemoteDataSource = ClientRemoteDataSourceImpl(
    client: httpClient,
    baseUrl: 'https://aspas.space',
  );

  final clientRepository = ClientRepositoryImpl(clientRemoteDataSource);
  final getClientsUseCase = GetClients(clientRepository);
  final createClientUseCase = CreateClientAndLoan(clientRepository);
  final deleteClientUseCase = DeleteClient(clientRepository);

   final sessionConfig = SessionConfig(
    invalidateSessionForAppLostFocus: Duration(seconds: 20),
    invalidateSessionForUserInactivity: Duration(seconds: 20),
  );


  runApp(
    MultiProvider(
      providers: [
        Provider<SessionConfig>.value(value: sessionConfig),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientsProvider(
            getClients: getClientsUseCase,
            createClientAndLoan: createClientUseCase,
            deleteClient: deleteClientUseCase,
          ),
        ),
      ],child: SessionTimeoutManager(
        sessionConfig: sessionConfig,
        child: const MyApp()
    //      child: DevicePreview(
    //       enabled: kDebugMode,
    //       builder: (context) => const MyApp(),
    // ),
      )
    )
  );
}
