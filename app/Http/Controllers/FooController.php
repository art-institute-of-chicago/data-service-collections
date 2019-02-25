<?php

namespace App\Http\Controllers;

use Aic\Hub\Foundation\AbstractController as BaseController;

class FooController extends BaseController
{

    protected $model = \App\Foo::class;

    protected $transformer = \App\Http\Transformers\FooTransformer::class;

}
