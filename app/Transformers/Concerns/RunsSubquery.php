<?php

namespace App\Transformers\Concerns;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Request;

trait RunsSubquery
{
    protected function getItemById($id, string $endpoint)
    {
        $items = $this->getAllItems($endpoint);

        if (!isset($items[$id]) && $id != 0) {
            Cache::forget($endpoint);

            $items = $this->getAllItems($endpoint);
        }

        return $items[$id] ?? null;
    }

    private function getAllItems(string $endpoint)
    {
        return Cache::remember($endpoint, 60 * 60, function () use ($endpoint) {
            $data = [];
            $limit = 1000;

            // Failsafe to not paginate deeper than 5,000 items
            for ($page = 1; $page * $limit <= 5000; $page++) {
                $request = Request::create('/api/v1/' . $endpoint, 'GET', [
                    'page' => $page,
                    'limit' => $limit,
                ]);

                $response = app()->handle($request)->getData();

                foreach ($response->data as $datum) {
                    $data[$datum->id] = $datum;
                }

                if (!$response->pagination->next_url) {
                    break;
                }
            }

            ksort($data);

            return $data;
        });
    }
}
