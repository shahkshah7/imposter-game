<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Round extends Model
{
    protected $fillable = [
        'lobby_id',
        'word_pair_id',
        'impostor_player_id',
    ];

    public function lobby()
    {
        return $this->belongsTo(Lobby::class);
    }

    public function wordPair()
    {
        return $this->belongsTo(WordPair::class);
    }

    public function impostor()
    {
        return $this->belongsTo(Player::class, 'impostor_player_id');
    }

    public function questions()
    {
        return $this->hasMany(Question::class);
    }
}
