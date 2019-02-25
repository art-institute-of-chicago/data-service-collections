<?php

namespace App\Http\Controllers;

use App\Foo;
use App\Bar;

use Illuminate\Http\Request;

use Aic\Hub\Foundation\AbstractController as BaseController;

class BarController extends BaseController
{

    protected $model = \App\Bar::class;

    protected $transformer = \App\Http\Transformers\BarTransformer::class;

    // foos/{id}/bars
    public function indexForFoo(Request $request, $id) {

        return $this->collect( $request, function( $limit, $id ) {

            return Foo::findOrFail($id)->sections;

        });

    }

    // foos/{foo_id}/bars/{id}
    public function showForFoo(Request $request, $foo_id, $id) {

        return $this->select( $request, function( $id ) use ( $foo_id ) {

            return Section::find( $id )->where('foo_id', $foo_id)->firstOrFail();

        });

    }

}
