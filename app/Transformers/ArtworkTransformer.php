<?php

namespace App\Transformers;

use Carbon\Carbon;
use App\Transformers\Datum;
use App\Transformers\AbstractTransformer as BaseTransformer;

class ArtworkTransformer extends BaseTransformer
{
    protected function getFields(Datum $datum)
    {
        return [
            'gallery_id' => $this->nullZero($datum->gallery_id),
            'creator_id' => $this->nullZero($datum->creator_id),

            'committees' => null,
            'fiscal_year' => $datum->fiscal_year ?? $this->getFiscalYear($datum->committees),

            'artwork_agents' => array_map([$this, 'getArtworkAgent'], $this->nullArray($datum->artwork_agents)),
            'artwork_places' => array_map([$this, 'getArtworkPlace'], $this->nullArray($datum->artwork_places)),
            'artwork_dates' => array_map([$this, 'getArtworkDate'], $this->nullArray($datum->artwork_dates)),
        ];
    }

    private function getArtworkAgent(Datum $artworkAgent)
    {
        $artworkAgent->role_id = $this->nullZero($artworkAgent->role_id);

        return $artworkAgent;
    }

    private function getArtworkPlace(Datum $artworkPlace)
    {
        $artworkPlace->place_qualifier_id = $this->nullZero($artworkPlace->place_qualifier_id);

        return $artworkPlace;
    }

    private function getArtworkDate(Datum $artworkDate)
    {
        $artworkDate->date_qualifier_id = $this->nullZero($artworkDate->date_qualifier_id);

        return $artworkDate;
    }

    private function getFiscalYear(array $committees)
    {
        $fiscalYear = null;

        foreach ($committees as $committee)
        {
            if ($committee->action !== 'Acquisition')
            {
                continue;
            }

            if (!in_array($committee->title, [
                'Board of Trustees',
                'Year End Gifts',
                'Executive Committee',
                'Executive Committee (Poll)',
                'Director\'s Discretion',
            ])) {
                continue;
            }

            $date = Carbon::parse($committee->date);

            $committeeFiscalYear = $date->year;

            if ($date->month >= 7)
            {
                $committeeFiscalYear += 1;
            }

            if (!isset($fiscalYear) || $committeeFiscalYear > $fiscalYear)
            {
                $fiscalYear = $committeeFiscalYear;
            }
        }

        return $fiscalYear;
    }
}
