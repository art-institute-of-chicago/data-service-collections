<?php

namespace App;

use Aic\Hub\Foundation\AbstractModel as BaseModel;

class Bar extends BaseModel
{

    public function foo()
    {

        return $this->belongsTo('App\Foo');

    }

}
