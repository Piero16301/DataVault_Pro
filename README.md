# DataVault Pro 🔒📱

![Flutter Version](https://img.shields.io/badge/Flutter-3.44.8-blue?logo=flutter)
[![CI/CD](https://github.com/Piero16301/DataVault_Pro/actions/workflows/main.yaml/badge.svg?branch=main)](https://github.com/Piero16301/DataVault_Pro/actions/workflows/main.yaml)
[![Quality Gate](https://sonarcloud.io/api/project_badges/measure?project=Piero16301_DataVault_Pro&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=Piero16301_DataVault_Pro)

**DataVault Pro** es una aplicación en Flutter de grado industrial diseñada para demostrar prácticas avanzadas de seguridad, procesamiento multihilo con Isolates, gestión de ciclo de vida en segundo plano y automatización con CI/CD.

---

## 🚀 Características Principales

* 🔐 **Persistencia Segura:** Uso de `flutter_secure_storage` para guardar tokens de acceso cifrados.
* ⚡ **Procesamiento Multihilo:** Uso de `Isolate.run()` para procesar +10,000 registros sin bloquear la UI (60 FPS).
* 🛡️ **Escudo de Privacidad:** Desenfoque automático (`BackdropFilter`) cuando la app pasa a segundo plano.
* 🧪 **Calidad de Código:** Integración con Linter estricto, pruebas unitarias/widgets y análisis con SonarCloud.
* 🤖 **CI/CD Automatizado:** Pipeline con GitHub Actions que valida el código y genera el APK de producción.

---

## 🛠️ Ejecución Local

1. Obtener dependencias:
   ```bash
   flutter pub get
   ```
2. Correr el linter estricto:
   ```bash
   flutter analyze
   ```
3. Ejecutar pruebas unitarias:
   ```bash
   flutter test
   ```
4. Iniciar la aplicación:
   ```bash
   flutter run
   ```

---

## 🤖 Obtener el código directamente desde GitHub

1. Ve a tu repositorio en GitHub $\rightarrow$ Pestaña **Actions**.
2. En la barra lateral izquierda, selecciona tu workflow (**DataVault Pro CI/CD Pipeline**).
3. Haz clic en el botón de **tres puntos (`...`)** en la esquina superior derecha del panel principal.
4. Haz clic en **Create status badge**.
5. Copia el fragmento en formato **Markdown** y pégalo al inicio de tu `README.md`.

---

Al hacer `git add README.md`, `git commit` y `git push origin main`, verás los badges renderizados dinámicamente en la página principal de tu repositorio mostrando el estado actual (**passing** / **failing**).
   