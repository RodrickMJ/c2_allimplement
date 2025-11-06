// core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../feature/auth/data/datasource/service_auth.dart';
import '../../feature/auth/data/repository/auth_repository_impl.dart';
import '../../feature/auth/domain/repository/auth_repository.dart'; // ← INTERFACE
import '../../feature/auth/domain/usecase/login.dart';
import '../../feature/auth/domain/usecase/register.dart';
import '../../feature/auth/presentation/providers/auth_provider.dart';

import '../../feature/home/data/datasource/service_clients.dart';
import '../../feature/home/data/repository/client_repository_impl.dart';
import '../../feature/home/domain/repository/client_repository.dart'; // ← INTERFACE
import '../../feature/home/domain/usecase/get_clients.dart';
import '../../feature/home/domain/usecase/create_client_and_loan.dart';
import '../../feature/home/domain/usecase/delete_client.dart';
import '../../feature/home/presentation/providers/clients_provider.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // === AUTH ===
  getIt.registerLazySingleton<ServiceAuth>(() => ServiceAuthImpl());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt())); // ← INTERFAZ
  getIt.registerLazySingleton(() => Login(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => Register(getIt<AuthRepository>()));
  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(
      loginUseCase: getIt(),
      registerUseCase: getIt(),
    ),
  );

  // === CLIENTS ===
  getIt.registerLazySingleton<ClientRemoteDataSource>(
    () => ClientRemoteDataSourceImpl(
      client: getIt<http.Client>(),
      baseUrl: 'https://aspas.space',
    ),
  );
  getIt.registerLazySingleton<ClientRepository>(() => ClientRepositoryImpl(getIt())); // ← INTERFAZ
  getIt.registerLazySingleton(() => GetClients(getIt<ClientRepository>()));
  getIt.registerLazySingleton(() => CreateClientAndLoan(getIt<ClientRepository>()));
  getIt.registerLazySingleton(() => DeleteClient(getIt<ClientRepository>()));
  getIt.registerLazySingleton<ClientsProvider>(
    () => ClientsProvider(
      getClients: getIt(),
      createClientAndLoan: getIt(),
      deleteClient: getIt(),
    ),
  );
}