<?php

Route::get('/', function () {
    return redirect('/api/v1');
});

Route::group(['prefix' => 'v1'], function () {

    // Define all of our resource routes by looping through config
    foreach(config('resources.endpoints') as $resource)
    {
        Route::any($resource['endpoint'], 'PassthroughController@index');
        Route::any($resource['endpoint'] . '/{id}', 'PassthroughController@show');
    }

});
