<?php

namespace App\Http\Controllers;

use App\Models\Vote;
use App\Models\Round;
use Illuminate\Http\Request;

// ADD EVENT:
use App\Events\VoteSubmitted;

class VotingController extends Controller
{
    public function submitVote(Request $request, $roundId)
    {
        $request->validate([
            'voter_id' => 'required|integer',
            'target_id' => 'required|integer'
        ]);

        // Prevent duplicate voting
        Vote::where('round_id', $roundId)
            ->where('voter_id', $request->voter_id)
            ->delete();

        $vote = Vote::create([
            'round_id'  => $roundId,
            'voter_id'  => $request->voter_id,
            'target_id' => $request->target_id,
        ]);

        // 🚀 BROADCAST EVENT
        event(new VoteSubmitted($vote));

        return response()->json([
            'vote' => $vote
        ]);
    }

    public function results($roundId)
    {
        $round = Round::findOrFail($roundId);
        $impostorId = $round->impostor_player_id;

        $votes = Vote::where('round_id', $roundId)->get();

        $tally = [];
        foreach ($votes as $v) {
            if (!isset($tally[$v->target_id])) $tally[$v->target_id] = 0;
            $tally[$v->target_id]++;
        }

        arsort($tally);
        $top = array_key_first($tally);

        $winner = ($top == $impostorId)
            ? 'civilians'
            : 'impostor';

        return response()->json([
            'votes' => $tally,
            'impostor' => $impostorId,
            'winner' => $winner
        ]);
    }
}
