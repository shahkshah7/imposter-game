<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('word_pairs', function (Blueprint $table) {
            $table->id();
            $table->string('civilian_word');
            $table->string('impostor_word');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('word_pairs');
    }
};
