/* =========================================================
 * JAYQ Absensi — Page modules
 * Mengisi window.PAGES dengan implementasi tiap halaman.
 * ========================================================= */
(() => {
    const { pageHeader, statCard, emptyState, errorState, fileUrl } = window.JAYQ;
    const PAGES = window.PAGES;
    const me = () => API.user() || {};
    const formErr = (data) => {
        if (data && data.errors) return Object.values(data.errors).flat().join(' ');
        return (data && data.message) || 'Terjadi kesalahan.';
    };

    /* ============================================================
     * DASHBOARD (dispatch per role)
     * ============================================================ */
    PAGES.dashboard = async (view) => {
        const role = me().role;
        if (role === 'admin') return dashboardAdmin(view);
        if (role === 'dosen') return dashboardDosen(view);
        return dashboardMahasiswa(view);
    };

    async function dashboardAdmin(view) {
        view.innerHTML = pageHeader('Dashboard Admin', 'Ringkasan aktivitas sistem absensi') + UI.skeletonCards(4);
        const [s, adv] = await Promise.all([
            API.get('/admin/dashboard/stats'),
            API.get('/admin/dashboard/advanced-stats'),
        ]);
        const d = (s.data && s.data.data) || {};
        const a = (adv.data && adv.data.data) || {};

        view.innerHTML = pageHeader('Dashboard Admin', 'Ringkasan aktivitas sistem absensi') + `
        <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 mb-6">
            ${statCard('Mata Kuliah', d.total_mata_kuliah ?? 0, 'book', 'brand')}
            ${statCard('Dosen', d.total_dosen ?? 0, 'graduation', 'cyan')}
            ${statCard('Mahasiswa', d.total_mahasiswa ?? 0, 'users', 'green')}
            ${statCard('Absensi Hari Ini', d.total_absensi_hari_ini ?? 0, 'clipboard', 'amber')}
        </div>
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-5 mb-6">
            <div class="card p-5 lg:col-span-2 animate-fade-up">
                <h3 class="font-bold text-white mb-4">Absensi 7 Hari Terakhir</h3>
                <canvas id="ch-line" height="110"></canvas>
            </div>
            <div class="card p-5 animate-fade-up">
                <h3 class="font-bold text-white mb-4">Komposisi Pengguna</h3>
                <canvas id="ch-doughnut" height="180"></canvas>
            </div>
        </div>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-5">
            <div class="card overflow-hidden animate-fade-up">
                <div class="px-5 py-4 border-b border-white/10"><h3 class="font-bold text-white">Persentase Kehadiran per Mata Kuliah</h3></div>
                <div class="overflow-x-auto"><table class="tbl"><thead><tr><th>Mata Kuliah</th><th>Dosen</th><th>Peserta</th><th>Kehadiran</th></tr></thead>
                <tbody>${(a.persentase_per_mata_kuliah || []).map(x => `
                    <tr><td><p class="font-semibold text-white">${UI.esc(x.mata_kuliah)}</p><p class="text-xs text-slate-500">${UI.esc(x.kode_mk)}</p></td>
                    <td>${UI.esc(x.dosen)}</td><td>${x.total_peserta}</td>
                    <td><div class="flex items-center gap-2"><div class="flex-1 h-2 rounded-full bg-white/10 overflow-hidden min-w-[60px]"><div class="h-full bg-gradient-to-r from-brand-500 to-cyan-400" style="width:${x.persentase_kehadiran}%"></div></div><span class="text-xs font-semibold">${x.persentase_kehadiran}%</span></div></td></tr>`).join('') || `<tr><td colspan="4" class="text-center text-slate-500 py-6">Belum ada data</td></tr>`}
                </tbody></table></div>
            </div>
            <div class="card overflow-hidden animate-fade-up">
                <div class="px-5 py-4 border-b border-white/10"><h3 class="font-bold text-white">Aktivitas Terbaru</h3></div>
                <div class="divide-y divide-white/5 max-h-[360px] overflow-y-auto">
                ${(a.recent_activities || []).map(r => `
                    <div class="px-5 py-3 flex items-center gap-3">
                        <div class="w-9 h-9 rounded-full bg-gradient-to-br from-brand-500 to-cyan-400 flex items-center justify-center text-xs font-bold">${UI.initials(r.user)}</div>
                        <div class="flex-1 min-w-0"><p class="text-sm text-white truncate">${UI.esc(r.user)}</p><p class="text-xs text-slate-500 truncate">Absen • ${UI.esc(r.mata_kuliah)}</p></div>
                        <span class="text-xs text-slate-500">${UI.esc(r.time_ago)}</span>
                    </div>`).join('') || `<div class="px-5 py-6 text-center text-slate-500">Belum ada aktivitas</div>`}
                </div>
            </div>
        </div>`;

        // charts
        const line = a.absensi_per_hari || [];
        const lc = document.getElementById('ch-line');
        if (lc) new Chart(lc, {
            type: 'line',
            data: { labels: line.map(x => x.day), datasets: [{ label: 'Absensi', data: line.map(x => x.count), borderColor: '#818cf8', backgroundColor: 'rgba(129,140,248,.2)', fill: true, tension: .4, pointRadius: 4, pointBackgroundColor: '#22d3ee' }] },
            options: chartOpts()
        });
        const us = a.user_stats || {};
        const dc = document.getElementById('ch-doughnut');
        if (dc) new Chart(dc, {
            type: 'doughnut',
            data: { labels: ['Admin', 'Dosen', 'Mahasiswa'], datasets: [{ data: [us.admin || 0, us.dosen || 0, us.mahasiswa || 0], backgroundColor: ['#a78bfa', '#60a5fa', '#34d399'], borderWidth: 0 }] },
            options: { plugins: { legend: { labels: { color: '#cbd5e1' }, position: 'bottom' } }, cutout: '65%' }
        });
    }

    function chartOpts() {
        return {
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { color: 'rgba(255,255,255,.05)' }, ticks: { color: '#94a3b8' } },
                y: { grid: { color: 'rgba(255,255,255,.05)' }, ticks: { color: '#94a3b8' }, beginAtZero: true }
            }
        };
    }

    async function dashboardDosen(view) {
        view.innerHTML = pageHeader('Dashboard Dosen', `Selamat datang, ${me().nama}`) + UI.skeletonCards(4);
        const { data } = await API.get(`/dosen/${me().id}/dashboard/stats`);
        const d = (data && data.data) || {};
        const mk = await API.get('/mata-kuliah/dosen/me');
        const list = (mk.data && mk.data.data) || [];
        view.innerHTML = pageHeader('Dashboard Dosen', `Selamat datang, ${me().nama}`) + `
        <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 mb-6">
            ${statCard('Mata Kuliah', d.total_mata_kuliah ?? 0, 'book', 'brand')}
            ${statCard('Mahasiswa', d.total_mahasiswa ?? 0, 'users', 'green')}
            ${statCard('Absensi Hari Ini', d.total_absensi_hari_ini ?? 0, 'clipboard', 'cyan')}
            ${statCard('Total Tugas', d.total_tugas ?? 0, 'file', 'amber')}
        </div>
        <div class="card overflow-hidden animate-fade-up">
            <div class="px-5 py-4 border-b border-white/10"><h3 class="font-bold text-white">Mata Kuliah yang Diampu</h3></div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 p-5">
            ${list.map(m => `
                <div class="rounded-xl border border-white/10 p-4 bg-white/[.02]">
                    <div class="flex items-center justify-between"><span class="badge badge-blue">${UI.esc(m.kode_mk)}</span><span class="text-xs text-slate-400">${(m.peserta || []).length} peserta</span></div>
                    <p class="font-bold text-white mt-2">${UI.esc(m.nama_mk)}</p>
                    <p class="text-xs text-slate-500 mt-1">${m.sks ? m.sks + ' SKS' : ''} ${m.semester ? '• ' + UI.esc(m.semester) : ''}</p>
                </div>`).join('') || `<p class="text-slate-500 text-sm">Belum ada mata kuliah.</p>`}
            </div>
        </div>`;
    }

    async function dashboardMahasiswa(view) {
        view.innerHTML = pageHeader('Dashboard', `Selamat datang, ${me().nama}`) + UI.skeletonCards(4);
        const { data } = await API.get(`/mahasiswa/${me().id}/stats`);
        const d = (data && data.data) || {};
        const p = d.persentase_kehadiran ?? 0;
        view.innerHTML = pageHeader('Dashboard', `Selamat datang, ${me().nama}`) + `
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-5 mb-6">
            <div class="card p-6 flex items-center gap-5 animate-fade-up lg:col-span-1">
                <div class="ring relative w-28 h-28 rounded-full flex items-center justify-center" style="--p:${p}">
                    <div class="absolute inset-2 rounded-full bg-[#0d1326] flex flex-col items-center justify-center">
                        <span class="text-2xl font-extrabold gradient-text">${p}%</span>
                        <span class="text-[10px] text-slate-400">Kehadiran</span>
                    </div>
                </div>
                <div>
                    <p class="text-sm text-slate-400">Tingkat Kehadiran</p>
                    <p class="text-lg font-bold text-white mt-1">${p >= 75 ? 'Sangat Baik 🎯' : p >= 50 ? 'Cukup 👍' : 'Perlu Ditingkatkan ⚠️'}</p>
                </div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-5 lg:col-span-2">
                ${statCard('Mata Kuliah', d.total_mata_kuliah ?? 0, 'book', 'brand')}
                ${statCard('Tugas Selesai', d.tugas_selesai ?? 0, 'check', 'green')}
                ${statCard('Tugas Pending', d.tugas_pending ?? 0, 'clock', 'amber')}
            </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <a href="#/scan" class="card p-6 hover:scale-[1.02] transition animate-fade-up flex items-center gap-4">
                <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-brand-500/30 to-violet-500/20 flex items-center justify-center text-brand-300">${UI.icon('scan','w-6 h-6')}</div>
                <div><p class="font-bold text-white">Scan Absensi</p><p class="text-xs text-slate-400">Masukkan kode QR dari dosen</p></div>
            </a>
            <a href="#/tugas" class="card p-6 hover:scale-[1.02] transition animate-fade-up flex items-center gap-4">
                <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-amber-500/30 to-orange-500/20 flex items-center justify-center text-amber-300">${UI.icon('file','w-6 h-6')}</div>
                <div><p class="font-bold text-white">Tugas Saya</p><p class="text-xs text-slate-400">Lihat & kumpulkan tugas</p></div>
            </a>
        </div>`;
    }

    /* ============================================================
     * PROFILE (shared)
     * ============================================================ */
    PAGES.profile = async (view) => {
        const u = me();
        view.innerHTML = pageHeader('Profil Saya', 'Kelola informasi akun Anda') + `
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-5">
            <div class="card p-6 text-center animate-fade-up">
                <div class="w-24 h-24 mx-auto rounded-full bg-gradient-to-br from-brand-500 to-cyan-400 flex items-center justify-center text-3xl font-extrabold">${UI.initials(u.nama)}</div>
                <p class="text-lg font-bold text-white mt-4">${UI.esc(u.nama)}</p>
                <p class="text-sm text-slate-400">${UI.esc(u.email)}</p>
                <span class="badge ${window.JAYQ.ROLE_BADGE[u.role]} mt-3">${window.JAYQ.ROLE_LABEL[u.role]}</span>
            </div>
            <div class="card p-6 lg:col-span-2 animate-fade-up">
                <h3 class="font-bold text-white mb-4">Edit Profil</h3>
                <form id="pf-form" class="space-y-4">
                    <div class="grid sm:grid-cols-2 gap-4">
                        <div><label class="label">Nama</label><input id="pf-nama" class="input" value="${UI.esc(u.nama)}"></div>
                        <div><label class="label">Email</label><input id="pf-email" type="email" class="input" value="${UI.esc(u.email)}"></div>
                    </div>
                    <hr class="border-white/10">
                    <p class="text-sm font-semibold text-slate-300">Ubah Password <span class="text-xs text-slate-500 font-normal">(opsional)</span></p>
                    <div class="grid sm:grid-cols-3 gap-4">
                        <div><label class="label">Password Saat Ini</label><input id="pf-cur" type="password" class="input" placeholder="••••••"></div>
                        <div><label class="label">Password Baru</label><input id="pf-new" type="password" class="input" placeholder="••••••"></div>
                        <div><label class="label">Konfirmasi</label><input id="pf-conf" type="password" class="input" placeholder="••••••"></div>
                    </div>
                    <button class="btn btn-primary" id="pf-btn">Simpan Perubahan</button>
                </form>
            </div>
        </div>`;
        document.getElementById('pf-form').onsubmit = async (e) => {
            e.preventDefault();
            const btn = document.getElementById('pf-btn'); btn.disabled = true;
            const payload = { nama: val('pf-nama'), email: val('pf-email') };
            const np = val('pf-new');
            if (np) { payload.current_password = val('pf-cur'); payload.new_password = np; payload.new_password_confirmation = val('pf-conf'); }
            const { ok, data } = await API.put('/profile/update', payload);
            btn.disabled = false;
            if (ok && data.success) {
                const u2 = { ...me(), nama: payload.nama, email: payload.email };
                API.setUser(u2);
                UI.toast('success', 'Profil diperbarui');
                router2();
            } else UI.toast('error', 'Gagal', formErr(data));
        };
    };

    /* ============================================================
     * PENGUMUMAN (dispatch)
     * ============================================================ */
    PAGES.pengumuman = async (view) => {
        if (me().role === 'admin') return pengumumanAdmin(view);
        return pengumumanViewer(view);
    };

    const TIPE_BADGE = { info: 'badge-blue', penting: 'badge-yellow', urgent: 'badge-red' };

    async function pengumumanViewer(view) {
        view.innerHTML = pageHeader('Pengumuman', 'Informasi terbaru untuk Anda') + UI.skeletonTable();
        const { data } = await API.get('/pengumuman');
        const list = (data && data.data) || [];
        view.innerHTML = pageHeader('Pengumuman', 'Informasi terbaru untuk Anda') +
            (list.length ? `<div class="space-y-4">${list.map(p => `
                <div class="card p-5 animate-fade-up ${p.is_read ? '' : 'border-brand-500/40'}">
                    <div class="flex items-start justify-between gap-3">
                        <div class="flex items-center gap-2">
                            <span class="badge ${TIPE_BADGE[p.tipe] || 'badge-slate'}">${UI.esc(p.tipe)}</span>
                            ${p.is_read ? '' : '<span class="badge badge-purple">Baru</span>'}
                        </div>
                        <span class="text-xs text-slate-500">${UI.fmtDate(p.created_at)}</span>
                    </div>
                    <h3 class="font-bold text-white mt-3">${UI.esc(p.judul)}</h3>
                    <p class="text-sm text-slate-300 mt-1 whitespace-pre-line">${UI.esc(p.isi)}</p>
                    <div class="flex items-center justify-between mt-3 pt-3 border-t border-white/5">
                        <span class="text-xs text-slate-500">oleh ${UI.esc((p.creator || {}).nama || '-')}</span>
                        ${p.is_read ? '<span class="text-xs text-emerald-400">✓ Dibaca</span>' : `<button class="btn btn-ghost btn-sm mark" data-id="${p.id}">Tandai dibaca</button>`}
                    </div>
                </div>`).join('')}</div>` : emptyState('Belum ada pengumuman.', 'megaphone'));
        view.querySelectorAll('.mark').forEach(b => b.onclick = async () => {
            await API.post(`/pengumuman/${b.dataset.id}/mark-as-read`);
            UI.toast('success', 'Ditandai sudah dibaca'); pengumumanViewer(view);
        });
    }

    async function pengumumanAdmin(view) {
        const head = pageHeader('Kelola Pengumuman', 'Buat & kelola pengumuman sistem',
            `<button class="btn btn-primary" id="add-peng">${UI.icon('plus','w-4 h-4')} Buat Pengumuman</button>`);
        view.innerHTML = head + UI.skeletonTable();
        const { data } = await API.get('/pengumuman/admin');
        const list = (data && data.data) || [];
        view.innerHTML = head + `<div class="card overflow-hidden animate-fade-up"><div class="overflow-x-auto"><table class="tbl">
            <thead><tr><th>Judul</th><th>Tipe</th><th>Target</th><th>Status</th><th>Tanggal</th><th>Aksi</th></tr></thead><tbody>
            ${list.map(p => `<tr>
                <td class="max-w-xs"><p class="font-semibold text-white truncate">${UI.esc(p.judul)}</p><p class="text-xs text-slate-500 truncate">${UI.esc(p.isi)}</p></td>
                <td><span class="badge ${TIPE_BADGE[p.tipe] || 'badge-slate'}">${UI.esc(p.tipe)}</span></td>
                <td class="capitalize">${UI.esc(p.target)}</td>
                <td><span class="badge ${p.is_active ? 'badge-green' : 'badge-slate'}">${p.is_active ? 'Aktif' : 'Nonaktif'}</span></td>
                <td>${UI.fmtDate(p.created_at)}</td>
                <td><div class="flex gap-1">
                    <button class="btn btn-ghost btn-sm tg" data-id="${p.id}" title="Toggle">${UI.icon('eye','w-4 h-4')}</button>
                    <button class="btn btn-ghost btn-sm ed" data-id="${p.id}" title="Edit">${UI.icon('edit','w-4 h-4')}</button>
                    <button class="btn btn-ghost btn-sm del text-rose-300" data-id="${p.id}" title="Hapus">${UI.icon('trash','w-4 h-4')}</button>
                </div></td></tr>`).join('') || `<tr><td colspan="6" class="text-center text-slate-500 py-8">Belum ada pengumuman</td></tr>`}
            </tbody></table></div></div>`;

        const byId = (id) => list.find(x => x.id == id);
        document.getElementById('add-peng').onclick = () => pengForm();
        view.querySelectorAll('.ed').forEach(b => b.onclick = () => pengForm(byId(b.dataset.id)));
        view.querySelectorAll('.tg').forEach(b => b.onclick = async () => { await API.post(`/pengumuman/${b.dataset.id}/toggle`); UI.toast('success', 'Status diubah'); pengumumanAdmin(view); });
        view.querySelectorAll('.del').forEach(b => b.onclick = async () => {
            if (!await UI.confirm({ message: 'Hapus pengumuman ini?' })) return;
            await API.del(`/pengumuman/${b.dataset.id}`); UI.toast('success', 'Pengumuman dihapus'); pengumumanAdmin(view);
        });

        function pengForm(item) {
            const edit = !!item;
            UI.modal({
                title: edit ? 'Edit Pengumuman' : 'Buat Pengumuman', size: 'md',
                body: `<form id="pg-f" class="space-y-4">
                    <div><label class="label">Judul</label><input id="pg-judul" class="input" value="${edit ? UI.esc(item.judul) : ''}" required></div>
                    <div><label class="label">Isi</label><textarea id="pg-isi" class="textarea" rows="4" required>${edit ? UI.esc(item.isi) : ''}</textarea></div>
                    <div class="grid grid-cols-2 gap-4">
                        <div><label class="label">Tipe</label><select id="pg-tipe" class="select">${['info','penting','urgent'].map(t => `<option value="${t}" ${edit && item.tipe === t ? 'selected' : ''}>${t}</option>`).join('')}</select></div>
                        <div><label class="label">Target</label><select id="pg-target" class="select">${['all','dosen','mahasiswa'].map(t => `<option value="${t}" ${edit && item.target === t ? 'selected' : ''}>${t}</option>`).join('')}</select></div>
                    </div></form>`,
                footer: `<button class="btn btn-ghost" onclick="UI.closeModal()">Batal</button><button class="btn btn-primary" id="pg-save">Simpan</button>`,
                onMount: () => {
                    document.getElementById('pg-save').onclick = async () => {
                        const payload = { judul: val('pg-judul'), isi: val('pg-isi'), tipe: val('pg-tipe'), target: val('pg-target') };
                        if (!payload.judul || !payload.isi) return UI.toast('warning', 'Lengkapi data');
                        const r = edit ? await API.put(`/pengumuman/${item.id}`, payload) : await API.post('/pengumuman', payload);
                        if (r.ok && r.data.success) { UI.closeModal(); UI.toast('success', edit ? 'Pengumuman diperbarui' : 'Pengumuman dibuat'); pengumumanAdmin(view); }
                        else UI.toast('error', 'Gagal', formErr(r.data));
                    };
                }
            });
        }
    }

    /* ---------- small helpers ---------- */
    function val(id) { const el = document.getElementById(id); return el ? el.value.trim() : ''; }
    function router2() { window.dispatchEvent(new HashChangeEvent('hashchange')); }
    window.__JAYQ_HELPERS = { val, formErr, router2, TIPE_BADGE };
})();

