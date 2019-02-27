<?php

namespace App\Transformers;

use App\Transformers\Datum;
use App\Transformers\AbstractTransformer as BaseTransformer;

class CategoryTransformer extends BaseTransformer
{
    protected function getFields(Datum $datum)
    {
        return [
            'parent_id' => $datum->parent_id === 0 ? null : $datum->parent_id,
        ];
    }
}
