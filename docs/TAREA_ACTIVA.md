# Publicación, App Review y difusión de CopySight

Última actualización: 2026-08-11 16:38 WEST.

## Estado actual

El repositorio, la web, la documentación inglesa y las superficies comunitarias de GitHub están publicados. Apple solicitó información bajo Guideline 2.1; la respuesta completa se envió y la build 1.1.0 (4) figura como pendiente de revisión. El DMG directo con App Sandbox está publicado en la web y GitHub Release, y ambos destinos entregan exactamente el artefacto notarizado. La difusión compatible está publicada o enviada a moderación en Reddit, AlternativeTo, MacUpdate y dos catálogos comunitarios de aplicaciones Mac de código abierto.

## Objetivo y criterio de terminado

- [x] Mover el repositorio a una organización gratuita homónima.
- [x] Hacer público el repositorio y enlazarlo desde la web.
- [x] Reescribir en inglés el README y la documentación pública principal.
- [x] Mejorar la portada de la organización y las superficies de contribución de GitHub.
- [x] Configurar y comprobar la portada social y el repositorio destacado de la organización.
- [x] Obtener el motivo literal del rechazo de Apple, corregir su causa raíz y verificarla.
- [x] Reenviar la versión corregida a App Review y confirmar el estado remoto resultante. La aprobación final depende de Apple y no puede garantizarse.
- [x] Publicar el nuevo DMG directo con App Sandbox ya verificado, según el comentario de revisión sobre `script/package_release.sh`.
- [x] Publicar el proyecto en comunidades y directorios adecuados sin infringir sus normas ni duplicar mensajes.
- [x] Verificar cada publicación y registrar cualquier espera externa real. Git se comprobará de nuevo tras fusionar este registro final.
- [x] Retirar del repositorio público la configuración interna y sanear sus referencias históricas.

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
- [x] Investigar normas y publicar en comunidades/directorios compatibles.
- [x] Reconsultar enlaces, estados remotos, rama y worktree; cerrar recursos propios.

## Estado por capa

- Local: la configuración interna se eliminó de todos los commits alcanzables y las menciones históricas se neutralizaron; el worktree se comprobará limpio después de publicar la nueva historia.
- Pruebas: `swift test` pasó 5/5 tras regenerar una caché de Swift ligada a la ruta anterior; `node web/test.mjs` pasó; YAML de formularios validado; escáner editorial sin avisos.
- Commit/remoto: PR #2, PR #3 y PR #4 fusionadas en `main`; sandbox, DMG e icono web publicados. Los identificadores históricos anteriores dejan de ser canónicos tras el saneamiento.
- Web: despliegue de producción `dpl_CrrSyw2MQShafpnChsWbM321dyoH`; dominio público verificado detrás de Cloudflare en `https://copysight.guillermozubikarai.dev`, incluido `web/icon.png` de 1024 x 1024.
- GitHub público: `https://github.com/copysightapp/copysight`; organización `https://github.com/copysightapp`; discusión de bienvenida `https://github.com/copysightapp/copysight/discussions/1`.
- App Review: Guideline 2.1 - Information Needed. Apple pidió detalles sobre Grabación de pantalla; respuesta completa enviada el 2026-08-11 a las 15:05 WEST. Envío `fd8d3b70-ab40-49dd-b1b3-24b9f83dd3a8`, build 1.1.0 (4), pendiente de revisión desde las 15:06 WEST.
- DMG directo: build universal con App Sandbox, Developer ID, hardened runtime y notarización aceptada; web y GitHub Release entregan el mismo SHA-256 verificado.
- Difusión para usuarios: comentario público verificado en r/macapps: `https://www.reddit.com/r/macapps/comments/1vd3plb/comment/p31sfjk/`. AlternativeTo aceptó la ficha `770d46f6-9197-477a-b304-cc0204802a89` y la mantiene privada hasta moderación. MacUpdate confirmó el envío y prevé responder por correo en un máximo de diez días; la ficha tampoco es pública todavía.
- Difusión para contribuidores: publicación técnica en r/macosprogramming `https://www.reddit.com/r/macosprogramming/comments/1vlkker/copysight_a_native_swift_6_menu_bar_app_for/`, comentario en el hilo mensual de r/swift `https://www.reddit.com/r/swift/comments/1vd5n9s/comment/p31ypeo/` y ficha en r/coolgithubprojects `https://www.reddit.com/r/coolgithubprojects/comments/1vlklhl/copysight_free_private_ondevice_screen_ocr_for/`. PR pública `serhii-londar/open-source-mac-os-apps#1267`, validada con 690 aplicaciones y cero entradas inválidas; PR pública `jaywcjlove/awesome-mac#2546`, sincronizada en cuatro idiomas, con build y generación de AST superadas. Ambas están abiertas, listas para revisión y no deben describirse como aceptadas hasta que sus mantenedores las fusionen.

