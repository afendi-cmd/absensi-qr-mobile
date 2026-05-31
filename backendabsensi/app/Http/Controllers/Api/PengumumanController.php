<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pengumuman;
use App\Models\PengumumanRead;
use App\Models\User;
use App\Services\FcmService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PengumumanController extends Controller
{
    // Get all pengumuman (with filter by target role)
    public function index(Request $request)
    {
        try {
            $user = $request->user();
            $query = Pengumuman::with('creator:id,nama,email')
                ->where('is_active', true)
                ->orderBy('created_at', 'desc');

            // Filter by target role
            if ($user->role !== 'admin') {
                $query->where(function($q) use ($user) {
                    $q->where('target', 'all')
                      ->orWhere('target', $user->role);
                });
            }

            $pengumuman = $query->get();

            return response()->json([
                'success' => true,
                'message' => 'Data pengumuman berhasil diambil',
                'data' => $pengumuman
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Get all pengumuman for admin (including inactive)
    public function adminIndex()
    {
        try {
            $pengumuman = Pengumuman::with('creator:id,nama,email')
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Data pengumuman berhasil diambil',
                'data' => $pengumuman
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Create pengumuman
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'judul' => 'required|string|max:255',
                'isi' => 'required|string',
                'tipe' => 'required|in:info,penting,urgent',
                'target' => 'required|in:all,dosen,mahasiswa',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $pengumuman = Pengumuman::create([
                'judul' => $request->judul,
                'isi' => $request->isi,
                'tipe' => $request->tipe,
                'target' => $request->target,
                'is_active' => true,
                'created_by' => $request->user()->id,
            ]);

            $pengumuman->load('creator:id,nama,email');

            // Send FCM notification to target users
            $this->sendPengumumanNotification($pengumuman);

            return response()->json([
                'success' => true,
                'message' => 'Pengumuman berhasil dibuat',
                'data' => $pengumuman
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Get single pengumuman
    public function show($id)
    {
        try {
            $pengumuman = Pengumuman::with('creator:id,nama,email')->findOrFail($id);

            return response()->json([
                'success' => true,
                'message' => 'Data pengumuman berhasil diambil',
                'data' => $pengumuman
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Pengumuman tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    // Update pengumuman
    public function update(Request $request, $id)
    {
        try {
            $pengumuman = Pengumuman::findOrFail($id);

            $validator = Validator::make($request->all(), [
                'judul' => 'sometimes|required|string|max:255',
                'isi' => 'sometimes|required|string',
                'tipe' => 'sometimes|required|in:info,penting,urgent',
                'target' => 'sometimes|required|in:all,dosen,mahasiswa',
                'is_active' => 'sometimes|boolean',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $pengumuman->update($request->only([
                'judul', 'isi', 'tipe', 'target', 'is_active'
            ]));

            $pengumuman->load('creator:id,nama,email');

            return response()->json([
                'success' => true,
                'message' => 'Pengumuman berhasil diupdate',
                'data' => $pengumuman
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengupdate pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Delete pengumuman
    public function destroy($id)
    {
        try {
            $pengumuman = Pengumuman::findOrFail($id);
            $pengumuman->delete();

            return response()->json([
                'success' => true,
                'message' => 'Pengumuman berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Toggle active status
    public function toggleActive($id)
    {
        try {
            $pengumuman = Pengumuman::findOrFail($id);
            $pengumuman->is_active = !$pengumuman->is_active;
            $pengumuman->save();

            return response()->json([
                'success' => true,
                'message' => 'Status pengumuman berhasil diubah',
                'data' => $pengumuman
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengubah status pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Mark pengumuman as read
    public function markAsRead(Request $request, $id)
    {
        try {
            $pengumuman = Pengumuman::findOrFail($id);
            $userId = $request->user()->id;

            // Check if already marked as read
            $existingRead = PengumumanRead::where('pengumuman_id', $id)
                ->where('user_id', $userId)
                ->first();

            if (!$existingRead) {
                PengumumanRead::create([
                    'pengumuman_id' => $id,
                    'user_id' => $userId,
                ]);
            }

            return response()->json([
                'success' => true,
                'message' => 'Pengumuman ditandai sudah dibaca',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menandai pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Mark all pengumuman as read
    public function markAllAsRead(Request $request)
    {
        try {
            $user = $request->user();
            
            // Get all pengumuman IDs that match user's role and are active
            $query = Pengumuman::where('is_active', true);
            
            if ($user->role !== 'admin') {
                $query->where(function($q) use ($user) {
                    $q->where('target', 'all')
                      ->orWhere('target', $user->role);
                });
            }
            
            $allPengumumanIds = $query->pluck('id');
            
            // Get pengumuman IDs that user has already read
            $readPengumumanIds = PengumumanRead::where('user_id', $user->id)
                ->whereIn('pengumuman_id', $allPengumumanIds)
                ->pluck('pengumuman_id')
                ->toArray();
            
            // Get unread pengumuman IDs
            $unreadPengumumanIds = $allPengumumanIds->diff($readPengumumanIds);
            
            // Mark all unread as read
            $markedCount = 0;
            foreach ($unreadPengumumanIds as $pengumumanId) {
                PengumumanRead::create([
                    'pengumuman_id' => $pengumumanId,
                    'user_id' => $user->id,
                ]);
                $markedCount++;
            }

            return response()->json([
                'success' => true,
                'message' => "$markedCount pengumuman ditandai sudah dibaca",
                'data' => [
                    'marked_count' => $markedCount,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menandai semua pengumuman',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Get unread count
    public function getUnreadCount(Request $request)
    {
        try {
            $user = $request->user();
            
            // Get all pengumuman IDs that match user's role
            $query = Pengumuman::where('is_active', true);
            
            if ($user->role !== 'admin') {
                $query->where(function($q) use ($user) {
                    $q->where('target', 'all')
                      ->orWhere('target', $user->role);
                });
            }
            
            $allPengumumanIds = $query->pluck('id');
            
            // Get pengumuman IDs that user has read
            $readPengumumanIds = PengumumanRead::where('user_id', $user->id)
                ->whereIn('pengumuman_id', $allPengumumanIds)
                ->pluck('pengumuman_id');
            
            // Calculate unread count
            $unreadCount = $allPengumumanIds->count() - $readPengumumanIds->count();

            return response()->json([
                'success' => true,
                'data' => [
                    'unread_count' => $unreadCount,
                    'total_count' => $allPengumumanIds->count(),
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil jumlah pengumuman belum dibaca',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Send FCM notification to target users
     */
    private function sendPengumumanNotification(Pengumuman $pengumuman)
    {
        try {
            $fcmService = new FcmService();
            
            // Determine target users based on pengumuman target
            $query = User::whereNotNull('fcm_token');
            
            if ($pengumuman->target === 'mahasiswa') {
                $query->where('role', 'mahasiswa');
            } elseif ($pengumuman->target === 'dosen') {
                $query->where('role', 'dosen');
            } else {
                // target = 'all', send to both mahasiswa and dosen
                $query->whereIn('role', ['mahasiswa', 'dosen']);
            }
            
            $users = $query->get();
            $fcmTokens = $users->pluck('fcm_token')->filter()->toArray();
            
            if (empty($fcmTokens)) {
                \Log::info('No FCM tokens found for pengumuman notification');
                return;
            }
            
            // Prepare notification data
            $title = '📢 ' . ucfirst($pengumuman->tipe) . ': ' . $pengumuman->judul;
            $body = substr($pengumuman->isi, 0, 100) . (strlen($pengumuman->isi) > 100 ? '...' : '');
            $data = [
                'type' => 'pengumuman',
                'pengumuman_id' => (string) $pengumuman->id,
                'tipe' => $pengumuman->tipe,
                'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
            ];
            
            // Send notifications
            $successCount = $fcmService->sendToMultipleDevices($fcmTokens, $title, $body, $data);
            
            \Log::info("Sent pengumuman notification to $successCount devices");
        } catch (\Exception $e) {
            \Log::error('Failed to send pengumuman notification: ' . $e->getMessage());
        }
    }
}
