<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Lobby;
use App\Models\Player;

class LobbyController extends Controller
{
    public function createLobby(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $code = strtoupper(substr(md5(uniqid('', true)), 0, 5));

        // Create lobby first (host_id will be assigned after player is created)
        $lobby = Lobby::create([
            'code' => $code,
        ]);

        // Create host player with lobby_id
        $player = Player::create([
            'lobby_id' => $lobby->id,
            'name'     => $request->input('name'),
        ]);

        // Update lobby with host id
        $lobby->update([
            'host_id' => $player->id,
        ]);

        return response()->json([
            'player' => $player,
            'lobby'  => $lobby,
        ], 200);
    }

    public function joinLobby(Request $request, $code)
    {
        $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $lobby = Lobby::where('code', strtoupper($code))->firstOrFail();

        $player = Player::create([
            'lobby_id' => $lobby->id,
            'name'     => $request->input('name'),
        ]);

        return response()->json([
            'player' => $player,
            'lobby'  => $lobby,
        ], 200);
    }

    public function getPlayers($lobbyId)
    {
        $players = Player::where('lobby_id', $lobbyId)->get();

        return response()->json([
            'players' => $players,
        ], 200);
    }
}
