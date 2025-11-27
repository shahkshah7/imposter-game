<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('rounds', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('lobby_id');
            $table->unsignedBigInteger('word_pair_id')->nullable();
            $table->unsignedBigInteger('impostor_player_id')->nullable();
            $table->timestamps();

            $table->foreign('lobby_id')->references('id')->on('lobbies')->cascadeOnDelete();
            $table->foreign('word_pair_id')->references('id')->on('word_pairs')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('rounds');
    }
};
