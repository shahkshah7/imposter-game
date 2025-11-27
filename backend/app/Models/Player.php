<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Player extends Model
{
    protected $fillable = [
        'lobby_id',
        'name',
        'role',
        'word'
    ];

    public function lobby()
    {
        return $this->belongsTo(Lobby::class);
    }

    public function questionsAsked()
    {
        return $this->hasMany(Question::class, 'asker_id');
    }

    public function questionsReceived()
    {
        return $this->hasMany(Question::class, 'target_id');
    }
}
