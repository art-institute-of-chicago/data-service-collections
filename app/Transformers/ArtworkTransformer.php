<?php

namespace App\Transformers;

use Carbon\Carbon;
use App\Transformers\Datum;
use App\Transformers\AbstractTransformer as BaseTransformer;

class ArtworkTransformer extends BaseTransformer
{
    protected function getFields(Datum $datum)
    {
        $fields = [
            'gallery_id' => $this->nullZero($datum->gallery_id),
            'creator_id' => $this->nullZero($datum->creator_id),
            'department_id' => $this->nullZero($datum->department_id),

            // TODO: Maybe move these into subobjects?
            'creator_role_id' => $this->nullZero($datum->creator_role_id), // pre-nulled?
            'date_qualifier_id' => $this->nullZero($datum->date_qualifier_id),

            'committees' => null, // TODO: Unsetting this targets copy of $datum
            'fiscal_year' => $datum->fiscal_year ?? $this->getFiscalYear($datum->committees),

            'is_zoomable' => $this->getIsZoomable($datum),
            'max_zoom_window_size' => $this->getMaxZoomWindowSize($datum),

            // Referenced methods must be protected, not private
            'artwork_agents' => $this->mapToArray($datum->artwork_agents, 'getArtworkAgent'),
            'artwork_places' => $this->mapToArray($datum->artwork_places, 'getArtworkPlace'),
            'artwork_dates' => $this->mapToArray($datum->artwork_dates, 'getArtworkDate'),
            'artwork_catalogues' => $this->mapToArray($datum->artwork_catalogues, 'getArtworkCatalogue'),
        ];

        // Exit early if this artwork isn't deaccessioned
        if (is_null($datum->fiscal_year_deaccession)) {
            return $fields;
        }

        return array_merge($fields, [
            'has_rights_web_educational' => null,
            'credit_line' => null,
            'committees' => null,

            'gallery_id' => null,
            'is_on_view' => null,

            'inscriptions' => null,
            'publications' => null,
            'exhibitions' => null,
            'provenance' => null,
            'inscriptions' => null,

            'is_public_domain' => false,
            'is_zoomable' => false,
            'max_zoom_window_size' => 843,

            'copyright_ids' => [],
            'part_ids' => [],
            'set_ids' => [],

            'date_qualifier_id' => null,

            'artwork_places' => [],
            'artwork_dates' => [],
            'artwork_catalogues' => [],
        ]);
    }

    protected function getArtworkAgent(Datum $artworkAgent)
    {
        $artworkAgent->role_id = $this->nullZero($artworkAgent->role_id);

        return $artworkAgent;
    }

    protected function getArtworkPlace(Datum $artworkPlace)
    {
        $artworkPlace->place_qualifier_id = $this->nullZero($artworkPlace->place_qualifier_id);

        return $artworkPlace;
    }

    protected function getArtworkDate(Datum $artworkDate)
    {
        $artworkDate->date_qualifier_id = $this->nullZero($artworkDate->date_qualifier_id);

        return $artworkDate;
    }

    protected function getArtworkCatalogue(Datum $artworkCatalogue)
    {
        $artworkCatalogue->is_preferred = $artworkCatalogue->preferred;
        unset($artworkCatalogue->preferred);

        return $artworkCatalogue;
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

    private function getIsZoomable(Datum $datum)
    {
        return $datum->has_rights_web_educational || $datum->is_public_domain || !empty($datum->copyright);
    }

    private function getMaxZoomWindowSize(Datum $datum)
    {
        if ($datum->copyright) {
            return 1280;
        }

        if ($this->getIsZoomable($datum)) {
            return -1;
        }

        return 843;
    }
}
