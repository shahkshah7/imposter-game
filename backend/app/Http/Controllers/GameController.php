<?php

namespace App\Http\Controllers;

use App\Models\Lobby;
use App\Models\Round;
use App\Models\WordPair;
use App\Models\Player;
use Illuminate\Http\Request;

class GameController extends Controller
{
    public function startGame(Request $request, $lobbyId)
    {
        $lobby = Lobby::with('players')->findOrFail($lobbyId);

        $players = $lobby->players;

        if ($players->count() < 3) {
            return response()->json(['error' => 'Need at least 3 players'], 422);
        }

        // Pick random impostor
        $impostor = $players->random();

        // Pick random word pair
        $wordPair = WordPair::inRandomOrder()->first();

        // Create round
        $round = Round::create([
            'lobby_id'           => $lobby->id,
            'word_pair_id'       => $wordPair->id,
            'impostor_player_id' => $impostor->id,
        ]);

        // Assign words
        foreach ($players as $player) {
            if ($player->id === $impostor->id) {
                $player->update(['role' => 'impostor', 'word' => $wordPair->impostor_word]);
            } else {
                $player->update(['role' => 'civilian', 'word' => $wordPair->civilian_word]);
            }
        }

        return response()->json([
            'round' => $round,
            'impostor_id' => $impostor->id
        ]);
    }

    public function getState(Request $request, $playerId)
    {
        $player = Player::with('lobby')->findOrFail($playerId);

        $round = $player->lobby->currentRound();

        return response()->json([
            'player' => $player,
            'round'  => $round,
            'word'   => $player->word,
            'role'   => $player->role
        ]);
    }
}
