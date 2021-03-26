<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use GuzzleHttp\ClientInterface as Guzzle;
use Aic\Hub\Foundation\Exceptions\ItemNotFoundException;

use Illuminate\Routing\Controller as BaseController;

class PassthroughController extends BaseController
{

    private $request;

    private $client;

    public function __construct(Request $request, Guzzle $client)
    {
        $this->request = $request;
        $this->client = $client;
    }

    public function show($id)
    {
        $endpoint = $this->getEndpoint(-2);
        $transformer = $this->getTransformer($endpoint);

        $response = $this->getResponse($endpoint . '/' . $id);

        if (!isset($response)) {
            throw new ItemNotFoundException();
        }

        return [
            'data' => $transformer->transform($this->getData($response)[0]),
        ];
    }

    public function index()
    {
        $endpoint = $this->getEndpoint(-1);
        $transformer = $this->getTransformer($endpoint);

        $response = $this->getResponse($endpoint, $this->request->only([
            'limit',
            'page',
            'ids',
        ]));

        return [
            'pagination' => $this->getPagination($response),
            'data' => array_map([$transformer, 'transform'], $this->getData($response)),
        ];
    }

    private function getEndpoint(int $offset)
    {
        return array_slice($this->request->segments(), $offset, 1)[0];
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

    private function getPagination($response = null)
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
            $pagination->prev_url = $this->request->fullUrlWithQuery([
                'page' => $pagination->current_page - 1,
                'limit' => $pagination->limit,
                'ids' => $this->request->get('ids'),
            ]);
        }

        if (isset($pagination->next_url)) {
            $pagination->next_url = $this->request->fullUrlWithQuery([
                'page' => $pagination->current_page + 1,
                'limit' => $pagination->limit,
                'ids' => $this->request->get('ids'),
            ]);
        }

        return $pagination;
    }

}
