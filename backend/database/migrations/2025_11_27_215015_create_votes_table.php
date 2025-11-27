<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('votes', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('round_id');
            $table->unsignedBigInteger('voter_id');      // who voted
            $table->unsignedBigInteger('target_id');     // who they voted for
            $table->timestamps();

            $table->foreign('round_id')->references('id')->on('rounds')->cascadeOnDelete();
            $table->foreign('voter_id')->references('id')->on('players')->cascadeOnDelete();
            $table->foreign('target_id')->references('id')->on('players')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('votes');
    }
};
