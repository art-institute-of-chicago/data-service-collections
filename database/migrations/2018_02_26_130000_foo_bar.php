<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class FooBar extends Migration
{

    public function up()
    {

        Schema::create('foos', function (Blueprint $table) {
            $table->integer('id')->unsigned()->primary();
            $table->text('title')->nullable();
            $table->timestamps();
        });

        Schema::create('bars', function (Blueprint $table) {
            $table->integer('id')->unsigned()->primary();
            $table->text('title')->nullable();
            $table->integer('foo_id')->unsigned()->index();
            $table->timestamps();
        });

    }

    public function down()
    {
        Schema::dropIfExists('foos');
        Schema::dropIfExists('bars');
    }

}
