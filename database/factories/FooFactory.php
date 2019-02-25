<?php

$factory->define(App\Foo::class, function (Faker\Generator $faker) {
    return [
        'id' => $faker->unique()->randomNumber(6),
        'title' => ucfirst( $faker->words(3, true) ),
    ];
});
