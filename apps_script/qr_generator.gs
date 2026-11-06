
/**
 * Construye el contenido que almacenará
 * el código QR de cada invitado.
 *
 * @param {string} id UUID del invitado.
 * @returns {string} Contenido del QR.
 */
function construirContenidoQR(id) {
  if (typeof id !== "string" || id.trim() === "") {
    throw new Error("El identificador del invitado no es válido");
  }

  return "EVT:" + id.trim();
}

/**
 * Prueba independiente del contenido del QR.
 */
function probarContenidoQR() {
  const id = "550e8400-e29b-41d4-a716-446655440000";

  const contenido = construirContenidoQR(id);

  console.log("Contenido del QR: " + contenido);
}

/**
 * Genera un código QR utilizando qrcode-generator.
 *
 * @param {string} id UUID del invitado.
 * @returns {Object} Objeto QR generado.
 */
function generarQR(id) {
  const contenido = construirContenidoQR(id);

  // 0: selección automática de versión QR.
  // M: nivel medio de corrección de errores.
  const qr = qrcode(0, "M");

  qr.addData(contenido);
  qr.make();

  return qr;
}

/**
 * Comprueba que la biblioteca genera
 * correctamente la matriz del QR.
 */
function probarGeneracionQR() {
  const id = "550e8400-e29b-41d4-a716-446655440000";

  const qr = generarQR(id);

  console.log("Contenido: " + construirContenidoQR(id));
  console.log("Tamaño de matriz: " + qr.getModuleCount());
  console.log("QR generado correctamente");
}

/**
 * Convierte el QR en un archivo GIF adjuntable.
 *
 * @param {string} id UUID del invitado.
 * @returns {GoogleAppsScript.Base.Blob}
 */
function generarImagenQR(id) {
  const qr = generarQR(id);

  // Genera una imagen GIF codificada en Base64.
  const dataUrl = qr.createDataURL(6, 24);

  const base64 = dataUrl.split(",")[1];
  const bytes = Utilities.base64Decode(base64);

  return Utilities.newBlob(
    bytes,
    "image/gif",
    "invitacion_qr.gif"
  );
}

/**
 * Prueba independiente de la imagen.
 */
function probarImagenQR() {
  const id = "550e8400-e29b-41d4-a716-446655440000";

  const imagen = generarImagenQR(id);

  console.log("Nombre: " + imagen.getName());
  console.log("Tipo MIME: " + imagen.getContentType());
  console.log("Tamaño: " + imagen.getBytes().length + " bytes");
}
