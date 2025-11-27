<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('players', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('lobby_id');
            $table->string('name');
            $table->string('role')->default('civilian'); // or impostor
            $table->string('word')->nullable();          // assigned word for the round
            $table->timestamps();

            $table->foreign('lobby_id')->references('id')->on('lobbies')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('players');
    }
};
