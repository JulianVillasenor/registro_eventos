const API_URL = "https://script.google.com/macros/s/AKfycbw3uPWSIrl6cimlAv5NyTUB8INlJi0Nnlwj0g8S_GFpbX2qCEJ3O8MKojdHrkXXGtWpwQ/exec";

async function comprobarAPI() {
    try {
        const response = await fetch(API_URL);

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }

        const data = await response.json();

        console.log("Respuesta de la API:", data);

        if (data.status === "ok") {
            console.log("API conectada correctamente");
        }
    } catch (error) {
        console.error("Error al conectar con la API:", error);
    }
}

comprobarAPI();