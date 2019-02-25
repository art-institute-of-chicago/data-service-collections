<?php

namespace App\Http\Transformers;

use Aic\Hub\Foundation\AbstractTransformer;

class BarTransformer extends AbstractTransformer
{

    public function transform($bar)
    {

        $data = [
            'id' => $bar->id,
            'title' => $bar->title,
            'foo_id' => $bar->foo->id ?? null,
        ];

        // Enables ?fields= functionality
        return parent::transform($data);

    }

}
