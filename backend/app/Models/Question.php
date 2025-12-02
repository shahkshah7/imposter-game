<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Question extends Model
{
    protected $fillable = [
        'round_id',
        'asker_id',
        'target_id',
        'text',
        'answer',
        'answered_at'
    ];

    protected $appends = [
        'round_lobby_id',
        'target_name',
        'asker_name',
    ];

    public function round()
    {
        return $this->belongsTo(Round::class);
    }

    public function asker()
    {
        return $this->belongsTo(Player::class, 'asker_id');
    }

    public function target()
    {
        return $this->belongsTo(Player::class, 'target_id');
    }

    // ---------------------------------------------
    // FEATURE E – Needed by Flutter
    // ---------------------------------------------

    public function getRoundLobbyIdAttribute()
    {
        // round belongs to lobby → round->lobby_id
        return $this->round ? $this->round->lobby_id : null;
    }

    public function getTargetNameAttribute()
    {
        return $this->target ? $this->target->name : null;
    }

    public function getAskerNameAttribute()
    {
        return $this->asker ? $this->asker->name : null;
    }
}
