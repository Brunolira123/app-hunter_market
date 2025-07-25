import 'package:permission_handler/permission_handler.dart';

Future<void> solicitarPermissoesLocalizacao() async {
  // Solicita as permissões necessárias
  final statusFine = await Permission.location.request();
  final statusCoarse = await Permission.locationWhenInUse.request();
  final statusBackground = await Permission.locationAlways.request();

  if (statusFine.isGranted && statusBackground.isGranted) {
    print('✅ Permissões de localização concedidas!');
  } else if (statusFine.isPermanentlyDenied ||
      statusBackground.isPermanentlyDenied) {
    openAppSettings(); // Abre configurações caso o usuário tenha negado permanentemente
  } else {
    print('❌ Permissões negadas.');
  }
}
