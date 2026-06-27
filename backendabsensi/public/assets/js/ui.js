/* =========================================================
 * UI Helpers — toast, modal, ikon, formatter
 * ========================================================= */
const UI = (() => {

    /* ---------- escape ---------- */
    const esc = (s) => String(s ?? '')
        .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;').replace(/'/g, '&#39;');

    /* ---------- toast ---------- */
    function toast(type, title, msg = '') {
        const root = document.getElementById('toast-root');
        if (!root) return;
        const colors = {
            success: ['rgba(34,197,94,.14)', '#4ade80', icon('check')],
            error:   ['rgba(239,68,68,.14)', '#f87171', icon('x')],
            info:    ['rgba(59,130,246,.14)', '#60a5fa', icon('info')],
            warning: ['rgba(234,179,8,.14)', '#facc15', icon('warn')],
        };
        const [bg, color, ic] = colors[type] || colors.info;
        const el = document.createElement('div');
        el.className = 'toast glass-strong animate-pop';
        el.style.borderLeft = `3px solid ${color}`;
        el.innerHTML = `
            <span style="color:${color};flex:none;margin-top:1px">${ic}</span>
            <div class="min-w-0">
                <p class="font-semibold text-sm text-white">${esc(title)}</p>
                ${msg ? `<p class="text-xs text-slate-300 mt-.5 break-words">${esc(msg)}</p>` : ''}
            </div>`;
        el.style.background = `linear-gradient(180deg, ${bg}, rgba(17,23,51,.85))`;
        root.appendChild(el);
        setTimeout(() => {
            el.style.transition = '.3s ease';
            el.style.opacity = '0';
            el.style.transform = 'translateX(20px)';
            setTimeout(() => el.remove(), 300);
        }, 3600);
    }

    /* ---------- modal ---------- */
    function modal({ title, body, size = 'md', footer = '', onMount } = {}) {
        const root = document.getElementById('modal-root');
        const widths = { sm: 'max-w-md', md: 'max-w-lg', lg: 'max-w-2xl', xl: 'max-w-4xl' };
        root.innerHTML = `
            <div class="modal-overlay animate-pop" id="modal-overlay">
                <div class="glass-strong w-full ${widths[size] || widths.md} rounded-2xl overflow-hidden shadow-2xl" id="modal-box">
                    <div class="flex items-center justify-between px-6 py-4 border-b border-white/10">
                        <h3 class="text-lg font-bold text-white">${esc(title)}</h3>
                        <button id="modal-close" class="text-slate-400 hover:text-white transition">${icon('x')}</button>
                    </div>
                    <div class="px-6 py-5 max-h-[70vh] overflow-y-auto">${body}</div>
                    ${footer ? `<div class="px-6 py-4 border-t border-white/10 flex justify-end gap-3">${footer}</div>` : ''}
                </div>
            </div>`;
        const overlay = document.getElementById('modal-overlay');
        const close = () => closeModal();
        document.getElementById('modal-close').onclick = close;
        overlay.addEventListener('mousedown', (e) => { if (e.target === overlay) close(); });
        if (onMount) onMount(root);
    }
    function closeModal() {
        const root = document.getElementById('modal-root');
        if (root) root.innerHTML = '';
    }

    function confirm({ title = 'Konfirmasi', message = '', confirmText = 'Ya, lanjutkan', danger = true } = {}) {
        return new Promise((resolve) => {
            modal({
                title, size: 'sm',
                body: `<p class="text-sm text-slate-300 leading-relaxed">${esc(message)}</p>`,
                footer: `
                    <button class="btn btn-ghost" id="cf-no">Batal</button>
                    <button class="btn ${danger ? 'btn-danger' : 'btn-primary'}" id="cf-yes">${esc(confirmText)}</button>`,
                onMount: () => {
                    document.getElementById('cf-no').onclick = () => { closeModal(); resolve(false); };
                    document.getElementById('cf-yes').onclick = () => { closeModal(); resolve(true); };
                }
            });
        });
    }

    /* ---------- icons (lucide-style inline SVG) ---------- */
    function icon(name, cls = 'nav-ico') {
        const P = {
            dashboard: '<path d="M3 13h8V3H3zM13 21h8V3h-8zM3 21h8v-6H3z"/>',
            users: '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>',
            book: '<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>',
            clipboard: '<rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>',
            megaphone: '<path d="m3 11 18-5v12L3 14v-3z"/><path d="M11.6 16.8a3 3 0 1 1-5.8-1.6"/>',
            bell: '<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/>',
            download: '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><path d="M7 10l5 5 5-5M12 15V3"/>',
            user: '<path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>',
            qr: '<rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><path d="M14 14h3v3h-3zM21 14v.01M14 21v.01M21 18v3"/>',
            calendar: '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>',
            file: '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/>',
            scan: '<path d="M3 7V5a2 2 0 0 1 2-2h2M17 3h2a2 2 0 0 1 2 2v2M21 17v2a2 2 0 0 1-2 2h-2M7 21H5a2 2 0 0 1-2-2v-2M7 12h10"/>',
            history: '<path d="M3 12a9 9 0 1 0 9-9 9 9 0 0 0-6.36 2.64L3 8"/><path d="M3 3v5h5M12 7v5l3 3"/>',
            logout: '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/>',
            check: '<path d="M20 6 9 17l-5-5"/>',
            x: '<path d="M18 6 6 18M6 6l12 12"/>',
            plus: '<path d="M12 5v14M5 12h14"/>',
            edit: '<path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4z"/>',
            trash: '<path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>',
            key: '<circle cx="7.5" cy="15.5" r="5.5"/><path d="m21 2-9.6 9.6M15.5 7.5l3 3L22 7l-3-3"/>',
            info: '<circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/>',
            warn: '<path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/>',
            search: '<circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>',
            send: '<path d="m22 2-7 20-4-9-9-4z"/><path d="M22 2 11 13"/>',
            eye: '<path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/>',
            star: '<path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01z"/>',
            graduation: '<path d="M22 10 12 5 2 10l10 5 10-5z"/><path d="M6 12v5c0 1 2 3 6 3s6-2 6-3v-5"/>',
            clock: '<circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>',
            chart: '<path d="M3 3v18h18"/><path d="M18 17V9M13 17V5M8 17v-3"/>',
            upload: '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><path d="M17 8l-5-5-5 5M12 3v12"/>',
            menu: '<path d="M3 12h18M3 6h18M3 18h18"/>',
        };
        return `<svg class="${cls}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${P[name] || P.info}</svg>`;
    }

    /* ---------- formatters ---------- */
    const monthsId = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    function fmtDate(str) {
        if (!str) return '-';
        const d = new Date(str.replace(' ', 'T'));
        if (isNaN(d)) return str;
        return `${d.getDate()} ${monthsId[d.getMonth()]} ${d.getFullYear()}`;
    }
    function fmtDateTime(str) {
        if (!str) return '-';
        const d = new Date(str.replace(' ', 'T'));
        if (isNaN(d)) return str;
        const hh = String(d.getHours()).padStart(2, '0');
        const mm = String(d.getMinutes()).padStart(2, '0');
        return `${d.getDate()} ${monthsId[d.getMonth()]} ${d.getFullYear()}, ${hh}:${mm}`;
    }
    function initials(name) {
        if (!name) return '?';
        return name.trim().split(/\s+/).slice(0, 2).map(w => w[0]).join('').toUpperCase();
    }
    function timeLeft(str) {
        if (!str) return '';
        const diff = new Date(str.replace(' ', 'T')) - new Date();
        if (diff <= 0) return 'Berakhir';
        const m = Math.floor(diff / 60000);
        if (m < 60) return `${m} mnt lagi`;
        const h = Math.floor(m / 60);
        return `${h}j ${m % 60}m lagi`;
    }

    /* ---------- skeleton ---------- */
    function skeletonCards(n = 4) {
        return `<div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5">${
            Array.from({ length: n }).map(() => `<div class="card p-5"><div class="skeleton h-4 w-24 mb-4"></div><div class="skeleton h-8 w-16"></div></div>`).join('')
        }</div>`;
    }
    function skeletonTable() {
        return `<div class="card p-5 space-y-3">${Array.from({length:6}).map(()=>`<div class="skeleton h-10 w-full"></div>`).join('')}</div>`;
    }

    return { esc, toast, modal, closeModal, confirm, icon, fmtDate, fmtDateTime, initials, timeLeft, skeletonCards, skeletonTable };
})();
