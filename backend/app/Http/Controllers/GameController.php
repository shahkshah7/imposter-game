<?php

namespace App\Http\Controllers;

use App\Models\Lobby;
use App\Models\Round;
use App\Models\WordPair;
use App\Models\Player;
use Illuminate\Http\Request;

class GameController extends Controller
{
    public function startGame($lobbyId)
    {
        $lobby = Lobby::findOrFail($lobbyId);

        $players = Player::where('lobby_id', $lobbyId)->get();

        if ($players->count() < 3) {
            return response()->json([
                'error' => 'Not enough players'
            ], 400);
        }

        // pick impostor
        $impostor = $players->random();

        // pick word pair
        $pair = WordPair::inRandomOrder()->first();

        $round = Round::create([
            'lobby_id' => $lobbyId,
            'word_pair_id' => $pair->id,
            'impostor_player_id' => $impostor->id,
        ]);

        // assign words to players
        foreach ($players as $p) {
            if ($p->id == $impostor->id) {
                $p->update(['word' => $pair->fake_word]);   // impostor gets fake
            } else {
                $p->update(['word' => $pair->real_word]);   // civilians get real
            }
        }

        return response()->json([
            'round' => $round
        ]);
    }
}
