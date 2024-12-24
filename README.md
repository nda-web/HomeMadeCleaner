# HomeMadeCleaner

HomeMadeCleaner es un script sencillo de PowerShell para limpiar archivos temporales y basura en tu PC. Este "limpia PC hecho en casa" es ideal para quienes desean liberar espacio y mejorar el rendimiento del sistema sin depender de aplicaciones de terceros. Aunque es básico, hace el trabajo de manera eficiente.

## Características
- Limpia archivos temporales de las carpetas comunes de Windows.
- Elimina caché y archivos basura de navegadores populares:
  - Google Chrome
  - Microsoft Edge
  - Mozilla Firefox
  - Opera
  - Brave
  - Vivaldi
- Borra datos de la Papelera de reciclaje.
- Compatible con cualquier usuario de Windows.
- Solicita permisos de administrador automáticamente si es necesario.

## Requisitos
- Windows 10 o superior.
- PowerShell 5.0 o superior.

## Instalación
1. Descarga el archivo `HomeMadeCleaner.ps1` desde este repositorio.
2. Colócalo en una carpeta de tu elección.

## Uso
1. Haz clic derecho sobre el archivo `HomeMadeCleaner.ps1` y selecciona **Ejecutar con PowerShell**.
2. Si se te solicita, otorga permisos de administrador.
3. El script comenzará a limpiar las carpetas predefinidas y te informará sobre los archivos eliminados.

## Carpetas limpiadas
El script limpia las siguientes ubicaciones:

### Windows
- `C:\Windows\Temp`
- `C:\Windows\Prefetch`
- `C:\Windows\SoftwareDistribution\Download`
- `C:\Windows\Logs`
- Papelera de reciclaje: `C:\$Recycle.Bin`

### Usuario
- `C:\Users\[NombreDeUsuario]\AppData\Local\Temp`
- `C:\Users\[NombreDeUsuario]\AppData\LocalLow\Temp`
- `C:\Users\[NombreDeUsuario]\AppData\Roaming\Microsoft\Windows\Recent`
- `C:\Users\[NombreDeUsuario]\Downloads` (opcional)

### Navegadores
- **Google Chrome:** Caché y archivos temporales.
- **Microsoft Edge:** Caché y archivos temporales.
- **Mozilla Firefox:** Caché y offline cache.
- **Opera, Brave, Vivaldi:** Caché y archivos temporales.

## ¿Qué no hace?
- Este script no limpia el registro de Windows. Aunque podría implementarse, la limpieza del registro puede ser riesgosa si no se realiza correctamente. Se recomienda usar herramientas específicas para ello, como CCleaner o similares, y proceder con precaución.

## Precauciones
1. **Archivos importantes:** Asegúrate de no tener archivos necesarios en las carpetas que se van a limpiar, como `Downloads`.
2. **Navegadores:** Este script puede cerrar sesiones abiertas o eliminar descargas parciales.
3. **Ejecución segura:** Si tienes dudas, revisa el código antes de ejecutarlo.

## Contribuciones
HomeMadeCleaner es un proyecto abierto. Si deseas agregar nuevas funcionalidades, como la limpieza del registro o la automatización de tareas, no dudes en hacer un fork y enviar tus mejoras mediante un pull request.

## Licencia
Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más información.

---

¡Gracias por usar HomeMadeCleaner! Si tienes sugerencias o comentarios, no dudes en abrir un issue.

