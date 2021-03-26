<?php

namespace App\Transformers;

use App\Transformers\AbstractTransformer as BaseTransformer;

class TermTransformer extends BaseTransformer
{
    protected function getFields(Datum $datum)
    {
        return [
            'id' => 'TM-' . $datum->id,
        ];
    }
}
