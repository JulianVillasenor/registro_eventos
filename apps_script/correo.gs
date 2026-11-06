
/**
 * Envía un correo de prueba con un QR adjunto.
 */
function probarCorreoConQR() {
  const email = "julianvillaseno@gmail.com";

  // UUID ficticio para nuestra prueba.
  const id = "550e8400-e29b-41d4-a716-446655440000";

  const imagenQR = generarImagenQR(id);

  const asunto = "Prueba de invitación con QR";

  const mensaje = `
Hola,

Tu código QR de acceso al evento está adjunto.

Presenta este código al ingresar al evento.

Identificador: ${id}

¡Te esperamos!

Equipo organizador
`;

  MailApp.sendEmail({
    to: email,
    subject: asunto,
    body: mensaje,
    attachments: [imagenQR],
    name: "Registro de Eventos"
  });

  console.log("Correo enviado a: " + email);
  console.log("QR adjunto: " + imagenQR.getName());
}
