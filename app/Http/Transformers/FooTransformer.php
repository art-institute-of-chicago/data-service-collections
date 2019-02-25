<?php

namespace App\Http\Transformers;

use Aic\Hub\Foundation\AbstractTransformer;

class FooTransformer extends AbstractTransformer
{

    public function transform($foo)
    {

        $data = [
            'id' => $foo->id,
            'title' => $foo->title,
            'bar_ids' => $foo->bars->pluck('id'),
        ];

        // Enables ?fields= functionality
        return parent::transform($data);

    }

}
