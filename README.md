# CopySight

CopySight es una app OCR nativa y de código abierto para macOS. Pulsa el atajo global, arrastra sobre cualquier texto visible y obtén el resultado en el portapapeles.

[Descargar CopySight 1.0.0](https://github.com/kattulus1997/copysight/releases/latest/download/CopySight-1.0.0.dmg) · [Web](https://copysight.guillermozubikarai.dev)

## Por qué es rápida

- `ScreenCaptureKit` captura únicamente la región seleccionada a resolución Retina.
- `Vision` ejecuta reconocimiento preciso y corrección lingüística en el dispositivo.
- El OCR sale del hilo principal; la interfaz sigue respondiendo durante el análisis.
- El atajo global usa Carbon, sin monitorizar el teclado ni pedir permiso de Accesibilidad.
- No hay procesos auxiliares, red, analítica, historial persistente ni dependencias externas.

## Requisitos

- macOS 14 o posterior.
- Permiso de Grabación de pantalla. macOS lo solicita en la primera captura.

Consulta [FIRST_RUN.md](FIRST_RUN.md) para el alta del permiso y la prueba inicial.

## Compilar y ejecutar

```sh
./script/build_and_run.sh --verify
```

El bundle queda en `dist/CopySight.app`. Ejecuta las comprobaciones con:

```sh
swift test
```

## CLI

El mismo motor OCR está disponible en Terminal, sin red ni dependencias de ejecución:

```sh
brew install kattulus1997/copysight/copysight
copysight captura.png
copysight --language es documento.jpg
```

Ejecuta `copysight --help` para ver las opciones de idioma, corrección y saltos de línea.

Para generar el bundle optimizado y su ZIP distribuible:

```sh
./script/build_and_run.sh --package
```

La Release pública se genera con `script/package_release.sh`: binario universal, firma Developer ID, hardened runtime, notarización y ticket de Apple grapado al DMG.

## Uso

1. Abre CopySight; aparecerá un icono en la barra de menús.
2. Pulsa `⌃⇧2` (personalizable) o elige **Capture Text**.
3. Arrastra sobre el texto. `Escape` o clic derecho cancelan.
4. Pega el resultado en cualquier app.

Los ajustes permiten elegir detección automática, inglés o español, conservar saltos de línea y personalizar el atajo.

## Privacidad

Las capturas se procesan íntegramente en el Mac mediante frameworks del sistema. No se guardan ni se envían a ningún servidor. Solo el texto reconocido permanece temporalmente en memoria para poder copiarlo de nuevo.

## Licencia

MIT. Consulta [LICENSE](LICENSE).
