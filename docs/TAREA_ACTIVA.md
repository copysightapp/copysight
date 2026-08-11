# Publicación, App Review y difusión de CopySight

Última actualización: 2026-08-11 16:02 WEST.

## Estado actual

El repositorio, la web, la documentación inglesa y las superficies comunitarias de GitHub están publicados. Apple solicitó información bajo Guideline 2.1; la respuesta completa se envió y la build 1.1.0 (4) figura como pendiente de revisión. El DMG directo con App Sandbox está publicado en la web y GitHub Release, y ambos destinos entregan exactamente el artefacto notarizado. Siguiente paso: difusión externa verificable en comunidades y directorios compatibles.

## Objetivo y criterio de terminado

- [x] Mover el repositorio a una organización gratuita homónima.
- [x] Hacer público el repositorio y enlazarlo desde la web.
- [x] Reescribir en inglés el README y la documentación pública principal.
- [x] Mejorar la portada de la organización y las superficies de contribución de GitHub.
- [x] Configurar y comprobar la portada social y el repositorio destacado de la organización.
- [x] Obtener el motivo literal del rechazo de Apple, corregir su causa raíz y verificarla.
- [x] Reenviar la versión corregida a App Review y confirmar el estado remoto resultante. La aprobación final depende de Apple y no puede garantizarse.
- [x] Publicar el nuevo DMG directo con App Sandbox ya verificado, según el comentario de revisión sobre `script/package_release.sh`.
- [ ] Publicar el proyecto en comunidades y directorios adecuados sin infringir sus normas ni duplicar mensajes.
- [ ] Verificar cada publicación, dejar Git limpio y registrar cualquier espera externa real.

## Decisiones vigentes

- Toda la presentación de GitHub y los mensajes internacionales se redactan en inglés.
- La difusión será específica para cada comunidad; no se publicará texto duplicado ni spam.
- Se priorizan canales donde usuarios normales encuentran aplicaciones para Mac y donde desarrolladores encuentran proyectos para contribuir: Homebrew, directorios de aplicaciones, comunidades macOS/Swift y listas open source.
- Product Hunt y otros canales orientados principalmente a startups o inversores quedan fuera de prioridad; el borrador de Product Hunt no se publicó.
- El DMG directo ya incluye y verifica App Sandbox; web y GitHub Release sirven exactamente ese artefacto.
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
- [x] Publicar el DMG directo con sandbox en web y GitHub Release, y verificar ambos destinos.
- [ ] Investigar normas y publicar en comunidades/directorios compatibles.
- [ ] Reconsultar enlaces, estados remotos, rama y worktree; cerrar recursos propios.

## Estado por capa

- Local: rama `docs/outreach-log` creada desde `main` en `37920c5aa407ef57eb15e30ba00ef41e65e4cb48`; solo este registro está modificado para documentar la difusión.
- Pruebas: `swift test` pasó 5/5 tras regenerar una caché de Swift ligada a la ruta anterior; `node web/test.mjs` pasó; YAML de formularios validado; escáner editorial sin avisos.
- Commit/remoto: PR #2 y PR #3 fusionadas en `main`; sandbox y DMG publicados en `37920c5aa407ef57eb15e30ba00ef41e65e4cb48`.
- Web: despliegue de producción `dpl_FX4tCqzzcFjr7m7nTiTDNFGC9RG9`; dominio público verificado detrás de Cloudflare en `https://copysight.guillermozubikarai.dev`.
- GitHub público: `https://github.com/copysightapp/copysight`; organización `https://github.com/copysightapp`; discusión de bienvenida `https://github.com/copysightapp/copysight/discussions/1`.
- App Review: Guideline 2.1 - Information Needed. Apple pidió detalles sobre Grabación de pantalla; respuesta completa enviada el 2026-08-11 a las 15:05 WEST. Envío `fd8d3b70-ab40-49dd-b1b3-24b9f83dd3a8`, build 1.1.0 (4), pendiente de revisión desde las 15:06 WEST.
- DMG directo: build universal con App Sandbox, Developer ID, hardened runtime y notarización aceptada; web y GitHub Release entregan el mismo SHA-256 verificado.
- Difusión externa: comentario público verificado en el megahilo de agosto de r/macapps: `https://www.reddit.com/r/macapps/comments/1vd3plb/comment/p31sfjk/`. El intento de `Show HN` no se publicó porque Hacker News exige más participación previa de la cuenta. Product Hunt conserva como máximo un borrador sin publicar y queda descartado como prioridad.

## Bloqueos o pasos externos

- Hacker News: `Show HN` bloqueado temporalmente por participación insuficiente de la cuenta; no se intentará eludir la restricción.
- Product Hunt: borrador no publicado y canal despriorizado por no coincidir con la audiencia solicitada.
- Si otra comunidad exige login, CAPTCHA, moderación previa o una cuenta no disponible, registrar el estado alcanzado, la acción externa exacta y la señal de reanudación.
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
- 2026-08-11: PR #3 fusionada; GitHub Release 1.1.0 y la web sustituidas. Descarga de ambos destinos comparada byte a byte con el DMG notarizado. Cloudflare respondió desde `MAD`.
- 2026-08-11: publicación de r/macapps verificada en `https://www.reddit.com/r/macapps/comments/1vd3plb/comment/p31sfjk/`, adaptada al formato obligatorio Problem/Comparison/Pricing del megahilo de aplicaciones aún no publicadas en Mac App Store.
- 2026-08-11: Hacker News redirigió el intento de `Show HN` a su restricción de participación previa; no existe publicación pública. Product Hunt quedó sin publicar y fuera de prioridad.