/* =========================================================
 * ADMIN PAGES
 * ========================================================= */
(() => {
    const { pageHeader, emptyState } = window.JAYQ;
    const { val, formErr } = window.__JAYQ_HELPERS;
    const PAGES = window.PAGES;
    const ROLE_BADGE = { admin: 'badge-purple', dosen: 'badge-blue', mahasiswa: 'badge-green' };

    /* ---------- USERS ---------- */
    PAGES.users = async (view) => {
        let filter = 'all';
        const head = pageHeader('Manajemen Pengguna', 'Kelola admin, dosen, dan mahasiswa',
            `<button class="btn btn-primary" id="add-user">${UI.icon('plus','w-4 h-4')} Tambah Pengguna</button>`);
        async function load() {
            view.innerHTML = head + `
            <div class="flex flex-wrap gap-2 mb-4">
                ${['all','admin','dosen','mahasiswa'].map(r => `<button class="btn btn-sm ${filter===r?'btn-primary':'btn-ghost'} flt" data-r="${r}">${r==='all'?'Semua':r}</button>`).join('')}
            </div>` + UI.skeletonTable();
            const { data } = await API.get('/users' + (filter !== 'all' ? `?role=${filter}` : ''));
            const list = (data && data.data) || [];
            view.querySelector('.skeleton')?.closest('.card')?.remove();
            const tbl = document.createElement('div');
            tbl.className = 'card overflow-hidden animate-fade-up';
            tbl.innerHTML = `<div class="overflow-x-auto"><table class="tbl">
                <thead><tr><th>Nama</th><th>Email</th><th>Role</th><th>Aksi</th></tr></thead><tbody>
                ${list.map(u => `<tr>
                    <td class="flex items-center gap-3"><div class="w-9 h-9 rounded-full bg-gradient-to-br from-brand-500 to-cyan-400 flex items-center justify-center text-xs font-bold">${UI.initials(u.nama)}</div><span class="font-semibold text-white">${UI.esc(u.nama)}</span></td>
                    <td>${UI.esc(u.email)}</td>
                    <td><span class="badge ${ROLE_BADGE[u.role]}">${UI.esc(u.role)}</span></td>
                    <td><div class="flex gap-1">
                        <button class="btn btn-ghost btn-sm rp" data-id="${u.id}" title="Reset Password">${UI.icon('key','w-4 h-4')}</button>
                        <button class="btn btn-ghost btn-sm ed" data-id="${u.id}" title="Edit">${UI.icon('edit','w-4 h-4')}</button>
                        <button class="btn btn-ghost btn-sm del text-rose-300" data-id="${u.id}" title="Hapus">${UI.icon('trash','w-4 h-4')}</button>
                    </div></td></tr>`).join('') || `<tr><td colspan="4" class="text-center text-slate-500 py-8">Tidak ada pengguna</td></tr>`}
                </tbody></table></div>`;
            view.appendChild(tbl);
            view.querySelectorAll('.flt').forEach(b => b.onclick = () => { filter = b.dataset.r; load(); });
            document.getElementById('add-user').onclick = () => userForm();
            const byId = (id) => list.find(x => x.id == id);
            view.querySelectorAll('.ed').forEach(b => b.onclick = () => userForm(byId(b.dataset.id)));
            view.querySelectorAll('.rp').forEach(b => b.onclick = () => resetPass(b.dataset.id));
            view.querySelectorAll('.del').forEach(b => b.onclick = async () => {
                if (!await UI.confirm({ message: 'Hapus pengguna ini? Tindakan tidak dapat dibatalkan.' })) return;
                const r = await API.del(`/users/${b.dataset.id}`);
                if (r.ok) { UI.toast('success', 'Pengguna dihapus'); load(); } else UI.toast('error', 'Gagal', formErr(r.data));
            });
        }
        load();

        function userForm(item) {
            const edit = !!item;
            UI.modal({
                title: edit ? 'Edit Pengguna' : 'Tambah Pengguna', size: 'md',
                body: `<form id="uf" class="space-y-4">
                    <div><label class="label">Nama</label><input id="u-nama" class="input" value="${edit?UI.esc(item.nama):''}" required></div>
                    <div><label class="label">Email</label><input id="u-email" type="email" class="input" value="${edit?UI.esc(item.email):''}" required></div>
                    <div><label class="label">Password ${edit?'<span class="text-xs text-slate-500">(kosongkan jika tidak diubah)</span>':''}</label><input id="u-pass" type="password" class="input" placeholder="••••••"></div>
                    <div><label class="label">Role</label><select id="u-role" class="select">${['admin','dosen','mahasiswa'].map(r=>`<option value="${r}" ${edit&&item.role===r?'selected':''}>${r}</option>`).join('')}</select></div>
                </form>`,
                footer: `<button class="btn btn-ghost" onclick="UI.closeModal()">Batal</button><button class="btn btn-primary" id="u-save">Simpan</button>`,
                onMount: () => {
                    document.getElementById('u-save').onclick = async () => {
                        const payload = { nama: val('u-nama'), email: val('u-email'), role: val('u-role') };
                        const pass = val('u-pass');
                        if (pass) payload.password = pass;
                        if (!edit && !pass) return UI.toast('warning', 'Password wajib diisi');
                        const r = edit ? await API.put(`/users/${item.id}`, payload) : await API.post('/users', payload);
                        if (r.ok && r.data.success) { UI.closeModal(); UI.toast('success', edit?'Pengguna diperbarui':'Pengguna ditambahkan'); load(); }
                        else UI.toast('error', 'Gagal', formErr(r.data));
                    };
                }
            });
        }
        function resetPass(id) {
            UI.modal({
                title: 'Reset Password', size: 'sm',
                body: `<div><label class="label">Password Baru</label><input id="rp-new" type="password" class="input" placeholder="Min. 6 karakter"></div>`,
                footer: `<button class="btn btn-ghost" onclick="UI.closeModal()">Batal</button><button class="btn btn-primary" id="rp-save">Reset</button>`,
                onMount: () => { document.getElementById('rp-save').onclick = async () => {
                    const r = await API.post(`/users/${id}/reset-password`, { new_password: val('rp-new') });
                    if (r.ok && r.data.success) { UI.closeModal(); UI.toast('success', 'Password direset'); } else UI.toast('error', 'Gagal', formErr(r.data));
                }; }
            });
        }
    };

    /* ---------- MATA KULIAH (admin) ---------- */
    window.PG = window.PG || {};
    window.PG.matkulAdmin = async (view) => {
        const head = pageHeader('Mata Kuliah', 'Kelola data mata kuliah & peserta',
            `<button class="btn btn-primary" id="add-mk">${UI.icon('plus','w-4 h-4')} Tambah Mata Kuliah</button>`);
        async function load() {
            view.innerHTML = head + UI.skeletonTable();
            const [mkRes, dosenRes] = await Promise.all([API.get('/mata-kuliah'), API.get('/users?role=dosen')]);
            const list = (mkRes.data && mkRes.data.data) || [];
            const dosen = (dosenRes.data && dosenRes.data.data) || [];
            view.innerHTML = head + `<div class="card overflow-hidden animate-fade-up"><div class="overflow-x-auto"><table class="tbl">
                <thead><tr><th>Kode</th><th>Mata Kuliah</th><th>SKS</th><th>Dosen</th><th>Aksi</th></tr></thead><tbody>
                ${list.map(m => `<tr>
                    <td><span class="badge badge-blue">${UI.esc(m.kode_mk)}</span></td>
                    <td class="font-semibold text-white">${UI.esc(m.nama_mk)}</td>
                    <td>${m.sks ?? '-'}</td>
                    <td>${UI.esc((m.dosen||{}).nama || '-')}</td>
                    <td><div class="flex gap-1">
                        <button class="btn btn-ghost btn-sm ps" data-id="${m.id}" title="Peserta">${UI.icon('users','w-4 h-4')}</button>
                        <button class="btn btn-ghost btn-sm ed" data-id="${m.id}" title="Edit">${UI.icon('edit','w-4 h-4')}</button>
                        <button class="btn btn-ghost btn-sm del text-rose-300" data-id="${m.id}" title="Hapus">${UI.icon('trash','w-4 h-4')}</button>
                    </div></td></tr>`).join('') || `<tr><td colspan="5" class="text-center text-slate-500 py-8">Belum ada mata kuliah</td></tr>`}
                </tbody></table></div></div>`;
            const byId = (id) => list.find(x => x.id == id);
            document.getElementById('add-mk').onclick = () => mkForm(null, dosen);
            view.querySelectorAll('.ed').forEach(b => b.onclick = () => mkForm(byId(b.dataset.id), dosen));
            view.querySelectorAll('.ps').forEach(b => b.onclick = () => pesertaModal(byId(b.dataset.id)));
            view.querySelectorAll('.del').forEach(b => b.onclick = async () => {
                if (!await UI.confirm({ message: 'Hapus mata kuliah ini?' })) return;
                const r = await API.del(`/mata-kuliah/${b.dataset.id}`);
                if (r.ok) { UI.toast('success', 'Mata kuliah dihapus'); load(); } else UI.toast('error', 'Gagal', formErr(r.data));
            });
        }
        load();

        function mkForm(item, dosen) {
            const edit = !!item;
            UI.modal({
                title: edit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah', size: 'md',
                body: `<form id="mf" class="space-y-4">
                    <div class="grid grid-cols-2 gap-4">
                        <div><label class="label">Kode MK</label><input id="m-kode" class="input" value="${edit?UI.esc(item.kode_mk):''}" required></div>
                        <div><label class="label">SKS</label><input id="m-sks" type="number" min="1" max="6" class="input" value="${edit?(item.sks??''):''}" required></div>
                    </div>
                    <div><label class="label">Nama Mata Kuliah</label><input id="m-nama" class="input" value="${edit?UI.esc(item.nama_mk):''}" required></div>
                    <div><label class="label">Semester</label><input id="m-sem" class="input" value="${edit?UI.esc(item.semester||''):''}" placeholder="Ganjil 2025/2026" required></div>
                    <div><label class="label">Dosen Pengampu</label><select id="m-dosen" class="select">${dosen.map(d=>`<option value="${d.id}" ${edit&&item.dosen_id==d.id?'selected':''}>${UI.esc(d.nama)}</option>`).join('')}</select></div>
                </form>`,
                footer: `<button class="btn btn-ghost" onclick="UI.closeModal()">Batal</button><button class="btn btn-primary" id="m-save">Simpan</button>`,
                onMount: () => { document.getElementById('m-save').onclick = async () => {
                    const payload = { kode_mk: val('m-kode'), nama_mk: val('m-nama'), sks: parseInt(val('m-sks'))||0, semester: val('m-sem'), dosen_id: parseInt(val('m-dosen')) };
                    const r = edit ? await API.put(`/mata-kuliah/${item.id}`, payload) : await API.post('/mata-kuliah', payload);
                    if (r.ok && r.data.success) { UI.closeModal(); UI.toast('success', edit?'Diperbarui':'Ditambahkan'); load(); } else UI.toast('error', 'Gagal', formErr(r.data));
                }; }
            });
        }

        async function pesertaModal(mk) {
            UI.modal({ title: `Peserta — ${mk.nama_mk}`, size: 'lg', body: `<div id="ps-body"><div class="skeleton h-32 w-full"></div></div>` });
            const [pRes, mRes] = await Promise.all([API.get(`/mata-kuliah/${mk.id}/peserta`), API.get('/users?role=mahasiswa')]);
            const peserta = ((pRes.data && pRes.data.data && pRes.data.data.peserta) || []);
            const mhs = (mRes.data && mRes.data.data) || [];
            const enrolledIds = peserta.map(p => p.mahasiswa_id);
            const render = () => {
                document.getElementById('ps-body').innerHTML = `
                <div class="flex gap-2 mb-4">
                    <select id="ps-sel" class="select">${mhs.filter(m=>!enrolledIds.includes(m.id)).map(m=>`<option value="${m.id}">${UI.esc(m.nama)}</option>`).join('') || '<option value="">— semua sudah terdaftar —</option>'}</select>
                    <button class="btn btn-primary" id="ps-add">Tambah</button>
                </div>
                <div class="space-y-2 max-h-80 overflow-y-auto">
                ${peserta.map(p => `<div class="flex items-center justify-between rounded-lg border border-white/10 px-3 py-2">
                    <div class="flex items-center gap-3"><div class="w-8 h-8 rounded-full bg-gradient-to-br from-brand-500 to-cyan-400 flex items-center justify-center text-xs font-bold">${UI.initials((p.mahasiswa||{}).nama)}</div><span class="text-sm text-white">${UI.esc((p.mahasiswa||{}).nama||'-')}</span></div>
                    <button class="btn btn-ghost btn-sm text-rose-300 rm" data-id="${p.id}">${UI.icon('trash','w-4 h-4')}</button>
                </div>`).join('') || '<p class="text-slate-500 text-sm text-center py-4">Belum ada peserta</p>'}
                </div>`;
                const addBtn = document.getElementById('ps-add');
                addBtn.onclick = async () => {
                    const id = val('ps-sel'); if (!id) return;
                    const r = await API.post('/peserta-mk', { mahasiswa_id: parseInt(id), mata_kuliah_id: mk.id });
                    if (r.ok && r.data.success) { UI.toast('success', 'Peserta ditambahkan'); pesertaModal(mk); } else UI.toast('error', 'Gagal', formErr(r.data));
                };
                document.querySelectorAll('.rm').forEach(b => b.onclick = async () => {
                    const r = await API.del(`/peserta-mk/${b.dataset.id}`);
                    if (r.ok) { UI.toast('success', 'Peserta dihapus'); pesertaModal(mk); } else UI.toast('error', 'Gagal', formErr(r.data));
                });
            };
            render();
        }
    };

    /* ---------- DATA ABSENSI (admin) ---------- */
    PAGES.absensi = async (view) => {
        view.innerHTML = pageHeader('Data Absensi', 'Seluruh rekaman absensi mahasiswa') + UI.skeletonTable();
        const { data } = await API.get('/absensi/all');
        const list = (data && data.data) || [];
        view.innerHTML = pageHeader('Data Absensi', 'Seluruh rekaman absensi mahasiswa') +
            (list.length ? `<div class="card overflow-hidden animate-fade-up"><div class="overflow-x-auto"><table class="tbl">
            <thead><tr><th>Mahasiswa</th><th>Mata Kuliah</th><th>Tanggal</th><th>Jam</th><th>Status</th></tr></thead><tbody>
            ${list.map(a => `<tr>
                <td class="font-semibold text-white">${UI.esc((a.mahasiswa||{}).nama || '-')}</td>
                <td>${UI.esc((a.mata_kuliah||{}).nama_mk || '-')} <span class="text-xs text-slate-500">${UI.esc((a.mata_kuliah||{}).kode_mk||'')}</span></td>
                <td>${UI.fmtDate(a.tanggal)}</td>
                <td>${UI.esc(a.jam || '-')}</td>
                <td><span class="badge badge-green">${UI.esc(a.status || 'hadir')}</span></td>
            </tr>`).join('')}
            </tbody></table></div></div>` : emptyState('Belum ada data absensi.', 'clipboard'));
    };

    /* ---------- NOTIFIKASI (admin) ---------- */
    PAGES.notifikasi = async (view) => {
        view.innerHTML = pageHeader('Notifikasi Push', 'Kirim notifikasi ke pengguna') + `
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-5">
            <div class="card p-6 animate-fade-up">
                <h3 class="font-bold text-white mb-4">Kirim Notifikasi</h3>
                <form id="nt-f" class="space-y-4">
                    <div><label class="label">Judul</label><input id="nt-title" class="input" required></div>
                    <div><label class="label">Pesan</label><textarea id="nt-body" class="textarea" rows="3" required></textarea></div>
                    <div><label class="label">Target</label><select id="nt-target" class="select"><option value="all">Semua</option><option value="dosen">Dosen</option><option value="mahasiswa">Mahasiswa</option></select></div>
                    <button class="btn btn-primary" id="nt-send">${UI.icon('send','w-4 h-4')} Kirim</button>
                </form>
            </div>
            <div class="card p-6 animate-fade-up">
                <h3 class="font-bold text-white mb-4">Riwayat</h3>
                <div id="nt-hist" class="text-sm text-slate-400">Memuat...</div>
            </div>
        </div>`;
        const hist = await API.get('/notifications/history');
        const hl = (hist.data && hist.data.data) || [];
        document.getElementById('nt-hist').innerHTML = hl.length ? hl.map(h=>`<div class="border-b border-white/5 py-2">${UI.esc(h.title||'')}</div>`).join('') : 'Belum ada riwayat notifikasi.';
        document.getElementById('nt-f').onsubmit = async (e) => {
            e.preventDefault();
            const btn = document.getElementById('nt-send'); btn.disabled = true;
            const r = await API.post('/notifications/send', { title: val('nt-title'), body: val('nt-body'), target: val('nt-target') });
            btn.disabled = false;
            if (r.ok && r.data.success) { UI.toast('success', 'Terkirim', `${(r.data.data||{}).recipients ?? 0} penerima`); document.getElementById('nt-f').reset(); }
            else UI.toast('warning', 'Info', formErr(r.data));
        };
    };

    /* ---------- EXPORT (admin) ---------- */
    PAGES.export = async (view) => {
        const items = [
            ['Data Absensi', 'absensi', 'clipboard'],
            ['Data Mahasiswa', 'mahasiswa', 'users'],
            ['Data Dosen', 'dosen', 'graduation'],
            ['Data Mata Kuliah', 'mata-kuliah', 'book'],
        ];
        view.innerHTML = pageHeader('Export Data', 'Unduh data dalam format CSV') + `
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
        ${items.map(([label,key,ic]) => `
            <div class="card p-6 flex items-center justify-between animate-fade-up">
                <div class="flex items-center gap-4">
                    <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-brand-500/20 to-violet-500/10 text-brand-300 flex items-center justify-center">${UI.icon(ic,'w-6 h-6')}</div>
                    <div><p class="font-bold text-white">${label}</p><p class="text-xs text-slate-400">Format CSV</p></div>
                </div>
                <button class="btn btn-primary ex" data-k="${key}">${UI.icon('download','w-4 h-4')} Unduh</button>
            </div>`).join('')}
        </div>`;
        view.querySelectorAll('.ex').forEach(b => b.onclick = async () => {
            b.disabled = true;
            const r = await API.get('/export/' + b.dataset.k);
            b.disabled = false;
            if (r.ok && r.data.success) {
                const { csv, filename } = r.data.data;
                const blob = new Blob([atob(csv)], { type: 'text/csv' });
                const a = document.createElement('a');
                a.href = URL.createObjectURL(blob); a.download = filename || 'export.csv'; a.click();
                URL.revokeObjectURL(a.href);
                UI.toast('success', 'Berhasil diunduh', `${r.data.data.total_records ?? 0} baris`);
            } else UI.toast('error', 'Gagal', formErr(r.data));
        });
    };
})();

