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
            'gender_id' => $this->nullZero($datum->gender_id),
            'agent_places' => $this->mapToArray($datum->agent_places, 'getAgentPlace'),
        ];
    }

    protected function getAgentPlace(Datum $agentPlace)
    {
        $agentPlace->place_qualifier_id = $this->nullZero($agentPlace->place_qualifier_id);

        // Null out funky dates, pending upstream fixes
        $nullPairs = [
            // ex: 116611 (1/1/4713 BCE)
            [
                'date_earliest' => '0000-00-00T00:00:00.000Z',
                'date_latest' => '4713-01-01T06:00:00.000Z',
            ],
            // ex: 106799 (blank)
            [
                'date_earliest' => '0000-00-00T00:00:00.000Z',
                'date_latest' => '19265-01-01T06:00:00.000Z',
            ],
        ];

        foreach ($nullPairs as $nullPair) {
            if ((
                $agentPlace->date_earliest == $nullPair['date_earliest']
            ) && (
                $agentPlace->date_latest == $nullPair['date_latest']
            )) {
                $agentPlace->date_earliest = null;
                $agentPlace->date_latest = null;

                return $agentPlace;
            }
        }

        $agentPlace->date_earliest = $this->nullIso8601($agentPlace->date_earliest);
        $agentPlace->date_latest = $this->nullIso8601($agentPlace->date_latest);

        return $agentPlace;
    }
}
