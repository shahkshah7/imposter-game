<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class PlayerTypingStop implements ShouldBroadcast
{
    public $lobbyId;
    public $playerName;

    public function __construct($lobbyId, $playerName)
    {
        $this->lobbyId = $lobbyId;
        $this->playerName = $playerName;
    }

    public function broadcastOn()
    {
        return new Channel("lobby.{$this->lobbyId}");
    }
}
