import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// 6,022140x1023
//quimicappconexion@gmail.com

class EmailService {
  final String senderEmail = 'tu-correo@gmail.com';
  final String senderPassword = 'tu-contraseña';

  Future<void> sendEmail(String recipientEmail, String recipientName) async {
    final smtpServer = gmail(senderEmail, senderPassword);

    final message = Message()
      ..from = Address(senderEmail)
      ..recipients.add(recipientEmail)
      ..subject = 'Hola, $recipientName'
      ..text =
          'Este es un correo electrónico de prueba enviado desde nuestra aplicación Flutter.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Message not sent.');
      print(e.toString());
    }
  }
}
