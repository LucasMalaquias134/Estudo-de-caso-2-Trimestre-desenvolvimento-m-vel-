import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextfieldPesquisar extends StatelessWidget {
  final double? largura;
  final IconData? icone;
  final String placeHolder;
  final String? placeHolder2;
  final bool? eSenha;
  final TextEditingController controller;
  final bool? numerico;
  final String? Function(String?)? validador;
  final Function(String?)? enviado;
  final bool? labelFlutante;
  final bool? temaEscuro;
  final bool? temRadius;
  final double? radius;
  final Color? backgroundCor;

  const TextfieldPesquisar({
    super.key,
    this.largura,
    this.icone,
    required this.placeHolder,
    this.placeHolder2,
    this.eSenha,
    this.numerico,
    required this.controller,
    this.validador,
    this.enviado,
    this.labelFlutante,
    this.temaEscuro,
    this.temRadius,
    this.radius,
    this.backgroundCor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      color: Colors.transparent,
      child: numerico == true
          ? TextFormField(
              onFieldSubmitted: enviado,
              validator: validador,
              style: TextStyle(
                color: temaEscuro == true ? Colors.black : Colors.white,

                fontSize: 14,
              ),
              decoration: InputDecoration(
                filled: (backgroundCor != null) ? true : false,
                fillColor: (backgroundCor != null)
                    ? backgroundCor
                    : Colors.transparent,
                floatingLabelBehavior: labelFlutante == true
                    ? FloatingLabelBehavior.always
                    : null,
                prefixIcon: icone != null
                    ? Icon(
                        icone,
                        color: temaEscuro == true ? Colors.black : Colors.white,
                      )
                    : null,
                labelText: placeHolder,
                labelStyle: TextStyle(
                  color: temaEscuro == true
                      ? Colors.black.withValues(alpha: 0.7)
                      : Colors.white,

                  fontSize: 18,
                ),
                hintText: placeHolder2 != null ? placeHolder2 : placeHolder,
                hintStyle: TextStyle(
                  color: temaEscuro == true
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.4),

                  fontSize: 14,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: temRadius == true
                      ? BorderRadius.circular(radius!)
                      : BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.indigo),
                ),
                border: OutlineInputBorder(
                  borderRadius: temRadius == true
                      ? BorderRadius.circular(radius!)
                      : BorderRadius.circular(15),
                ),
              ),
              cursorColor: Colors.indigo,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9\-+]*$')),
              ],
              obscureText: eSenha == null ? false : true,
              controller: controller,
            )
          : TextFormField(
              onFieldSubmitted: enviado,
              validator: validador,
              style: TextStyle(
                color: temaEscuro == true ? Colors.black : Colors.white,

                fontSize: 14,
              ),
              decoration: InputDecoration(
                filled: (backgroundCor != null) ? true : false,
                fillColor: (backgroundCor != null)
                    ? backgroundCor
                    : Colors.transparent,
                floatingLabelBehavior: labelFlutante == true
                    ? FloatingLabelBehavior.always
                    : null,
                prefixIcon: icone != null
                    ? Icon(
                        icone,
                        color: temaEscuro == true ? Colors.black : Colors.white,
                      )
                    : null,
                labelText: placeHolder,
                labelStyle: TextStyle(
                  color: temaEscuro == true
                      ? Colors.black.withValues(alpha: 0.7)
                      : Colors.white,

                  fontSize: 18,
                ),
                hintText: placeHolder2 != null ? placeHolder2 : placeHolder,
                hintStyle: TextStyle(
                  color: temaEscuro == true
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.4),

                  fontSize: 14,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: temRadius == true
                      ? BorderRadius.circular(radius!)
                      : BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.indigo),
                ),
                border: OutlineInputBorder(
                  borderRadius: temRadius == true
                      ? BorderRadius.circular(radius!)
                      : BorderRadius.circular(15),
                ),
              ),
              cursorColor: Colors.indigo,
              obscureText: eSenha == null ? false : true,
              controller: controller,
            ),
    );
  }
}

class SalvarContato extends StatelessWidget {
  final VoidCallback funcao;
  final String texto;
  const SalvarContato({required this.funcao, required this.texto, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: funcao,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 187, 167, 255),
      ),
      child: Text(
        texto,
        style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
      ),
    );
  }
}