/* =========================================================
 * DOSEN PAGES
 * ========================================================= */
(() => {
    const { pageHeader, emptyState, fileUrl } = window.JAYQ;
    const { val, formErr } = window.__JAYQ_HELPERS;
    const PG = (window.PG = window.PG || {});

    const qrImg = (code) => `https://api.qrserver.com/v1/create-qr-code/?size=220x220&margin=8&data=${encodeURIComponent(code)}`;

    async function dosenMatkulOptions() {
        const r = await API.get('/mata-kuliah/dosen/me');
        return (r.data && r.data.data) || [];
    }

    /* ---------- MATA KULIAH (dosen) ---------- */
    PG.matkulDosen = async (view) => {
        view.innerHTML = pageHeader('Mata Kuliah Saya', 'Mata kuliah yang Anda ampu') + UI.skeletonCards(2);
        const list = await dosenMatkulOptions();
        view.innerHTML = pageHeader('Mata Kuliah Saya', 'Mata kuliah yang Anda ampu') +
            (list.length ? `<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">${list.map(m => `
                <div class="card p-5 animate-fade-up">
                    <div class="flex items-center justify-between"><span class="badge badge-blue">${UI.esc(m.kode_mk)}</span><span class="text-xs text-slate-400">${(m.peserta||[]).length} peserta</span></div>
                    <h3 class="font-bold text-white mt-3">${UI.esc(m.nama_mk)}</h3>
                    <p class="text-xs text-slate-500 mt-1">${m.sks?m.sks+' SKS':''} ${m.semester?'• '+UI.esc(m.semester):''}</p>
                    <div class="flex gap-2 mt-4">
                        <button class="btn btn-ghost btn-sm vp" data-id="${m.id}" data-n="${UI.esc(m.nama_mk)}">${UI.icon('users','w-4 h-4')} Peserta</button>
                        <button class="btn btn-ghost btn-sm va" data-id="${m.id}" data-n="${UI.esc(m.nama_mk)}">${UI.icon('clipboard','w-4 h-4')} Absensi</button>
                    </div>
                </div>`).join('')}</div>` : emptyState('Anda belum mengampu mata kuliah.', 'book'));

        view.querySelectorAll('.vp').forEach(b => b.onclick = async () => {
            UI.modal({ title: `Peserta — ${b.dataset.n}`, size: 'md', body: `<div id="pb"><div class="skeleton h-24 w-full"></div></div>` });
            const r = await API.get(`/mata-kuliah/${b.dataset.id}/peserta`);
            const ps = ((r.data&&r.data.data&&r.data.data.peserta)||[]);
            document.getElementById('pb').innerHTML = ps.length ? `<div class="space-y-2">${ps.map(p=>`
                <div class="flex items-center gap-3 rounded-lg border border-white/10 px-3 py-2"><div class="w-8 h-8 rounded-full bg-gradient-to-br from-brand-500 to-cyan-400 flex items-center justify-center text-xs font-bold">${UI.initials((p.mahasiswa||{}).nama)}</div><div><p class="text-sm text-white">${UI.esc((p.mahasiswa||{}).nama||'-')}</p><p class="text-xs text-slate-500">${UI.esc((p.mahasiswa||{}).email||'')}</p></div></div>`).join('')}</div>` : '<p class="text-slate-500 text-sm text-center py-4">Belum ada peserta</p>';
        });
        view.querySelectorAll('.va').forEach(b => b.onclick = async () => {
            UI.modal({ title: `Absensi — ${b.dataset.n}`, size: 'lg', body: `<div id="ab"><div class="skeleton h-24 w-full"></div></div>` });
            const r = await API.get(`/mata-kuliah/${b.dataset.id}/absensi`);
            const ab = (r.data&&r.data.data)||[];
            document.getElementById('ab').innerHTML = ab.length ? `<div class="overflow-x-auto"><table class="tbl"><thead><tr><th>Mahasiswa</th><th>Tanggal</th><th>Jam</th><th>Status</th></tr></thead><tbody>
                ${ab.map(a=>`<tr><td class="text-white">${UI.esc((a.mahasiswa||{}).nama||'-')}</td><td>${UI.fmtDate(a.tanggal)}</td><td>${UI.esc(a.jam||'-')}</td><td><span class="badge badge-green">${UI.esc(a.status||'hadir')}</span></td></tr>`).join('')}
                </tbody></table></div>` : '<p class="text-slate-500 text-sm text-center py-4">Belum ada absensi</p>';
        });
    };

    /* ---------- GENERATE QR ---------- */
    PG.qr = async (view) => {
        view.innerHTML = pageHeader('Generate QR Absensi', 'Buat kode QR untuk sesi absensi') + `<div class="skeleton h-40 w-full max-w-md"></div>`;
        const mks = await dosenMatkulOptions();
        async function loadSessions() {
            const r = await API.get('/qr-sessions');
            const list = (r.data && r.data.data) || [];
            const el = document.getElementById('qr-sessions');
            if (!el) return;
            el.innerHTML = list.length ? list.map(s => {
                const active = new Date(s.expired_at.replace(' ','T')) > new Date();
                return `<div class="flex items-center justify-between rounded-lg border border-white/10 px-4 py-3">
                    <div><p class="text-sm font-semibold text-white">${UI.esc((s.mata_kuliah||{}).nama_mk||'-')}</p><p class="text-xs text-slate-500">${UI.fmtDateTime(s.expired_at)} • ${UI.esc(s.kode_qr.slice(0,16))}…</p></div>
                    <div class="flex items-center gap-2">
                        <span class="badge ${active?'badge-green':'badge-slate'}">${active?UI.timeLeft(s.expired_at):'Berakhir'}</span>
                        ${active?`<button class="btn btn-ghost btn-sm cls text-rose-300" data-id="${s.id}">Tutup</button>`:''}
                    </div></div>`;
            }).join('') : '<p class="text-slate-500 text-sm">Belum ada sesi QR.</p>';
            el.querySelectorAll('.cls').forEach(b => b.onclick = async () => {
                if (!await UI.confirm({ message: 'Tutup sesi QR ini?' })) return;
                await API.put(`/qr-sessions/${b.dataset.id}/close`); UI.toast('success', 'Sesi ditutup'); loadSessions();
            });
        }
        view.innerHTML = pageHeader('Generate QR Absensi', 'Buat kode QR untuk sesi absensi') + `
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-5">
            <div class="card p-6 animate-fade-up">
                <form id="qr-f" class="space-y-4">
                    <div><label class="label">Mata Kuliah</label><select id="qr-mk" class="select">${mks.map(m=>`<option value="${m.id}">${UI.esc(m.nama_mk)} (${UI.esc(m.kode_mk)})</option>`).join('')||'<option value="">— tidak ada —</option>'}</select></div>
                    <div><label class="label">Durasi (menit)</label><input id="qr-dur" type="number" min="1" max="60" value="15" class="input"></div>
                    <button class="btn btn-primary w-full" id="qr-gen">${UI.icon('qr','w-4 h-4')} Generate QR</button>
                </form>
                <div id="qr-result" class="mt-5"></div>
            </div>
            <div class="card p-6 animate-fade-up">
                <h3 class="font-bold text-white mb-4">Riwayat Sesi QR</h3>
                <div id="qr-sessions" class="space-y-2 max-h-[420px] overflow-y-auto"><div class="skeleton h-16 w-full"></div></div>
            </div>
        </div>`;
        loadSessions();
        document.getElementById('qr-f').onsubmit = async (e) => {
            e.preventDefault();
            const mk = val('qr-mk'); if (!mk) return UI.toast('warning', 'Pilih mata kuliah');
            const btn = document.getElementById('qr-gen'); btn.disabled = true;
            const r = await API.post('/generate-qr', { mata_kuliah_id: parseInt(mk), duration: parseInt(val('qr-dur'))||15 });
            btn.disabled = false;
            if (r.ok && r.data.success) {
                const d = r.data.data;
                document.getElementById('qr-result').innerHTML = `
                    <div class="text-center rounded-xl border border-white/10 p-5 bg-white/[.02] animate-pop">
                        <img src="${qrImg(d.kode_qr)}" alt="QR" class="mx-auto rounded-lg bg-white p-2" width="220" height="220">
                        <p class="text-xs text-slate-400 mt-3">Berlaku hingga ${UI.fmtDateTime(d.expired_at)}</p>
                        <div class="mt-2 flex items-center gap-2 justify-center">
                            <code class="text-xs bg-black/40 px-2 py-1 rounded truncate max-w-[200px]">${UI.esc(d.kode_qr)}</code>
                            <button class="btn btn-ghost btn-sm" id="qr-copy">Salin</button>
                        </div>
                    </div>`;
                document.getElementById('qr-copy').onclick = () => { navigator.clipboard.writeText(d.kode_qr); UI.toast('success', 'Kode disalin'); };
                UI.toast('success', 'QR berhasil dibuat'); loadSessions();
            } else UI.toast('error', 'Gagal', formErr(r.data));
        };
    };

    /* ---------- REKAP ABSENSI ---------- */
    PG.rekap = async (view) => {
        view.innerHTML = pageHeader('Rekap Absensi', 'Rekapitulasi kehadiran mahasiswa') + UI.skeletonTable();
        const { data } = await API.get('/rekap-absensi');
        const list = (data && data.data) || [];
        view.innerHTML = pageHeader('Rekap Absensi', 'Rekapitulasi kehadiran mahasiswa') +
            (list.length ? `<div class="card overflow-hidden animate-fade-up"><div class="overflow-x-auto"><table class="tbl">
            <thead><tr><th>Mahasiswa</th><th>Mata Kuliah</th><th>Tanggal</th><th>Jam</th><th>Status</th></tr></thead><tbody>
            ${list.map(a=>`<tr><td class="text-white font-semibold">${UI.esc((a.mahasiswa||{}).nama||'-')}</td><td>${UI.esc((a.mata_kuliah||{}).nama_mk||'-')}</td><td>${UI.fmtDate(a.tanggal)}</td><td>${UI.esc(a.jam||'-')}</td><td><span class="badge badge-green">${UI.esc(a.status||'hadir')}</span></td></tr>`).join('')}
            </tbody></table></div></div>` : emptyState('Belum ada rekap absensi.', 'clipboard'));
    };

    /* ---------- TUGAS (dosen) ---------- */
    PG.tugasDosen = async (view) => {
        const head = pageHeader('Kelola Tugas', 'Buat tugas & nilai pengumpulan',
            `<button class="btn btn-primary" id="add-tg">${UI.icon('plus','w-4 h-4')} Buat Tugas</button>`);
        const mks = await dosenMatkulOptions();
        async function load() {
            view.innerHTML = head + UI.skeletonTable();
            const { data } = await API.get('/tugas');
            const list = (data && data.data) || [];
            view.innerHTML = head + (list.length ? `<div class="grid grid-cols-1 md:grid-cols-2 gap-5">${list.map(t => `
                <div class="card p-5 animate-fade-up">
                    <div class="flex items-center justify-between"><span class="badge badge-blue">${UI.esc((t.mata_kuliah||{}).kode_mk||'')}</span><span class="text-xs text-slate-400">${UI.icon('clock','w-3 h-3 inline')} ${UI.fmtDateTime(t.deadline)}</span></div>
                    <h3 class="font-bold text-white mt-3">${UI.esc(t.judul)}</h3>
                    <p class="text-sm text-slate-400 mt-1 line-clamp-2">${UI.esc(t.deskripsi||'-')}</p>
                    <div class="flex gap-2 mt-4">
                        <button class="btn btn-ghost btn-sm vw" data-id="${t.id}" data-n="${UI.esc(t.judul)}">${UI.icon('eye','w-4 h-4')} Pengumpulan</button>
                        <button class="btn btn-ghost btn-sm ed" data-id="${t.id}">${UI.icon('edit','w-4 h-4')}</button>
                        <button class="btn btn-ghost btn-sm del text-rose-300" data-id="${t.id}">${UI.icon('trash','w-4 h-4')}</button>
                    </div>
                </div>`).join('')}</div>` : emptyState('Belum ada tugas.', 'file'));
            const byId = (id) => list.find(x => x.id == id);
            document.getElementById('add-tg').onclick = () => tugasForm(null, mks);
            view.querySelectorAll('.ed').forEach(b => b.onclick = () => tugasForm(byId(b.dataset.id), mks));
            view.querySelectorAll('.vw').forEach(b => b.onclick = () => pengumpulanModal(b.dataset.id, b.dataset.n));
            view.querySelectorAll('.del').forEach(b => b.onclick = async () => {
                if (!await UI.confirm({ message: 'Hapus tugas ini?' })) return;
                const r = await API.del(`/tugas/${b.dataset.id}`);
                if (r.ok) { UI.toast('success', 'Tugas dihapus'); load(); } else UI.toast('error', 'Gagal', formErr(r.data));
            });
        }
        load();

        function tugasForm(item, mks) {
            const edit = !!item;
            const dl = edit && item.deadline ? new Date(item.deadline.replace(' ','T')).toISOString().slice(0,16) : '';
            UI.modal({
                title: edit ? 'Edit Tugas' : 'Buat Tugas', size: 'md',
                body: `<form id="tf" class="space-y-4">
                    <div><label class="label">Mata Kuliah</label><select id="t-mk" class="select" ${edit?'disabled':''}>${mks.map(m=>`<option value="${m.id}" ${edit&&item.mata_kuliah_id==m.id?'selected':''}>${UI.esc(m.nama_mk)}</option>`).join('')}</select></div>
                    <div><label class="label">Judul</label><input id="t-judul" class="input" value="${edit?UI.esc(item.judul):''}" required></div>
                    <div><label class="label">Deskripsi</label><textarea id="t-desk" class="textarea" rows="3">${edit?UI.esc(item.deskripsi||''):''}</textarea></div>
                    <div><label class="label">Deadline</label><input id="t-dl" type="datetime-local" class="input" value="${dl}" required></div>
                    <div><label class="label">File Tugas <span class="text-xs text-slate-500">(pdf/doc, opsional)</span></label><input id="t-file" type="file" accept=".pdf,.doc,.docx" class="input"></div>
                </form>`,
                footer: `<button class="btn btn-ghost" onclick="UI.closeModal()">Batal</button><button class="btn btn-primary" id="t-save">Simpan</button>`,
                onMount: () => { document.getElementById('t-save').onclick = async () => {
                    const fd = new FormData();
                    if (!edit) fd.append('mata_kuliah_id', val('t-mk'));
                    fd.append('judul', val('t-judul'));
                    fd.append('deskripsi', val('t-desk'));
                    fd.append('deadline', val('t-dl').replace('T',' ') + ':00');
                    const f = document.getElementById('t-file').files[0];
                    if (f) fd.append('file_tugas', f);
                    let r;
                    if (edit) { fd.append('_method', 'PUT'); r = await API.postForm(`/tugas/${item.id}`, fd); }
                    else r = await API.postForm('/tugas', fd);
                    if (r.ok && r.data.success) { UI.closeModal(); UI.toast('success', edit?'Tugas diperbarui':'Tugas dibuat'); load(); }
                    else UI.toast('error', 'Gagal', formErr(r.data));
                }; }
            });
        }

        async function pengumpulanModal(id, nama) {
            UI.modal({ title: `Pengumpulan — ${nama}`, size: 'lg', body: `<div id="pb"><div class="skeleton h-24 w-full"></div></div>` });
            const r = await API.get(`/tugas/${id}/pengumpulan`);
            const ps = ((r.data&&r.data.data&&r.data.data.pengumpulan)||[]);
            const render = () => {
                document.getElementById('pb').innerHTML = ps.length ? `<div class="space-y-3">${ps.map(p=>`
                    <div class="rounded-xl border border-white/10 p-4">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-3"><div class="w-9 h-9 rounded-full bg-gradient-to-br from-brand-500 to-cyan-400 flex items-center justify-center text-xs font-bold">${UI.initials((p.mahasiswa||{}).nama)}</div><div><p class="text-sm font-semibold text-white">${UI.esc((p.mahasiswa||{}).nama||'-')}</p><p class="text-xs text-slate-500">${UI.fmtDateTime(p.tanggal_upload)}</p></div></div>
                            <div class="flex items-center gap-2">
                                ${p.nilai!=null?`<span class="badge badge-green">Nilai: ${p.nilai}</span>`:'<span class="badge badge-yellow">Belum dinilai</span>'}
                                <a href="${fileUrl(p.file_jawaban)}" target="_blank" class="btn btn-ghost btn-sm">${UI.icon('download','w-4 h-4')}</a>
                                <button class="btn btn-primary btn-sm gr" data-id="${p.id}" data-nilai="${p.nilai??''}" data-cat="${UI.esc(p.catatan||'')}">Nilai</button>
                            </div>
                        </div>
                        ${p.catatan?`<p class="text-xs text-slate-400 mt-2 border-t border-white/5 pt-2">Catatan: ${UI.esc(p.catatan)}</p>`:''}
                    </div>`).join('')}</div>` : '<p class="text-slate-500 text-sm text-center py-4">Belum ada pengumpulan.</p>';
                document.querySelectorAll('.gr').forEach(b => b.onclick = () => nilaiForm(b.dataset.id, b.dataset.nilai, b.dataset.cat));
            };
            render();
            function nilaiForm(pid, nilai, catatan) {
                UI.modal({ title: 'Beri Nilai', size: 'sm',
                    body: `<form id="nf" class="space-y-4"><div><label class="label">Nilai (0-100)</label><input id="n-nilai" type="number" min="0" max="100" class="input" value="${nilai||''}"></div><div><label class="label">Catatan</label><textarea id="n-cat" class="textarea" rows="2">${catatan||''}</textarea></div></form>`,
                    footer: `<button class="btn btn-ghost" onclick="UI.closeModal()">Batal</button><button class="btn btn-primary" id="n-save">Simpan</button>`,
                    onMount: () => { document.getElementById('n-save').onclick = async () => {
                        const r2 = await API.put(`/pengumpulan-tugas/${pid}/nilai`, { nilai: parseInt(val('n-nilai')), catatan: val('n-cat') });
                        if (r2.ok && r2.data.success) { UI.toast('success', 'Nilai disimpan'); pengumpulanModal(id, nama); }
                        else UI.toast('error', 'Gagal', formErr(r2.data));
                    }; }
                });
            }
        }
    };

    /* ---------- MATERI (dosen) ---------- */
    PG.materiDosen = async (view) => {
        const head = pageHeader('Materi Perkuliahan', 'Upload & kelola materi',
            `<button class="btn btn-primary" id="add-mt">${UI.icon('upload','w-4 h-4')} Upload Materi</button>`);
        const mks = await dosenMatkulOptions();
        async function load() {
            view.innerHTML = head + UI.skeletonTable();
            const { data } = await API.get('/materi');
            const list = (data && data.data) || [];
            view.innerHTML = head + (list.length ? `<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">${list.map(m => `
                <div class="card p-5 animate-fade-up">
                    <div class="flex items-start justify-between">
                        <div class="w-11 h-11 rounded-xl bg-gradient-to-br from-amber-500/20 to-orange-500/10 text-amber-300 flex items-center justify-center">${UI.icon('file','w-5 h-5')}</div>
                        <span class="badge badge-blue">${UI.esc((m.mata_kuliah||{}).kode_mk||'')}</span>
                    </div>
                    <h3 class="font-bold text-white mt-3">${UI.esc(m.judul)}</h3>
                    <p class="text-sm text-slate-400 mt-1 line-clamp-2">${UI.esc(m.deskripsi||'-')}</p>
                    <div class="flex gap-2 mt-4">
                        <a href="${fileUrl(m.file_materi)}" target="_blank" class="btn btn-ghost btn-sm flex-1">${UI.icon('download','w-4 h-4')} Unduh</a>
                        <button class="btn btn-ghost btn-sm del text-rose-300" data-id="${m.id}">${UI.icon('trash','w-4 h-4')}</button>
                    </div>
                </div>`).join('')}</div>` : emptyState('Belum ada materi.', 'book'));
            document.getElementById('add-mt').onclick = () => materiForm(mks);
            view.querySelectorAll('.del').forEach(b => b.onclick = async () => {
                if (!await UI.confirm({ message: 'Hapus materi ini?' })) return;
                const r = await API.del(`/materi/${b.dataset.id}`);
                if (r.ok) { UI.toast('success', 'Materi dihapus'); load(); } else UI.toast('error', 'Gagal', formErr(r.data));
            });
        }
        load();
        function materiForm(mks) {
            UI.modal({ title: 'Upload Materi', size: 'md',
                body: `<form id="mtf" class="space-y-4">
                    <div><label class="label">Mata Kuliah</label><select id="mt-mk" class="select">${mks.map(m=>`<option value="${m.id}">${UI.esc(m.nama_mk)}</option>`).join('')}</select></div>
                    <div><label class="label">Judul</label><input id="mt-judul" class="input" required></div>
                    <div><label class="label">Deskripsi</label><textarea id="mt-desk" class="textarea" rows="2"></textarea></div>
                    <div><label class="label">File <span class="text-xs text-slate-500">(pdf/doc/ppt)</span></label><input id="mt-file" type="file" accept=".pdf,.doc,.docx,.ppt,.pptx" class="input" required></div>
                </form>`,
                footer: `<button class="btn btn-ghost" onclick="UI.closeModal()">Batal</button><button class="btn btn-primary" id="mt-save">Upload</button>`,
                onMount: () => { document.getElementById('mt-save').onclick = async () => {
                    const f = document.getElementById('mt-file').files[0];
                    if (!f) return UI.toast('warning', 'Pilih file');
                    const fd = new FormData();
                    fd.append('mata_kuliah_id', val('mt-mk')); fd.append('judul', val('mt-judul'));
                    fd.append('deskripsi', val('mt-desk')); fd.append('file_materi', f);
                    const r = await API.postForm('/materi', fd);
                    if (r.ok && r.data.success) { UI.closeModal(); UI.toast('success', 'Materi diupload'); load(); }
                    else UI.toast('error', 'Gagal', formErr(r.data));
                }; }
            });
        }
    };
})();