## Bloqueos o pasos externos

- Hacker News: `Show HN` bloqueado temporalmente por participación insuficiente de la cuenta; no se intentará eludir la restricción.
- Product Hunt: borrador no publicado y canal despriorizado por no coincidir con la audiencia solicitada.
- AlternativeTo: moderación pendiente; la plataforma avisa de una cola que puede durar meses. No se pagó la prioridad opcional.
- MacUpdate: moderación pendiente; el formulario quedó enviado sin capturas porque la extensión de Chrome no tiene permiso para cargar archivos locales y las imágenes eran opcionales.
- Homebrew Cask: no se abrió una propuesta que incumpliría el umbral vigente para casks nuevos de al menos 75 estrellas o 30 forks/watchers. Reconsiderar cuando el repositorio alcance uno de esos umbrales.
- Swift Forums: no se publicó en Community Showcase porque sus reglas excluyen aplicaciones finales que solo estén escritas en Swift y no aporten una interfaz de programación Swift.
- r/opensource: no se hizo una publicación desde una cuenta sin historial en la comunidad porque sus reglas prohíben el `drive-by posting` y la autopromoción excesiva.
- MacRumors y Apple Developer Forums: no se publicó; MacRumors aplica restricciones editoriales y Apple exige evitar autopromoción. r/macOS, r/SwiftUI y r/apple reservan promociones para sábado o domingo, por lo que no se incumplió su ventana semanal.
- La decisión final de App Review pertenece a Apple; una revisión pendiente no garantiza la aprobación.
- GitHub conserva parches internos de PR fusionadas en referencias de solo lectura. Ya no son alcanzables desde ramas ni etiquetas públicas; purgarlos por completo requeriría intervención de GitHub Support o recrear el repositorio, con pérdida de sus PR, Discussions y metadatos.

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
- 2026-08-11: AlternativeTo recibió una ficha completa con icono, dos capturas, tres alternativas, funciones, idiomas y licencia; estado privado `waiting to be reviewed`.
- 2026-08-11: MacUpdate confirmó `Your app has been submitted!`; descarga, versión, requisitos, precio, descripción, cambios, soporte, checksum y nota de privacidad quedaron enviados.
- 2026-08-11: `open-source-mac-os-apps#1267` abierta y validada: `swift .github/main.swift` registró 690 aplicaciones, cero inválidas y cero omitidas.
- 2026-08-11: `awesome-mac#2546` abierta y fusionable; la entrada está en Menu Bar Tools para inglés, chino, japonés y coreano. `npm run build`, `npm run create:ast` y `git diff --check` pasaron.
- 2026-08-11: r/swift publicó el comentario técnico `p31ypeo`; r/macosprogramming publicó el artículo `1vlkker`; r/coolgithubprojects publicó la ficha `1vlklhl`. Las tres superficies mostraron el contenido y el enlace al repositorio desde la cuenta autenticada.
- 2026-08-11 16:27 WEST: App Store Connect volvió a mostrar `1.1.0 Pendiente de revisión`; `open-source-mac-os-apps#1267` seguía abierta y fusionable, y `awesome-mac#2546` abierta y fusionable con License Compliance aún pendiente. La web respondió HTTP 200 mediante Cloudflare desde MAD y la descarga de GitHub Release respondió con su redirección de activo.
- 2026-08-11 16:28 WEST: todas las pestañas y recursos de Chrome abiertos para App Store Connect, GitHub, directorios y Reddit quedaron finalizados.
- 2026-08-11 16:29 WEST: PR #5 fusionada en `main` como `e97c893e6f5498862364153505ac29c0d83dd82f`; la PR no tenía comprobaciones remotas configuradas y `node web/test.mjs` y `git diff --check` habían pasado localmente.
- 2026-08-11 16:30 WEST: correo de finalización enviado a la propia cuenta Gmail autenticada con el resultado, los destinos públicos y la distinción expresa entre revisión pendiente y aprobación.
- 2026-08-11 16:35 WEST: eliminados de todo el historial alcanzable los archivos de configuración interna y neutralizadas las menciones al proceso de desarrollo. La propuesta externa de `awesome-mac` también quedó revisada.
- 2026-08-11 16:38 WEST: `main`, `v1.0.0` y `v1.1.0` se publicaron de forma atómica con protección de estado remoto. Los tres archivos fuente descargados desde GitHub pasaron el escaneo; README, Release 1.1.0 y web pública siguieron respondiendo correctamente. La API rechazó la eliminación de `refs/pull/*` por ser referencias de solo lectura.
