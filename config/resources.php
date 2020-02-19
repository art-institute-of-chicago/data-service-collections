<?php

return [

    'api_url' => env('CITI_API_URL', 'http://localhost/v1/'),

    'endpoints' => [
        [
            'endpoint' => 'term-types',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'terms',
            'transformer' => \App\Transformers\TermTransformer::class,
        ],
        [
            'endpoint' => 'object-types',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'agent-types',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'catalogues',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'genders',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'artwork-agent-roles',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'artwork-date-qualifiers',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'artwork-place-qualifiers',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'agent-place-qualifiers',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'categories',
            'transformer' => \App\Transformers\CategoryTransformer::class,
        ],
        [
            'endpoint' => 'deletes',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'artworks',
            'transformer' => \App\Transformers\ArtworkTransformer::class,
        ],
        [
            'endpoint' => 'departments',
            'transformer' => \App\Transformers\GenericTransformer::class,
        ],
        [
            'endpoint' => 'exhibitions',
            'transformer' => \App\Transformers\ExhibitionTransformer::class,
        ],
        [
            'endpoint' => 'galleries',
            'transformer' => \App\Transformers\PlaceTransformer::class,
        ],
        [
            'endpoint' => 'agents',
            'transformer' => \App\Transformers\AgentTransformer::class,
        ],
        [
            'endpoint' => 'places',
            'transformer' => \App\Transformers\PlaceTransformer::class,
        ],
    ],

];
