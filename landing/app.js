const API_URL = "https://script.google.com/macros/s/AKfycbw3uPWSIrl6cimlAv5NyTUB8INlJi0Nnlwj0g8S_GFpbX2qCEJ3O8MKojdHrkXXGtWpwQ/exec";

const formulario = document.getElementById("registroForm");
const mensaje = document.getElementById("mensaje");
const boton = document.getElementById("btnRegistrar");

formulario.addEventListener("submit", async (event) => {

    event.preventDefault();

    const nombre = document.getElementById("nombre").value.trim();
    const email = document.getElementById("email").value.trim();

    mensaje.textContent = "Registrando...";
    mensaje.className = "";

    boton.disabled = true;

    try {

        const response = await fetch(API_URL, {
            method: "POST",

            body: JSON.stringify({
                nombre: nombre,
                email: email
            })
        });

        const data = await response.json();

        console.log("Respuesta del registro:", data);

        if (data.status === "ok") {

            mensaje.textContent =
                "Registro realizado correctamente.";

            mensaje.className = "exito";

            formulario.reset();

        } else {

            throw new Error(
                data.message || "No se pudo completar el registro"
            );
        }

    } catch (error) {

        console.error("Error:", error);

        mensaje.textContent =
            "Ocurrió un error al realizar el registro.";

        mensaje.className = "error";

    } finally {

        boton.disabled = false;
    }
});