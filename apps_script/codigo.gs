function doGet(e) {
  try {
    const hoja = SpreadsheetApp
      .getActiveSpreadsheet()
      .getSheets()[0];

    const ultimaFila = hoja.getLastRow();

    if (ultimaFila <= 1) {
      return respuestaJSON({
        status: "ok",
        service: "registro-eventos-api",
        registrados: 0,
        ingresaron: 0,
        pendientes: 0
      });
    }

    // Leer columnas A:F, excluyendo encabezados
    const datos = hoja.getRange(
      2,
      1,
      ultimaFila - 1,
      6
    ).getValues();

    const registrados = datos.filter(
      fila => String(fila[0]).trim() !== ""
    ).length;

    const ingresaron = datos.filter(
      fila =>
        String(fila[0]).trim() !== "" &&
        (
          fila[4] === true ||
          String(fila[4]).toUpperCase() === "TRUE"
        )
    ).length;

    return respuestaJSON({
      status: "ok",
      service: "registro-eventos-api",
      registrados: registrados,
      ingresaron: ingresaron,
      pendientes: registrados - ingresaron
    });

  } catch (error) {
    return respuestaJSON({
      status: "error",
      message: error.toString()
    });
  }
}


function doPost(e) {
  try {
    const datos = JSON.parse(e.postData.contents);

    if (!datos.nombre || !datos.email) {
      return respuestaJSON({
        status: "error",
        message: "Nombre y email son obligatorios"
      });
    }

    const hoja = SpreadsheetApp
      .getActiveSpreadsheet()
      .getSheets()[0];

    const id = Utilities.getUuid();
    const fechaRegistro = new Date();
    
    hoja.appendRow([
      id,
      datos.nombre,
      datos.email,
      fechaRegistro,
      false,
      ""
    ]);

    let correoEnviado = false;

    try {
      enviarCorreoConQR(
        datos.email,
        datos.nombre,
        id
      );

      correoEnviado = true;

    } catch (errorCorreo) {
      console.error(
        "Error enviando invitación con QR: " +
        errorCorreo.toString()
      );
    }


    return respuestaJSON({
      status: "ok",
      message: "Invitado registrado correctamente",
      correoEnviado: correoEnviado,
      invitado: {
        id: id,
        nombre: datos.nombre,
        email: datos.email
      }
    });

  } catch (error) {
    return respuestaJSON({
      status: "error",
      message: error.toString()
    });
  }
}


function respuestaJSON(datos) {
  return ContentService
    .createTextOutput(JSON.stringify(datos))
    .setMimeType(ContentService.MimeType.JSON);
}

function enviarCorreoConfirmacion(email, nombre) {
  const asunto = "Confirmación de registro - Evento";

  const mensaje = `
Hola ${nombre},

Tu registro al evento se realizó correctamente.

Próximamente recibirás tu código QR de acceso.

¡Te esperamos!

Equipo organizador
`;

  MailApp.sendEmail({
    to: email,
    subject: asunto,
    body: mensaje,
    name: "Registro de Eventos"
  });
}

function probarEnvioCorreo() {
  enviarCorreoConfirmacion(
    "julianvillaseno@gmail.com",
    "Invitado de prueba"
  );
}


function probarRegistroLocal() {
  const evento = {
    postData: {
      contents: JSON.stringify({
        nombre: "Prueba Apps Script",
        email: "correo-de-prueba@example.com"
      })
    }
  };

  const respuesta = doPost(evento);

  Logger.log(respuesta.getContent());
}

