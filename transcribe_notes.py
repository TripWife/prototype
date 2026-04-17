import whisper
import os
import sys

def transcribe():
    # Path to the audio file
    audio_path = os.path.join("NOTAS", "BRUNNA-SEB_01.mp3")
    
    if not os.path.exists(audio_path):
        print(f"Error: No se encuentra el archivo en {audio_path}")
        return

    print("Cargando modelo Whisper (esto puede tardar la primera vez)...")
    # Usamos el modelo 'base' para velocidad, o 'medium' para más precisión
    model = whisper.load_model("base")
    
    print(f"Transcribiendo {audio_path}...")
    try:
        result = model.transcribe(audio_path, language="es")
        
        # Guardamos el resultado en un archivo de texto
        output_path = os.path.join("NOTAS", "transcripcion_BRUNNA-SEB.txt")
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(result["text"])
        
        print(f"\n¡Listo! Transcripción guardada en: {output_path}")
        print("\n--- Resumen del inicio ---")
        print(result["text"][:500] + "...")
        
    except Exception as e:
        print(f"\nError durante la transcripción: {e}")
        print("\nNOTA: Asegúrate de tener 'ffmpeg' instalado en tu sistema (necesario para procesar el audio).")

if __name__ == "__main__":
    transcribe()
