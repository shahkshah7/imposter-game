<?php

namespace App\Http\Controllers;

use App\Models\Lobby;
use App\Models\Player;
use Illuminate\Http\Request;

class LobbyController extends Controller
{
    public function createLobby(Request $request)
    {
        $code = strtoupper(substr(md5(uniqid()), 0, 5));

        $lobby = Lobby::create([
            'code' => $code
        ]);

        return response()->json([
            'lobby' => $lobby
        ]);
    }

        public function getPlayers($lobbyId)
    {
        $players = \App\Models\Player::where('lobby_id', $lobbyId)->get();

        return response()->json([
            'players' => $players
        ]);
    }


    public function joinLobby(Request $request, $code)
    {
        $request->validate([
            'name' => 'required|string|max:50'
        ]);

        $lobby = Lobby::where('code', $code)->firstOrFail();

        $player = Player::create([
            'lobby_id' => $lobby->id,
            'name'     => $request->name,
            'role'     => 'civilian',
        ]);

        return response()->json([
            'player' => $player,
            'lobby'  => $lobby
        ]);
    }
}
