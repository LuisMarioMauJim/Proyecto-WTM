This project is a web application developed in ASP.NET with C# and SQL Server that allows a technical support department to manage requests or incidents reported by users efficiently.

The system allows you to register tickets, auto-assign them, change their status (active, pending, resolved, canceled), and keep visual control of the follow-up through categorized tabs. 
A module is also included to attach PDF evidence and rate the care received.


# 📊 Sistema de Gestión de Tickets - ASP.NET Web Forms
---

## 🚀 Requisitos de ejecución

> ⚠️ Se recomienda usar los navegadores **Microsoft Edge** o **Google Chrome** para una experiencia óptima.  
> Internet Explorer no es compatible.

---

## 📦 Paquetes y bibliotecas utilizadas

A continuación se enlistan todas las dependencias externas que el proyecto requiere para funcionar correctamente. Algunas son implícitamente instaladas como dependencias de otras.

### 📌 Principales (instalación obligatoria)

| Paquete                                              | Propósito                                                 |
|------------------------------------------------------|-----------------------------------------------------------|
| `ClosedXML`                                          | Exportación avanzada a archivos Excel.                    |
| `QuestPDF`                                           | Generación de documentos PDF.                             |
| `jQuery`                                             | Manipulación del DOM y soporte para AJAX en el frontend.  |
| `Microsoft.CodeDom.Providers.DotNetCompilerPlatform` | Soporte para compilación de código dinámico.              |

---

### 📚 Complementarios (requeridos o incluidos por dependencias)

- `Antlr`
- `bootstrap`
- `ClosedXML.Parser`
- `DocumentFormat.OpenXml`
- `DocumentFormat.OpenXml.Framework`
- `ExcelNumberFormat`
- `HarfBuzzSharp`
- `HarfBuzzSharp.NativeAssets.macOS`
- `HarfBuzzSharp.NativeAssets.Win32`
- `Microsoft.AspNet.FriendlyUrls`
- `Microsoft.AspNet.FriendlyUrls.Core`
- `Microsoft.AspNet.ScriptManager.MSAjax`
- `Microsoft.AspNet.ScriptManager.WebForms`
- `Microsoft.AspNet.Web.Optimization`
- `Microsoft.AspNet.Web.Optimization.WebForms`
- `Microsoft.Bcl.HashCode`
- `Microsoft.Web.Infrastructure`
- `Modernizr`
- `Newtonsoft.Json`
- `RBush.Signed`
- `SixLabors.Fonts`
- `SkiaSharp`
- `SkiaSharp.HarfBuzz`
- `SkiaSharp.NativeAssets.macOS`
- `SkiaSharp.NativeAssets.Win32`
- `System.Buffers`
- `System.Memory`
- `System.Numerics.Vectors`
- `System.Runtime.CompilerServices.Unsafe`
- `WebGrease`

> ⚙️ Muchos de estos paquetes se instalan automáticamente como dependencias de los principales.

---

## 👤 Usuario por defecto (Administrador)

Puedes iniciar sesión con el siguiente usuario predefinido:

- **Correo electrónico:** `admin@gmail.com`
- **Contraseña:** `admin`

> Asegúrate de cambiar esta contraseña en producción por motivos de seguridad.

---

## 📂 Recomendaciones

- Visual Studio 2022 
- .NET Framework 4.8 
- Navegadores recomendados: **Edge / Chrome**
- Asegúrate de que el paquete `Microsoft.CodeDom.Providers.DotNetCompilerPlatform` esté actualizado para compilar correctamente Razor y otras vistas.

---
