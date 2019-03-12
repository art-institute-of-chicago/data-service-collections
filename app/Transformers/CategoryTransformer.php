<?php

namespace App\Transformers;

use App\Transformers\Datum;
use App\Transformers\AbstractTransformer as BaseTransformer;

class CategoryTransformer extends BaseTransformer
{
    protected function getFields(Datum $datum)
    {
        return [
            'id' => 'PC-' . $datum->id,
            'parent_id' => $this->getParentId($datum->parent_id),
        ];
    }

    private function getParentId($parentId)
    {
        $parentId = $this->nullZero($parentId);
        $parentId = $parentId ? 'PC-' . $parentId : null;
        return $parentId;
    }
}
