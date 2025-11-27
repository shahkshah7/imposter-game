<?php

namespace App\Events;

use App\Models\Question;
use Illuminate\Broadcasting\Channel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class QuestionAnswered implements ShouldBroadcast
{
    public $question;

    public function __construct(Question $question)
    {
        $this->question = $question->load('asker', 'target');
    }

    public function broadcastOn()
    {
        return new Channel("lobby." . $this->question->round->lobby_id);
    }
}
