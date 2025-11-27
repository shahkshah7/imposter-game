<?php

namespace App\Events;

use App\Models\Vote;
use Illuminate\Broadcasting\Channel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class VoteSubmitted implements ShouldBroadcast
{
    public $vote;
    public $lobbyId;

    public function __construct(Vote $vote)
    {
        $this->vote = $vote->load('voter', 'target');
        $this->lobbyId = $vote->round_id; // same lobby channel
    }

    public function broadcastOn()
    {
        return new Channel("lobby." . $this->vote->round->lobby_id);
    }
}
