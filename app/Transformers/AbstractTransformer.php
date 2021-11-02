<?php

namespace App\Transformers;

use Illuminate\Support\Str;

class AbstractTransformer
{

    /**
     * Clean and transform an array or object.
     *
     * @param \App\Transformers\Datum $datum
     * @return array
     */
    public function transform($datum)
    {
        $datum = $this->getDatum($datum);

        // Use the stored datum as the base - we can prune it later!
        $base = $datum->all();

        // Get all custom-mapped fields
        return array_merge($base, $this->getFields($datum));
    }

    /**
     * Override this method in child classes for additional cleaning.
     *
     * @return array
     */
    protected function getFields(Datum $datum)
    {
        return [];
    }

    /**
     * Helper method to retrieve a datum – a self-cleaning object with convenience methods.
     *
     * @param mixed $datum
     * @return \App\Transformers\Datum
     */
    private function getDatum($datum)
    {
        if($datum instanceof Datum)
        {
            return $datum;
        }

        return new Datum($datum);
    }

    protected function nullIso8601(?string $datetime)
    {
        if (Str::startsWith($datetime, '0000-00-00')) {
            return;
        }

        return $datetime;
    }

    protected function nullZero(?int $value)
    {
        return $value === 0 ? null : $value;
    }

    protected function nullToArray($value)
    {
        return empty($value) ? [] : $value;
    }

    protected function mapToArray($value, string $methodName)
    {
        return array_map([$this, $methodName], $this->nullToArray($value));
    }
}
