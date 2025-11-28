<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class VotePhaseStarted implements ShouldBroadcast
{
    public $lobbyId;

    public function __construct($lobbyId)
    {
        $this->lobbyId = $lobbyId;
    }

    public function broadcastOn()
    {
        return new Channel("lobby.{$this->lobbyId}");
    }
}
