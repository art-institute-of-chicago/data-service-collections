<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class GuzzleServiceProvider extends ServiceProvider
{

    public function register()
    {
        $this->app->singleton(\GuzzleHttp\ClientInterface::class, function () {
            return new \GuzzleHttp\Client([
                'base_uri' => config('resources.api_url'),
                'headers' => [
                    'Accept' => 'application/json',
                ],
                'verify' => false,
            ]);
        });
    }

}
