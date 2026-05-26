const CACHE = 'mundial-lps-v1';
const SHELL = ['/', '/index.html', '/manifest.json'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});

self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  e.respondWith(
    caches.match(e.request).then(cached => cached || fetch(e.request).then(res => {
      const clone = res.clone();
      caches.open(CACHE).then(c => c.put(e.request, clone));
      return res;
    })).catch(() => caches.match('/index.html'))
  );
});

// ── PUSH NOTIFICATIONS ──
self.addEventListener('push', e => {
  const data = e.data ? e.data.json() : {};
  const options = {
    body: data.body || '⚽ Notificación del Mundial 2026',
    icon: '/icons/icon-192.png',
    badge: '/icons/badge-72.png',
    vibrate: [200, 100, 200],
    data: { url: data.url || '/' },
    actions: [
      { action: 'ver', title: '🏟️ Ver partido' },
      { action: 'cerrar', title: 'Cerrar' }
    ]
  };
  e.waitUntil(self.registration.showNotification(data.title || 'Mundial 2026 · LPS', options));
});

self.addEventListener('notificationclick', e => {
  e.notification.close();
  if (e.action === 'cerrar') return;
  e.waitUntil(clients.openWindow(e.notification.data.url || '/'));
});
