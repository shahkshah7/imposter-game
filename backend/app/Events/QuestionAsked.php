<?php

namespace App\Events;

use App\Models\Question;
use Illuminate\Broadcasting\Channel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class QuestionAsked implements ShouldBroadcast
{
    public $question;

    public function __construct(Question $question)
    {
        // Load relations for asker and target (so Flutter gets names)
        $this->question = $question->load('asker', 'target');
    }

    public function broadcastOn()
    {
        // Broadcast to the lobby channel based on lobby ID
        return new Channel("lobby." . $this->question->round->lobby_id);
    }
}
