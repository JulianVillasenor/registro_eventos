
/**
 * Envía la invitación con el QR individual del invitado.
 *
 * @param {string} email Correo del invitado.
 * @param {string} nombre Nombre del invitado.
 * @param {string} id UUID generado durante el registro.
 */
function enviarCorreoConQR(email, nombre, id) {
  const imagenQR = generarImagenQR(id);

  const asunto = "Tu invitación - Registro de Eventos";

  const mensaje = `
Hola ${nombre},

¡Tu registro al evento se realizó correctamente!

Adjuntamos tu código QR personal de acceso.

Presenta este código al ingresar al evento.

Identificador: ${id}

Te recomendamos conservar este correo hasta el día del evento.

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

  console.log("Invitación enviada a: " + email);
  console.log("UUID: " + id);
}
