<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\LobbyController;
use App\Http\Controllers\GameController;
use App\Http\Controllers\QuestionController;
use App\Http\Controllers\VotingController;

// Lobby
Route::post('/lobby/create', [LobbyController::class, 'createLobby']);
Route::post('/lobby/{code}/join', [LobbyController::class, 'joinLobby']);
Route::get('/lobby/{id}/players', [LobbyController::class, 'getPlayers']);

// Game
Route::post('/game/{code}/start', [GameController::class, 'startGame']);
Route::get('/game/player/{playerId}/state', [GameController::class, 'getState']);

// Questions
Route::post('/round/{roundId}/question', [QuestionController::class, 'askQuestion']);
Route::post('/question/{questionId}/answer', [QuestionController::class, 'answerQuestion']);
Route::get('/round/{roundId}/questions/{playerId}', [QuestionController::class, 'getQuestions']);

// Voting
Route::post('/round/{roundId}/vote', [VotingController::class, 'submitVote']);
Route::get('/round/{roundId}/results', [VotingController::class, 'results']);
