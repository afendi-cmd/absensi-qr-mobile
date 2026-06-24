<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#0b1020">
    <title>JAYQ Absensi — Sistem Manajemen Kehadiran</title>

    <!-- Tailwind (Play CDN) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Plus Jakarta Sans', 'system-ui', 'sans-serif'] },
                    colors: {
                        brand: {
                            50:'#eef2ff',100:'#e0e7ff',200:'#c7d2fe',300:'#a5b4fc',
                            400:'#818cf8',500:'#6366f1',600:'#4f46e5',700:'#4338ca',
                            800:'#3730a3',900:'#312e81'
                        }
                    },
                    keyframes: {
                        'fade-up': { '0%': { opacity:0, transform:'translateY(10px)' }, '100%': { opacity:1, transform:'translateY(0)' } },
                        'pop': { '0%': { opacity:0, transform:'scale(.96)' }, '100%': { opacity:1, transform:'scale(1)' } },
                    },
                    animation: {
                        'fade-up': 'fade-up .4s ease both',
                        'pop': 'pop .25s ease both',
                    }
                }
            }
        }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

    <!-- App styles -->
    <link rel="stylesheet" href="{{ asset('assets/css/app.css') }}">
</head>
<body class="font-sans antialiased text-slate-100">

    <!-- Splash -->
    <div id="splash" class="fixed inset-0 z-[100] flex items-center justify-center bg-[#0b1020]">
        <div class="flex flex-col items-center gap-4">
            <div class="logo-mark animate-pulse">JAYQ</div>
            <div class="h-1 w-40 overflow-hidden rounded-full bg-white/10">
                <div class="splash-bar"></div>
            </div>
        </div>
    </div>

    <!-- App root -->
    <div id="app"></div>

    <!-- Toast container -->
    <div id="toast-root" class="fixed top-5 right-5 z-[90] flex flex-col gap-3"></div>

    <!-- Modal root -->
    <div id="modal-root"></div>

    <script>
        window.APP_CONFIG = {
            apiBase: '{{ rtrim(url('/'), '/') }}/api',
            storageBase: '{{ rtrim(url('/'), '/') }}/storage',
            appName: 'JAYQ Absensi'
        };
    </script>
    <script src="{{ asset('assets/js/api.js') }}"></script>
    <script src="{{ asset('assets/js/ui.js') }}"></script>
    <script src="{{ asset('assets/js/app.js') }}"></script>
    <script src="{{ asset('assets/js/pages.js') }}"></script>
</body>
</html>
