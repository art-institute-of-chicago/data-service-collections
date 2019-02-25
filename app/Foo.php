<?php

namespace App;

use Aic\Hub\Foundation\AbstractModel as BaseModel;

class Foo extends BaseModel
{

    public function bars()
    {

        return $this->hasMany('App\Bar');

    }

}
