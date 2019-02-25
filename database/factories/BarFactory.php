<?php

$factory->define(App\Bar::class, function (Faker\Generator $faker) {
    return [
        'id' => $faker->unique()->randomNumber(6),
        'title' => ucfirst( $faker->words(3, true) ),
        'foo_id' => App\Foo::all()->get()->random(),
    ];
});
