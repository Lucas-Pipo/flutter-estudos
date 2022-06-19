import 'package:flutter/material.dart';
import 'package:minhasnotas/utilidades/dialogos/dialogo_generico.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return mostrarDialogoGenerico(
    contexto: context,
    titulo: 'Redefinição de Senha',
    conteudo:
        'Nós enviamos um link de redefinição de senha. Por favor verifique o seu email para mais informações.',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
