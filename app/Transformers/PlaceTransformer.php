<?php

namespace App\Transformers;

use App\Transformers\Datum;
use App\Transformers\AbstractTransformer as BaseTransformer;

class PlaceTransformer extends BaseTransformer
{
    protected function getFields(Datum $datum)
    {
        $isNullIsland = $datum->latitude === 0 && $datum->longitude === 0;

        return !$isNullIsland ? [] : [
            'latitude' => null,
            'longitude' => null,
        ];
    }
}
