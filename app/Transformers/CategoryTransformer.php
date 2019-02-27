<?php

namespace App\Transformers;

use App\Transformers\Datum;
use App\Transformers\AbstractTransformer as BaseTransformer;

class CategoryTransformer extends BaseTransformer
{
    protected function getFields(Datum $datum)
    {
        return [
            'parent_id' => $this->nullZero($datum->parent_id),
        ];
    }
}
