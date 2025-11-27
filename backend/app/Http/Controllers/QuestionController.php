<?php

namespace App\Http\Controllers;

use App\Models\Player;
use App\Models\Question;
use App\Models\Round;
use Illuminate\Http\Request;

class QuestionController extends Controller
{
    public function askQuestion(Request $request, $roundId)
    {
        $request->validate([
            'asker_id' => 'required|integer',
            'target_id' => 'required|integer',
            'text' => 'required|string|max:255'
        ]);

        $round = Round::findOrFail($roundId);

        $question = Question::create([
            'round_id' => $round->id,
            'asker_id' => $request->asker_id,
            'target_id' => $request->target_id,
            'text' => $request->text,
        ]);

        return response()->json([
            'question' => $question
        ]);
    }

    public function answerQuestion(Request $request, $questionId)
    {
        $request->validate([
            'answer' => 'required|string|max:50'
        ]);

        $question = Question::findOrFail($questionId);

        $question->update([
            'answer' => $request->answer,
            'answered_at' => now()
        ]);

        return response()->json([
            'question' => $question
        ]);
    }

    public function getQuestions(Request $request, $roundId, $playerId)
    {
        $questions = Question::where('round_id', $roundId)
            ->with(['asker', 'target'])
            ->orderBy('created_at')
            ->get();

        $questions = $questions->map(function ($q) use ($playerId) {
            return [
                'id' => $q->id,
                'asker' => $q->asker->name,
                'target' => $q->target->name,
                'text' => $q->text,
                'has_answer' => !empty($q->answer),
                'answer' => $q->asker_id == $playerId ? $q->answer : null,
                'answered_at' => $q->asker_id == $playerId ? $q->answered_at : null,
            ];
        });

        return response()->json([
            'questions' => $questions
        ]);
    }
}
