import 'package:get_it/get_it.dart';
import 'package:travel_hour/manager/address_manager.dart';
import 'package:travel_hour/manager/api_manager.dart';
import 'package:travel_hour/manager/controller_manager.dart';
import 'package:travel_hour/manager/jwt_manager.dart';
import 'package:travel_hour/manager/keycloak_manager.dart';
import 'package:travel_hour/services/wallet_connect/chains/evm_service.dart';
import 'package:travel_hour/services/wallet_connect/chains/i_chain.dart';
import 'package:travel_hour/services/wallet_connect/i_web3wallet_service.dart';
import 'package:travel_hour/services/wallet_connect/web3wallet_service.dart';


Future<void> getItSetter() async {
    GetIt.instance.registerSingleton<Keycloak>(Keycloak());
    GetIt.instance.registerSingleton<JWTManager>(JWTManager());
    GetIt.instance.registerSingleton<APIManager>(APIManager());
    GetIt.instance.registerSingleton(ControllerManager());

    AddressManager addressManager = AddressManager();
    await addressManager.initMainCode();

    GetIt.instance.registerSingleton<AddressManager>(addressManager);

    final IWeb3WalletService web3WalletService = Web3WalletService();
    web3WalletService.create();
    GetIt.I.registerSingleton<IWeb3WalletService>(web3WalletService);

    // for (final cId in KadenaChainId.values) {
    //   GetIt.I.registerSingleton<IChain>(
    //     KadenaService(reference: cId),
    //     instanceName: cId.chain,
    //   );
    // }
    //

    for (final cId in EVMChainId.values) {
        GetIt.I.registerSingleton<IChain>(
            EVMService(reference: cId),
            instanceName: cId.chain(),
        );
    }

    await web3WalletService.init();


}