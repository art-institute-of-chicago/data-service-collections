<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use GuzzleHttp\ClientInterface as Guzzle;
use Aic\Hub\Foundation\Exceptions\ItemNotFoundException;

use Illuminate\Routing\Controller as BaseController;

class PassthroughController extends BaseController
{

    private $client;

    public function __construct(Guzzle $client)
    {
        $this->client = $client;
    }

    public function show(Request $request, $id)
    {
        $endpoint = $this->getEndpoint($request, -2);
        $transformer = $this->getTransformer($endpoint);

        $response = $this->getResponse($endpoint . '/' . $id);

        if (!isset($response)) {
            throw new ItemNotFoundException();
        }

        return [
            'data' => $transformer->transform($this->getData($response)[0]),
        ];
    }

    public function index(Request $request)
    {
        $endpoint = $this->getEndpoint($request, -1);
        $transformer = $this->getTransformer($endpoint);

        $response = $this->getResponse($endpoint, $request->only([
            'limit',
            'page',
            'ids',
        ]));

        return [
            'pagination' => $this->getPagination($request, $response),
            'data' => array_map([$transformer, 'transform'], $this->getData($response)),
        ];
    }

    private function getEndpoint(Request $request, int $offset)
    {
        return array_slice($request->segments(), $offset, 1)[0];
    }

    private function getResponse(string $path, array $query = [])
    {
        try {
            $response = $this->client->request('GET', $path, ['query' => $query]);
        }
        catch (\GuzzleHttp\Exception\ClientException $e) {
            return null;
        }

        return json_decode($response->getBody());
    }

    private function getTransformer(string $endpoint)
    {
        $mapping = collect(config('resources.endpoints'))->firstWhere('endpoint', $endpoint);

        if (!$mapping) {
            throw new ItemNotFoundException();
        }

        return new $mapping['transformer']();
    }

    private function getData($response = null)
    {
        $data = $response->data ?? [];
        $data = !is_array($data) ? [$data] : $data;
        $data = array_map(function ($datum) {
            return is_object($datum) ? (array) $datum : $datum;
        }, $data);

        return $data;
    }

    private function getPagination(Request $request, $response = null)
    {
        $pagination = $response->pagination ?? (object) [
            'total' => 0,
            'limit' => 12,
            'offset' => 0,
            'current_page' => 1,
            'total_pages' => 1,
            'prev_url' => null,
            'next_url' => null,
        ];

        if (isset($pagination->prev_url)) {
            $pagination->prev_url = $request->fullUrlWithQuery([
                'page' => $pagination->current_page - 1,
                'limit' => $pagination->limit,
                'ids' => $request->get('ids'),
            ]);
        }

        if (isset($pagination->next_url)) {
            $pagination->next_url = $request->fullUrlWithQuery([
                'page' => $pagination->current_page + 1,
                'limit' => $pagination->limit,
                'ids' => $request->get('ids'),
            ]);
        }

        return $pagination;
    }

}
