<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WordPair extends Model
{
    protected $fillable = ['civilian_word', 'impostor_word'];
}
