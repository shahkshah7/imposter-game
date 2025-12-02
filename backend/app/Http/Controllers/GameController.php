<?php

namespace App\Http\Controllers;

use App\Models\Lobby;
use App\Models\Round;
use App\Models\WordPair;
use App\Models\Player;
use Illuminate\Http\Request;

class GameController extends Controller
{
    public function startGame($code)
    {
        $lobby = Lobby::where('code', strtoupper($code))->firstOrFail();
        $lobbyId = $lobby->id;

        $players = Player::where('lobby_id', $lobbyId)->get();

        if ($players->count() < 3) {
            return response()->json([
                'error' => 'Not enough players (minimum 3 required)'
            ], 400);
        }

        // pick impostor
        $impostor = $players->random();

        // pick word pair
        $pair = WordPair::inRandomOrder()->first();
        if (!$pair) {
            return response()->json([
                'error' => 'No word pairs available'
            ], 400);
        }

        $round = Round::create([
            'lobby_id' => $lobbyId,
            'word_pair_id' => $pair->id,
            'impostor_player_id' => $impostor->id,
        ]);

        // assign words to players
        foreach ($players as $p) {
            if ($p->id == $impostor->id) {
                $p->update(['word' => $pair->impostor_word]);   // impostor gets impostor word
            } else {
                $p->update(['word' => $pair->civilian_word]);   // civilians get civilian word
            }
        }

        return response()->json([
            'round' => $round
        ]);
    }
}
