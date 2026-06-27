/* =========================================================
 * API Client — wrapper REST API + manajemen auth token
 * ========================================================= */
const API = (() => {
    const BASE = (window.APP_CONFIG && window.APP_CONFIG.apiBase) || '/api';
    const TOKEN_KEY = 'jayq_token';
    const USER_KEY = 'jayq_user';

    const token = () => localStorage.getItem(TOKEN_KEY);
    const user = () => {
        try { return JSON.parse(localStorage.getItem(USER_KEY)); }
        catch (e) { return null; }
    };
    const isAuthed = () => !!token();
    const setAuth = (tkn, usr) => {
        localStorage.setItem(TOKEN_KEY, tkn);
        localStorage.setItem(USER_KEY, JSON.stringify(usr));
    };
    const setUser = (usr) => localStorage.setItem(USER_KEY, JSON.stringify(usr));
    const clear = () => {
        localStorage.removeItem(TOKEN_KEY);
        localStorage.removeItem(USER_KEY);
    };

    async function request(method, path, body, isForm = false) {
        const headers = { 'Accept': 'application/json' };
        const t = token();
        if (t) headers['Authorization'] = 'Bearer ' + t;

        let payload = undefined;
        if (isForm) {
            payload = body; // FormData
        } else if (body !== undefined && body !== null) {
            headers['Content-Type'] = 'application/json';
            payload = JSON.stringify(body);
        }

        let res, data;
        try {
            res = await fetch(BASE + path, { method, headers, body: payload });
        } catch (e) {
            return { ok: false, status: 0, data: { message: 'Tidak dapat terhubung ke server.' } };
        }

        try { data = await res.json(); } catch (e) { data = {}; }

        if (res.status === 401 && isAuthed()) {
            clear();
            if (location.hash !== '#/login') {
                location.hash = '#/login';
                if (window.UI) UI.toast('error', 'Sesi berakhir', 'Silakan login kembali.');
            }
        }
        return { ok: res.ok, status: res.status, data };
    }

    return {
        BASE, token, user, setUser, isAuthed, setAuth, clear,
        get:  (p)    => request('GET', p),
        post: (p, b) => request('POST', p, b),
        put:  (p, b) => request('PUT', p, b),
        del:  (p)    => request('DELETE', p),
        postForm: (p, fd) => request('POST', p, fd, true),
    };
})();
