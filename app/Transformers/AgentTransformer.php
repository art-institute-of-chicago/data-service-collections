<?php

namespace App\Transformers;

use App\Transformers\Datum;
use App\Transformers\AbstractTransformer as BaseTransformer;

class AgentTransformer extends BaseTransformer
{
    protected function getFields(Datum $datum)
    {
        return [
            'agent_type_id' => $this->nullZero($datum->agent_type_id),
        ];
    }
}
