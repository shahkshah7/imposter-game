<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Lobby;
use App\Models\Player;

class LobbyController extends Controller
{
    public function createLobby()
    {
        $code = strtoupper(substr(md5(time()), 0, 5));

        $lobby = Lobby::create([
            'code' => $code
        ]);

        return response()->json([
            'lobby' => $lobby
        ]);
    }

    public function joinLobby(Request $request, $code)
    {
        $lobby = Lobby::where('code', $code)->firstOrFail();

        $player = Player::create([
            'lobby_id' => $lobby->id,
            'name' => $request->name,
        ]);

        return response()->json([
            'player' => $player
        ]);
    }

    public function getPlayers($lobbyId)
    {
        $players = Player::where('lobby_id', $lobbyId)->get();

        return response()->json([
            'players' => $players
        ]);
    }
}
