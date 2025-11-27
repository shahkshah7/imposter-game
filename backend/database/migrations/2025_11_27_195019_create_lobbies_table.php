<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('lobbies', function (Blueprint $table) {
            $table->id();
            $table->string('code', 10)->unique();
            $table->unsignedBigInteger('host_id')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('lobbies');
    }
};
