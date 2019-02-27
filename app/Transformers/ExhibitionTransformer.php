<?php

namespace App\Transformers;

use App\Transformers\Datum;
use App\Transformers\AbstractTransformer as BaseTransformer;

class ExhibitionTransformer extends BaseTransformer
{
    protected function getFields(Datum $datum)
    {
        return [
            'start_date' => $this->nullIso8601($datum->start_date),
            'end_date' => $this->nullIso8601($datum->end_date),
            'aic_start_date' => $this->nullIso8601($datum->aic_start_date),
            'aic_end_date' => $this->nullIso8601($datum->aic_end_date),
            'exhibition_agents' => array_map([$this, 'getExhibitionAgent'], $datum->exhibition_agents),
        ];
    }

    private function getExhibitionAgent($exhibitionAgent)
    {
        $exhibitionAgent->start_date = $this->nullIso8601($exhibitionAgent->start_date);
        $exhibitionAgent->end_date = $this->nullIso8601($exhibitionAgent->end_date);

        return $exhibitionAgent;
    }

    private function nullIso8601(string $datetime)
    {
        return $datetime === '0000-00-00T00:00:00.000Z' ? null : $datetime;
    }
}
