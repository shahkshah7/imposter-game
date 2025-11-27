<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('questions', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('round_id');
            $table->unsignedBigInteger('asker_id');
            $table->unsignedBigInteger('target_id');
            $table->text('text');
            $table->string('answer')->nullable();        // Only target answers
            $table->timestamp('answered_at')->nullable();
            $table->timestamps();

            $table->foreign('round_id')->references('id')->on('rounds')->cascadeOnDelete();
            $table->foreign('asker_id')->references('id')->on('players')->cascadeOnDelete();
            $table->foreign('target_id')->references('id')->on('players')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('questions');
    }
};
