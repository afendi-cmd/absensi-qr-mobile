<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Http\Request;

class AuditLogController extends Controller
{
    /**
     * Daftar audit log (Admin). Mendukung filter action & user, serta limit.
     */
    public function index(Request $request)
    {
        $query = AuditLog::with('user:id,nama,role')
            ->orderBy('created_at', 'desc');

        if ($request->filled('action')) {
            $query->where('action', $request->action);
        }
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        $limit = (int) $request->query('limit', 100);
        $limit = max(1, min($limit, 500));

        $logs = $query->limit($limit)->get();

        return response()->json([
            'success' => true,
            'message' => 'Data audit log berhasil diambil',
            'data' => $logs
        ], 200);
    }
}
