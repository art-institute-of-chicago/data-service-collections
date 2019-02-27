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

        return [
            'data' => $transformer->transform($response->data),
        ];
    }

    public function index()
    {
        $endpoint = $this->getEndpoint(-1);
        $transformer = $this->getTransformer($endpoint);

        $response = $this->getResponse($endpoint, $this->request->only(['limit', 'page']));

        return [
            'pagination' => $this->getPagination($response->pagination),
            'data' => array_map([$transformer, 'transform'], $response->data),
        ];
    }

    private function getEndpoint(int $offset)
    {
        return array_slice($this->request->segments(), $offset, 1)[0];
    }

    private function getResponse(string $path, array $query = [])
    {
        return json_decode($this->client->request('GET', $path, ['query' => $query])->getBody());
    }

    private function getTransformer(string $endpoint)
    {
        $mapping = collect(config('resources.endpoints'))->firstWhere('endpoint', $endpoint);

        if (!$mapping) {
            throw new ItemNotFoundException();
        }

        return new $mapping['transformer'];
    }

    private function getPagination($pagination)
    {
        if (isset($pagination->prev_url)) {
            $pagination->prev_url = $this->request->fullUrlWithQuery([
                'page' => $pagination->current_page - 1,
                'limit' => $pagination->limit,
            ]);
        }

        if (isset($pagination->next_url)) {
            $pagination->next_url = $this->request->fullUrlWithQuery([
                'page' => $pagination->current_page + 1,
                'limit' => $pagination->limit,
            ]);
        }

        return $pagination;
    }

}
