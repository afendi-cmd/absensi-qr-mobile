<?php

namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Illuminate\Support\Facades\Log;

class FcmService
{
    protected $messaging;

    public function __construct()
    {
        try {
            $credentialsPath = base_path('firebase-credentials.json');
            
            if (!file_exists($credentialsPath)) {
                Log::error('Firebase credentials file not found at: ' . $credentialsPath);
                $this->messaging = null;
                return;
            }

            $factory = (new Factory)->withServiceAccount($credentialsPath);
            $this->messaging = $factory->createMessaging();
        } catch (\Exception $e) {
            Log::error('FCM Service initialization failed: ' . $e->getMessage());
            $this->messaging = null;
        }
    }

    /**
     * Send notification to a single device
     */
    public function sendToDevice(string $fcmToken, string $title, string $body, array $data = [])
    {
        if (!$this->messaging) {
            Log::warning('FCM Service not initialized');
            return false;
        }

        try {
            $message = CloudMessage::fromArray([
                'token' => $fcmToken,
                'notification' => [
                    'title' => $title,
                    'body' => $body,
                ],
                'data' => $data,
            ]);

            $this->messaging->send($message);
            return true;
        } catch (\Exception $e) {
            Log::error('FCM send to device failed: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Send notification to multiple devices
     */
    public function sendToMultipleDevices(array $fcmTokens, string $title, string $body, array $data = [])
    {
        if (!$this->messaging || empty($fcmTokens)) {
            return 0;
        }

        $successCount = 0;

        foreach ($fcmTokens as $token) {
            if ($this->sendToDevice($token, $title, $body, $data)) {
                $successCount++;
            }
        }

        return $successCount;
    }

    /**
     * Send notification to topic
     */
    public function sendToTopic(string $topic, string $title, string $body, array $data = [])
    {
        if (!$this->messaging) {
            Log::warning('FCM Service not initialized');
            return false;
        }

        try {
            $message = CloudMessage::fromArray([
                'topic' => $topic,
                'notification' => [
                    'title' => $title,
                    'body' => $body,
                ],
                'data' => $data,
            ]);

            $this->messaging->send($message);
            return true;
        } catch (\Exception $e) {
            Log::error('FCM send to topic failed: ' . $e->getMessage());
            return false;
        }
    }
}
