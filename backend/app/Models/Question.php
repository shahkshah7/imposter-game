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
}
