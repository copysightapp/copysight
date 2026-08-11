# Publicación, App Review y difusión de CopySight

Última actualización: 2026-08-11 15:50 WEST.

## Estado actual

El repositorio ya pertenece a la organización gratuita `copysightapp`, es público y está enlazado desde la web. El README, la documentación comunitaria, la portada social y el perfil de organización están publicados en inglés. Apple solicitó información bajo Guideline 2.1; la respuesta completa se envió y la build 1.1.0 (4) figura como pendiente de revisión. El DMG directo corregido con App Sandbox ya está firmado, notarizado y validado localmente. Siguiente paso: publicar ese artefacto y después realizar difusión externa verificable.

## Objetivo y criterio de terminado

- [x] Mover el repositorio a una organización gratuita homónima.
- [x] Hacer público el repositorio y enlazarlo desde la web.
- [x] Reescribir en inglés el README y la documentación pública principal.
- [x] Mejorar la portada de la organización y las superficies de contribución de GitHub.
- [x] Configurar y comprobar la portada social y el repositorio destacado de la organización.
- [x] Obtener el motivo literal del rechazo de Apple, corregir su causa raíz y verificarla.
- [x] Reenviar la versión corregida a App Review y confirmar el estado remoto resultante. La aprobación final depende de Apple y no puede garantizarse.
- [ ] Publicar el nuevo DMG directo con App Sandbox ya verificado, según el comentario de revisión sobre `script/package_release.sh`.
- [ ] Publicar el proyecto en comunidades y directorios adecuados sin infringir sus normas ni duplicar mensajes.
- [ ] Verificar cada publicación, dejar Git limpio y registrar cualquier espera externa real.

## Decisiones vigentes

- Toda la presentación de GitHub y los mensajes internacionales se redactan en inglés.
- La difusión será específica para cada comunidad; no se publicará texto duplicado ni spam.
- Se priorizan canales con audiencia macOS, Swift, OCR y open source, además de directorios mantenidos mediante pull requests.
- La diferencia actual de App Sandbox del DMG directo se declara con precisión hasta que exista un artefacto nuevo corregido y verificado.
- `WAITING_FOR_REVIEW` o un estado equivalente prueba envío, no aprobación.

## Plan y progreso

- [x] Inspeccionar repositorio, estado Git, web, App Store assets y metadatos remotos.
- [x] Reescribir README, primer uso y seguridad en inglés.
- [x] Añadir contribución, conducta, plantillas de issues y plantilla de pull request.
- [x] Crear `copysightapp/.github` y su `profile/README.md` público.
- [x] Optimizar descripción, web, temas, Discussions y alertas de dependencias.
- [x] Publicar mediante la PR `copysightapp/copysight#2`.
- [x] Terminar y comprobar visualmente GitHub, incluida la ficha social.
- [x] Revalidar App Store Connect, rechazo, build, metadatos y envío a revisión.
- [ ] Publicar el DMG directo con sandbox en web y GitHub Release, y verificar ambos destinos.
- [ ] Investigar normas y publicar en comunidades/directorios compatibles.
- [ ] Reconsultar enlaces, estados remotos, rama y worktree; cerrar recursos propios.

## Estado por capa

- Local: rama `fix/direct-download-sandbox`; corrección, DMG nuevo, README y registro incluidos en el commit de la rama, pendientes de push y revisión.
- Pruebas: `swift test` pasó 5/5 tras regenerar una caché de Swift ligada a la ruta anterior; `node web/test.mjs` pasó; YAML de formularios validado; escáner editorial sin avisos.
- Commit/remoto: PR #2 fusionada en `main`; commit de sandbox creado en la rama local y pendiente de publicación.
- Web: repositorio enlazado y despliegue público verificado antes de esta fase en `https://copysight.guillermozubikarai.dev`.
- GitHub público: `https://github.com/copysightapp/copysight`; organización `https://github.com/copysightapp`; discusión de bienvenida `https://github.com/copysightapp/copysight/discussions/1`.
- App Review: Guideline 2.1 - Information Needed. Apple pidió detalles sobre Grabación de pantalla; respuesta completa enviada el 2026-08-11 a las 15:05 WEST. Envío `fd8d3b70-ab40-49dd-b1b3-24b9f83dd3a8`, build 1.1.0 (4), pendiente de revisión desde las 15:06 WEST.
- DMG directo: build universal con App Sandbox, Developer ID, hardened runtime y notarización aceptada; aún no sustituido en web/GitHub Release.
- Difusión externa: aún no iniciada; debe comenzar después de cerrar presentación y release.

## Bloqueos o pasos externos

- Ninguno confirmado. Si una comunidad exige login, CAPTCHA, moderación previa o una cuenta no disponible, registrar el estado alcanzado, la acción externa exacta y la señal de reanudación.
- La decisión final de App Review pertenece a Apple; una revisión pendiente no garantiza la aprobación.

## Evidencia e historial

- 2026-08-11: organización gratuita `copysightapp` creada; repositorio transferido y público.
- 2026-08-11: enlace del repositorio añadido a la web bilingüe y verificado públicamente.
- 2026-08-11: perfil de organización publicado mediante `copysightapp/.github`, commit `8c94621727073a5d221148927c8bf0577f5dd8fe`.
- 2026-08-11: documentación inglesa y superficies comunitarias fusionadas mediante PR #2, commit `c8279851bdef663d48dd1095a7bb343282a46e8e`.
- 2026-08-11: descripción, 13 temas, Discussions y alertas de dependencias verificadas mediante la API de GitHub.
- 2026-08-11: Chrome mostró públicamente el nuevo README de la organización y la ficha del repositorio.
- 2026-08-11: portada social subida y comprobada visualmente en GitHub; `copysight` guardado como repositorio destacado de la organización.
- 2026-08-11: mensaje literal de Apple comprobado en App Store Connect; la incidencia fue una solicitud de información sobre Grabación de pantalla, no un defecto binario.
- 2026-08-11: respuesta de privacidad comprobada y reenvío confirmado como pendiente de revisión para 1.1.0 (4).
- 2026-08-11: DMG sandboxed notarizado con envío `aef8d22a-c4c2-4af8-aede-ffe68380cedf`; Gatekeeper, firma, arquitecturas y entitlement dentro del volumen pasaron. SHA-256 `f6c86dbdca33319fd5445bd771aa3c033f2f5fd60cb0983f8201fe30ecf186c3`.