/* =========================================================
 * MAHASISWA PAGES
 * ========================================================= */
(() => {
    const { pageHeader, emptyState, fileUrl } = window.JAYQ;
    const { val, formErr } = window.__JAYQ_HELPERS;
    const PG = (window.PG = window.PG || {});

    /* ---------- SCAN ABSENSI ---------- */
    PG.scan = async (view) => {
        view.innerHTML = pageHeader('Scan Absensi', 'Masukkan kode QR dari dosen untuk absen') + `
        <div class="max-w-md mx-auto">
            <div class="card p-6 animate-fade-up text-center">
                <div class="w-16 h-16 mx-auto rounded-2xl bg-gradient-to-br from-brand-500/30 to-violet-500/20 text-brand-300 flex items-center justify-center mb-4">${UI.icon('scan','w-8 h-8')}</div>
                <h3 class="font-bold text-white text-lg">Absensi Kehadiran</h3>
                <p class="text-sm text-slate-400 mt-1 mb-5">Tempel/ketik kode QR yang ditampilkan dosen.</p>
                <form id="sc-f" class="space-y-3 text-left">
                    <div><label class="label">Kode QR</label><input id="sc-code" class="input" placeholder="Contoh: aB3x...-1700000000" required></div>
                    <label class="flex items-center gap-2 text-xs text-slate-400"><input type="checkbox" id="sc-geo" class="accent-brand-500"> Sertakan lokasi (opsional)</label>
                    <button class="btn btn-primary w-full" id="sc-btn">${UI.icon('check','w-4 h-4')} Absen Sekarang</button>
                </form>
            </div>
        </div>`;
        document.getElementById('sc-f').onsubmit = async (e) => {
            e.preventDefault();
            const btn = document.getElementById('sc-btn'); btn.disabled = true;
            const payload = { kode_qr: val('sc-code') };
            if (document.getElementById('sc-geo').checked && navigator.geolocation) {
                try {
                    const pos = await new Promise((res, rej) => navigator.geolocation.getCurrentPosition(res, rej, { timeout: 6000 }));
                    payload.latitude = pos.coords.latitude; payload.longitude = pos.coords.longitude;
                } catch (_) { /* abaikan jika gagal */ }
            }
            const r = await API.post('/scan-qr', payload);
            btn.disabled = false;
            if (r.ok && r.data.success) {
                UI.toast('success', 'Absensi berhasil!', `${(r.data.data.mata_kuliah||{}).nama_mk||''}`);
                document.getElementById('sc-f').reset();
            } else UI.toast('error', 'Gagal absen', formErr(r.data));
        };
    };

    /* ---------- RIWAYAT ABSENSI ---------- */
    PG.riwayat = async (view) => {
        view.innerHTML = pageHeader('Riwayat Absensi', 'Catatan kehadiran Anda') + UI.skeletonTable();
        const { data } = await API.get('/riwayat-absensi');
        const list = (data && data.data) || [];
        view.innerHTML = pageHeader('Riwayat Absensi', 'Catatan kehadiran Anda') +
            (list.length ? `<div class="card overflow-hidden animate-fade-up"><div class="overflow-x-auto"><table class="tbl">
            <thead><tr><th>Mata Kuliah</th><th>Tanggal</th><th>Jam</th><th>Status</th></tr></thead><tbody>
            ${list.map(a=>`<tr><td class="font-semibold text-white">${UI.esc((a.mata_kuliah||{}).nama_mk||'-')} <span class="text-xs text-slate-500">${UI.esc((a.mata_kuliah||{}).kode_mk||'')}</span></td><td>${UI.fmtDate(a.tanggal)}</td><td>${UI.esc(a.jam||'-')}</td><td><span class="badge badge-green">${UI.esc(a.status||'hadir')}</span></td></tr>`).join('')}
            </tbody></table></div></div>` : emptyState('Belum ada riwayat absensi.', 'history'));
    };

    /* ---------- MATA KULIAH (mahasiswa) ---------- */
    PG.matkulMhs = async (view) => {
        view.innerHTML = pageHeader('Mata Kuliah Saya', 'Mata kuliah yang Anda ikuti') + UI.skeletonCards(3);
        const { data } = await API.get('/mata-kuliah/mahasiswa/me');
        const list = (data && data.data) || [];
        view.innerHTML = pageHeader('Mata Kuliah Saya', 'Mata kuliah yang Anda ikuti') +
            (list.length ? `<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">${list.map(m=>`
                <div class="card p-5 animate-fade-up">
                    <span class="badge badge-blue">${UI.esc(m.kode_mk)}</span>
                    <h3 class="font-bold text-white mt-3">${UI.esc(m.nama_mk)}</h3>
                    <p class="text-xs text-slate-500 mt-1">${m.sks?m.sks+' SKS':''} ${m.semester?'• '+UI.esc(m.semester):''}</p>
                    <div class="flex items-center gap-2 mt-4 pt-3 border-t border-white/5">
                        <div class="w-7 h-7 rounded-full bg-gradient-to-br from-brand-500 to-cyan-400 flex items-center justify-center text-[10px] font-bold">${UI.initials((m.dosen||{}).nama)}</div>
                        <span class="text-xs text-slate-400">${UI.esc((m.dosen||{}).nama||'-')}</span>
                    </div>
                </div>`).join('')}</div>` : emptyState('Anda belum mengambil mata kuliah.', 'book'));
    };

    /* ---------- TUGAS (mahasiswa) ---------- */
    PG.tugasMhs = async (view) => {
        async function load() {
            view.innerHTML = pageHeader('Tugas Saya', 'Lihat & kumpulkan tugas') + UI.skeletonTable();
            const { data } = await API.get('/tugas/mahasiswa/me');
            const list = (data && data.data) || [];
            view.innerHTML = pageHeader('Tugas Saya', 'Lihat & kumpulkan tugas') +
                (list.length ? `<div class="grid grid-cols-1 md:grid-cols-2 gap-5">${list.map(t=>{
                    const done = t.sudah_dikumpulkan;
                    const nilai = t.pengumpulan && t.pengumpulan.nilai != null ? t.pengumpulan.nilai : null;
                    const overdue = new Date(t.deadline.replace(' ','T')) < new Date();
                    return `<div class="card p-5 animate-fade-up">
                        <div class="flex items-center justify-between"><span class="badge badge-blue">${UI.esc((t.mata_kuliah||{}).kode_mk||'')}</span>
                        ${done?(nilai!=null?`<span class="badge badge-green">Nilai: ${nilai}</span>`:'<span class="badge badge-purple">Terkumpul</span>'):(overdue?'<span class="badge badge-red">Terlambat</span>':'<span class="badge badge-yellow">Belum</span>')}</div>
                        <h3 class="font-bold text-white mt-3">${UI.esc(t.judul)}</h3>
                        <p class="text-sm text-slate-400 mt-1 line-clamp-2">${UI.esc(t.deskripsi||'-')}</p>
                        <p class="text-xs text-slate-500 mt-2">${UI.icon('clock','w-3 h-3 inline')} Deadline: ${UI.fmtDateTime(t.deadline)}</p>
                        <div class="flex gap-2 mt-4">
                            ${t.file_tugas?`<a href="${fileUrl(t.file_tugas)}" target="_blank" class="btn btn-ghost btn-sm">${UI.icon('download','w-4 h-4')} Soal</a>`:''}
                            <button class="btn btn-primary btn-sm up flex-1" data-id="${t.id}" data-n="${UI.esc(t.judul)}">${UI.icon('upload','w-4 h-4')} ${done?'Ganti Jawaban':'Kumpulkan'}</button>
                        </div>
                    </div>`;
                }).join('')}</div>` : emptyState('Belum ada tugas.', 'file'));
            view.querySelectorAll('.up').forEach(b => b.onclick = () => uploadForm(b.dataset.id, b.dataset.n));
        }
        load();
        function uploadForm(id, nama) {
            UI.modal({ title: `Kumpulkan — ${nama}`, size: 'sm',
                body: `<form id="uf"><label class="label">File Jawaban <span class="text-xs text-slate-500">(pdf/doc, maks 10MB)</span></label><input id="uf-file" type="file" accept=".pdf,.doc,.docx" class="input" required></form>`,
                footer: `<button class="btn btn-ghost" onclick="UI.closeModal()">Batal</button><button class="btn btn-primary" id="uf-save">Kirim</button>`,
                onMount: () => { document.getElementById('uf-save').onclick = async () => {
                    const f = document.getElementById('uf-file').files[0];
                    if (!f) return UI.toast('warning', 'Pilih file jawaban');
                    const fd = new FormData(); fd.append('tugas_id', id); fd.append('file_jawaban', f);
                    const r = await API.postForm('/upload-tugas', fd);
                    if (r.ok && r.data.success) { UI.closeModal(); UI.toast('success', r.data.message || 'Tugas terkumpul'); load(); }
                    else UI.toast('error', 'Gagal', formErr(r.data));
                }; }
            });
        }
    };

    /* ---------- MATERI (mahasiswa) ---------- */
    PG.materiMhs = async (view) => {
        view.innerHTML = pageHeader('Materi Perkuliahan', 'Unduh materi dari dosen') + UI.skeletonCards(3);
        const { data } = await API.get('/materi/mahasiswa/me');
        const list = (data && data.data) || [];
        view.innerHTML = pageHeader('Materi Perkuliahan', 'Unduh materi dari dosen') +
            (list.length ? `<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">${list.map(m=>`
                <div class="card p-5 animate-fade-up">
                    <div class="flex items-start justify-between">
                        <div class="w-11 h-11 rounded-xl bg-gradient-to-br from-amber-500/20 to-orange-500/10 text-amber-300 flex items-center justify-center">${UI.icon('file','w-5 h-5')}</div>
                        <span class="badge badge-blue">${UI.esc((m.mata_kuliah||{}).kode_mk||'')}</span>
                    </div>
                    <h3 class="font-bold text-white mt-3">${UI.esc(m.judul)}</h3>
                    <p class="text-sm text-slate-400 mt-1 line-clamp-2">${UI.esc(m.deskripsi||'-')}</p>
                    <a href="${fileUrl(m.file_materi)}" target="_blank" class="btn btn-ghost btn-sm w-full mt-4">${UI.icon('download','w-4 h-4')} Unduh Materi</a>
                </div>`).join('')}</div>` : emptyState('Belum ada materi.', 'book'));
    };
})();

/* =========================================================
 * DISPATCHER untuk key bersama (matkul / tugas / materi)
 * ========================================================= */
(() => {
    const PAGES = window.PAGES;
    const PG = window.PG || {};
    const role = () => (API.user() || {}).role;

    PAGES.matkul = (view) => {
        const r = role();
        if (r === 'admin') return PG.matkulAdmin(view);
        if (r === 'dosen') return PG.matkulDosen(view);
        return PG.matkulMhs(view);
    };
    PAGES.tugas = (view) => (role() === 'dosen' ? PG.tugasDosen(view) : PG.tugasMhs(view));
    PAGES.materi = (view) => (role() === 'dosen' ? PG.materiDosen(view) : PG.materiMhs(view));

    // dosen-only & mahasiswa-only direct keys
    PAGES.qr = PG.qr;
    PAGES.rekap = PG.rekap;
    PAGES.scan = PG.scan;
    PAGES.riwayat = PG.riwayat;
})();
