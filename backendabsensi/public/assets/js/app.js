/* =========================================================
 * JAYQ Absensi — SPA front-end
 * Router + Shell + Pages (Admin / Dosen / Mahasiswa)
 * ========================================================= */
(() => {
    const $app = () => document.getElementById('app');
    const SB = (window.APP_CONFIG && window.APP_CONFIG.storageBase) || '/storage';

    /* ---------------- Menu per role ---------------- */
    const MENUS = {
        admin: [
            { key: 'dashboard',  label: 'Dashboard',     icon: 'dashboard' },
            { key: 'users',      label: 'Pengguna',      icon: 'users' },
            { key: 'matkul',     label: 'Mata Kuliah',   icon: 'book' },
            { key: 'absensi',    label: 'Data Absensi',  icon: 'clipboard' },
            { key: 'pengumuman', label: 'Pengumuman',    icon: 'megaphone' },
            { key: 'notifikasi', label: 'Notifikasi',    icon: 'bell' },
            { key: 'export',     label: 'Export Data',   icon: 'download' },
            { key: 'profile',    label: 'Profil',        icon: 'user' },
        ],
        dosen: [
            { key: 'dashboard',  label: 'Dashboard',     icon: 'dashboard' },
            { key: 'matkul',     label: 'Mata Kuliah',   icon: 'book' },
            { key: 'qr',         label: 'Generate QR',   icon: 'qr' },
            { key: 'rekap',      label: 'Rekap Absensi', icon: 'clipboard' },
            { key: 'tugas',      label: 'Tugas',         icon: 'file' },
            { key: 'materi',     label: 'Materi',        icon: 'book' },
            { key: 'pengumuman', label: 'Pengumuman',    icon: 'megaphone' },
            { key: 'profile',    label: 'Profil',        icon: 'user' },
        ],
        mahasiswa: [
            { key: 'dashboard',  label: 'Dashboard',     icon: 'dashboard' },
            { key: 'scan',       label: 'Scan Absensi',  icon: 'scan' },
            { key: 'riwayat',    label: 'Riwayat',       icon: 'history' },
            { key: 'matkul',     label: 'Mata Kuliah',   icon: 'book' },
            { key: 'tugas',      label: 'Tugas',         icon: 'file' },
            { key: 'materi',     label: 'Materi',        icon: 'book' },
            { key: 'pengumuman', label: 'Pengumuman',    icon: 'megaphone' },
            { key: 'profile',    label: 'Profil',        icon: 'user' },
        ],
    };

    const ROLE_LABEL = { admin: 'Administrator', dosen: 'Dosen', mahasiswa: 'Mahasiswa' };
    const ROLE_BADGE = { admin: 'badge-purple', dosen: 'badge-blue', mahasiswa: 'badge-green' };

    /* ---------------- Router ---------------- */
    function parseHash() {
        const raw = (location.hash || '#/').replace(/^#\/?/, '');
        const [path, query] = raw.split('?');
        const parts = path.split('/').filter(Boolean);
        return { page: parts[0] || 'dashboard', param: parts[1] || null, parts, query };
    }

    async function router() {
        const { page } = parseHash();

        if (!API.isAuthed()) {
            if (page !== 'login') { location.hash = '#/login'; return; }
            return renderLogin();
        }
        if (page === 'login') { location.hash = '#/dashboard'; return; }

        const role = (API.user() || {}).role || 'mahasiswa';
        const menu = MENUS[role] || [];
        const valid = menu.some(m => m.key === page);
        const active = valid ? page : 'dashboard';

        renderShell(active);
        const view = document.getElementById('view');
        const fn = PAGES[active];
        if (fn) {
            try { await fn(view); }
            catch (e) { console.error(e); view.innerHTML = errorState('Terjadi kesalahan saat memuat halaman.'); }
        }
    }

    /* ---------------- Login ---------------- */
    function renderLogin() {
        $app().innerHTML = `
        <div class="min-h-screen flex items-center justify-center p-4">
            <div class="w-full max-w-md animate-fade-up">
                <div class="text-center mb-8">
                    <div class="logo-mark text-3xl mb-2">JAYQ</div>
                    <p class="text-slate-400 text-sm">Sistem Manajemen Kehadiran</p>
                </div>
                <div class="card p-8">
                    <h1 class="text-2xl font-bold text-white mb-1">Selamat datang 👋</h1>
                    <p class="text-slate-400 text-sm mb-6">Masuk untuk melanjutkan ke dashboard.</p>
                    <form id="login-form" class="space-y-4">
                        <div>
                            <label class="label">Email</label>
                            <input type="email" id="li-email" class="input" placeholder="admin@jayq.com" required>
                        </div>
                        <div>
                            <label class="label">Password</label>
                            <input type="password" id="li-pass" class="input" placeholder="••••••••" required>
                        </div>
                        <button type="submit" id="li-btn" class="btn btn-primary w-full">Masuk</button>
                    </form>
                    <div class="mt-6 pt-5 border-t border-white/10">
                        <p class="text-xs text-slate-500 mb-2">Akun demo (klik untuk isi otomatis):</p>
                        <div class="grid grid-cols-3 gap-2">
                            <button class="btn btn-ghost btn-sm demo" data-e="admin@jayq.com">Admin</button>
                            <button class="btn btn-ghost btn-sm demo" data-e="budi@jayq.com">Dosen</button>
                            <button class="btn btn-ghost btn-sm demo" data-e="ahmad@jayq.com">Mahasiswa</button>
                        </div>
                    </div>
                </div>
                <p class="text-center text-xs text-slate-600 mt-6">© ${new Date().getFullYear()} JAYQ Absensi</p>
            </div>
        </div>`;

        document.querySelectorAll('.demo').forEach(b => b.onclick = () => {
            document.getElementById('li-email').value = b.dataset.e;
            document.getElementById('li-pass').value = 'password';
        });

        document.getElementById('login-form').onsubmit = async (e) => {
            e.preventDefault();
            const btn = document.getElementById('li-btn');
            btn.disabled = true; btn.textContent = 'Memproses...';
            const email = document.getElementById('li-email').value.trim();
            const password = document.getElementById('li-pass').value;
            const { ok, data } = await API.post('/login', { email, password });
            if (ok && data.success) {
                API.setAuth(data.data.token, data.data.user);
                UI.toast('success', 'Login berhasil', `Halo, ${data.data.user.nama}!`);
                location.hash = '#/dashboard';
            } else {
                UI.toast('error', 'Login gagal', data.message || 'Periksa kembali email dan password.');
                btn.disabled = false; btn.textContent = 'Masuk';
            }
        };
    }

    /* ---------------- Shell ---------------- */
    function renderShell(active) {
        const u = API.user() || {};
        const role = u.role || 'mahasiswa';
        const menu = MENUS[role] || [];

        $app().innerHTML = `
        <div class="flex min-h-screen">
            <!-- Sidebar -->
            <aside id="sidebar" class="fixed lg:sticky top-0 left-0 z-50 h-screen w-72 shrink-0 -translate-x-full lg:translate-x-0 transition-transform duration-300 glass-strong border-r border-white/10 flex flex-col">
                <div class="px-6 py-6 flex items-center gap-3 border-b border-white/10">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-brand-500 to-violet-500 flex items-center justify-center font-extrabold">J</div>
                    <div>
                        <div class="logo-mark text-lg leading-none">JAYQ</div>
                        <p class="text-[11px] text-slate-400 mt-1">Absensi System</p>
                    </div>
                </div>
                <nav class="flex-1 overflow-y-auto px-3 py-4 space-y-1">
                    ${menu.map(m => `
                        <a href="#/${m.key}" class="nav-item ${m.key === active ? 'active' : ''}">
                            ${UI.icon(m.icon)} <span>${m.label}</span>
                        </a>`).join('')}
                </nav>
                <div class="p-3 border-t border-white/10">
                    <button id="logout-btn" class="nav-item w-full text-rose-300 hover:bg-rose-500/10">
                        ${UI.icon('logout')} <span>Keluar</span>
                    </button>
                </div>
            </aside>

            <div id="sb-overlay" class="fixed inset-0 z-40 bg-black/50 hidden lg:hidden"></div>

            <!-- Main -->
            <div class="flex-1 min-w-0 flex flex-col">
                <header class="sticky top-0 z-30 glass border-b border-white/10 px-4 sm:px-8 py-4 flex items-center justify-between">
                    <div class="flex items-center gap-3">
                        <button id="menu-btn" class="lg:hidden text-slate-300 hover:text-white">${UI.icon('menu', 'w-6 h-6')}</button>
                        <div>
                            <h2 class="text-lg font-bold text-white capitalize">${(menu.find(m => m.key === active) || {}).label || ''}</h2>
                            <p class="text-xs text-slate-400">${new Date().toLocaleDateString('id-ID', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <div class="text-right hidden sm:block">
                            <p class="text-sm font-semibold text-white leading-none">${UI.esc(u.nama || '')}</p>
                            <span class="badge ${ROLE_BADGE[role]} mt-1">${ROLE_LABEL[role]}</span>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-gradient-to-br from-brand-500 to-cyan-400 flex items-center justify-center font-bold text-sm">${UI.initials(u.nama)}</div>
                    </div>
                </header>
                <main id="view" class="flex-1 p-4 sm:p-8"></main>
            </div>
        </div>`;

        document.getElementById('logout-btn').onclick = doLogout;

        // mobile sidebar
        const sb = document.getElementById('sidebar');
        const ov = document.getElementById('sb-overlay');
        const open = () => { sb.classList.remove('-translate-x-full'); ov.classList.remove('hidden'); };
        const close = () => { sb.classList.add('-translate-x-full'); ov.classList.add('hidden'); };
        document.getElementById('menu-btn').onclick = open;
        ov.onclick = close;
        sb.querySelectorAll('.nav-item').forEach(a => a.addEventListener('click', () => { if (window.innerWidth < 1024) close(); }));
    }

    async function doLogout() {
        const ok = await UI.confirm({ title: 'Keluar', message: 'Yakin ingin keluar dari sesi ini?', confirmText: 'Keluar' });
        if (!ok) return;
        await API.post('/logout');
        API.clear();
        UI.toast('success', 'Berhasil keluar');
        location.hash = '#/login';
    }

    /* ---------------- Shared UI bits ---------------- */
    function pageHeader(title, subtitle, actionsHtml = '') {
        return `
        <div class="flex flex-wrap items-end justify-between gap-4 mb-6 animate-fade-up">
            <div>
                <h1 class="text-2xl font-bold text-white">${UI.esc(title)}</h1>
                ${subtitle ? `<p class="text-slate-400 text-sm mt-1">${UI.esc(subtitle)}</p>` : ''}
            </div>
            <div class="flex gap-2">${actionsHtml}</div>
        </div>`;
    }
    function statCard(label, value, icon, tone = 'brand') {
        const tones = {
            brand: 'from-brand-500/20 to-violet-500/10 text-brand-300',
            green: 'from-emerald-500/20 to-teal-500/10 text-emerald-300',
            cyan:  'from-cyan-500/20 to-sky-500/10 text-cyan-300',
            amber: 'from-amber-500/20 to-orange-500/10 text-amber-300',
        };
        return `
        <div class="card p-5 animate-fade-up">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs font-semibold text-slate-400 uppercase tracking-wide">${UI.esc(label)}</p>
                    <p class="text-3xl font-extrabold text-white mt-2">${value}</p>
                </div>
                <div class="w-12 h-12 rounded-xl bg-gradient-to-br ${tones[tone]} flex items-center justify-center">${UI.icon(icon, 'w-6 h-6')}</div>
            </div>
        </div>`;
    }
    function emptyState(msg, icon = 'info') {
        return `<div class="card p-10 text-center text-slate-400 animate-fade-up">
            <div class="w-14 h-14 mx-auto rounded-2xl bg-white/5 flex items-center justify-center mb-3 text-slate-500">${UI.icon(icon, 'w-7 h-7')}</div>
            <p>${UI.esc(msg)}</p></div>`;
    }
    function errorState(msg) {
        return `<div class="card p-10 text-center text-rose-300">${UI.icon('warn','w-8 h-8 mx-auto mb-3')}<p>${UI.esc(msg)}</p></div>`;
    }
    function fileUrl(p) { return p ? `${SB}/${p}` : '#'; }

    // expose shared helpers for page modules
    window.JAYQ = { pageHeader, statCard, emptyState, errorState, fileUrl, parseHash, SB, ROLE_LABEL, ROLE_BADGE };

    /* ---------------- Pages registry (filled by page modules) ---------------- */
    window.PAGES = window.PAGES || {};

    /* ---------------- Boot ---------------- */
    window.addEventListener('hashchange', router);
    window.addEventListener('DOMContentLoaded', () => {
        setTimeout(() => {
            const sp = document.getElementById('splash');
            if (sp) { sp.style.transition = '.5s ease'; sp.style.opacity = '0'; setTimeout(() => sp.remove(), 500); }
        }, 500);
        if (!location.hash) location.hash = API.isAuthed() ? '#/dashboard' : '#/login';
        router();
    });
})();
