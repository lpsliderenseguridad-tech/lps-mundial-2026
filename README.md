# 🏆 Mundial 2026 PWA — LPS Seguridad
## Instrucciones de despliegue — Parte 1

---

## PASO 1 — Supabase: crear la tabla

1. Ir a https://supabase.com → tu proyecto `gesujigrxpqvyuquitmz`
2. Click en **SQL Editor** → **New query**
3. Pegar todo el contenido de `setup.sql`
4. Click **Run**
5. Verificar que diga "72 partidos en grupos" al final

---

## PASO 2 — Obtener el Anon Key de Supabase

1. En Supabase → **Settings** → **API**
2. Copiar el valor de **anon public** key
3. Abrir `index.html` y reemplazar `TU_SUPABASE_ANON_KEY` con ese valor

---

## PASO 3 — Crear los iconos

Necesitás dos archivos PNG en una carpeta `/icons/`:
- `icon-192.png` (192×192 px)
- `icon-512.png` (512×512 px)

Podés crearlos en https://favicon.io o usar cualquier imagen del logo LPS.

---

## PASO 4 — Subir a Vercel

### Opción A — Desde GitHub (recomendado):
1. Crear repo en GitHub: `lps-mundial-2026`
2. Subir todos los archivos de esta carpeta
3. En Vercel → **Add New Project** → conectar ese repo
4. Deploy automático

### Opción B — Drag & Drop:
1. Ir a https://vercel.com/new
2. Arrastrar la carpeta `mundial-lps` completa
3. Click **Deploy**

---

## PASO 5 — Configurar el dominio

En Vercel → Settings → Domains → agregar:
```
mundial.lpsseguridad.com.ar
```

---

## PASO 6 — Compartir por WhatsApp

Mandar este mensaje a tus contactos:
```
⚽🏆 *Mundial 2026 — Fixture con resultados en vivo*

Instalá la app y seguí todos los partidos de Argentina en tiempo real.
Notificaciones antes de cada partido 🔔

📲 mundial.lpsseguridad.com.ar

_LPS Seguridad · 358 460-2508_
```

---

## PASO 7 — Cómo cargar resultados (Parte 2)

Por ahora podés ir directamente a Supabase → Table Editor → `mundial_partidos`
y editar los campos `goles1` y `goles2` del partido correspondiente.

Se actualiza en **tiempo real** en todos los celulares automáticamente.

---

## Próximos pasos (Parte 2 y 3)

- **Parte 2**: Panel admin propio para cargar resultados desde el celu
- **Parte 3**: Notificaciones push automáticas para partidos de Argentina

---

## Estructura de archivos
```
mundial-lps/
├── index.html      ← App principal
├── manifest.json   ← Config PWA
├── sw.js           ← Service Worker (offline + push)
├── setup.sql       ← SQL para Supabase
├── icons/
│   ├── icon-192.png
│   └── icon-512.png
└── README.md
```
