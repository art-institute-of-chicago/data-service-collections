<?php

namespace App\Console\Commands;

class HelloWorld extends AbstractCommand
{

    protected $signature = 'hello:world';

    protected $description = "Say hi";

    public function handle()
    {
        $this->info("Hello world");
    }

}
