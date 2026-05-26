<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;

class NotificationController extends Controller
{
    /**
     * Send notification to users based on target
     * 
     * Note: This is a simplified version that logs the notification.
     * For actual push notifications, you need to integrate Firebase Admin SDK.
     */
    public function sendToUsers(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string',
            'body' => 'required|string',
            'target' => 'required|in:all,dosen,mahasiswa',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Get users based on target
        $query = User::whereNotNull('fcm_token');
        
        if ($request->target !== 'all') {
            $query->where('role', $request->target);
        }

        $users = $query->get();
        $tokens = $users->pluck('fcm_token')->filter()->toArray();

        if (empty($tokens)) {
            return response()->json([
                'success' => false,
                'message' => 'No users found with FCM tokens',
            ], 404);
        }

        // Log notification (for now)
        Log::info('Notification to be sent', [
            'title' => $request->title,
            'body' => $request->body,
            'target' => $request->target,
            'recipients' => count($tokens),
            'tokens' => $tokens,
        ]);

        // TODO: Integrate Firebase Admin SDK here
        // For now, we'll just return success
        // In production, you would use Firebase Admin SDK to send actual push notifications

        return response()->json([
            'success' => true,
            'message' => 'Notification logged successfully (Firebase integration pending)',
            'data' => [
                'target' => $request->target,
                'recipients' => count($tokens),
                'title' => $request->title,
                'body' => $request->body,
            ]
        ], 200);
    }

    /**
     * Get notification history (placeholder)
     */
    public function history(Request $request)
    {
        // TODO: Implement notification history
        return response()->json([
            'success' => true,
            'message' => 'Notification history',
            'data' => []
        ], 200);
    }
}
