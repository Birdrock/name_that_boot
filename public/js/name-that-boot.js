var game;

//view
var GameField = function() {

  var field = $(".gameField");

  this.displayCard = function(card) {

    field.html("");
    field.append("<img class='card' src='"+ card.gravatar + "' />");
    field.append("<form class='choices'></form>");

    $.each(card.sampleNames, function(index, name){
      $("form").append("<div class='choice'><input type='radio' name='card' value=\"" + name + "\"><label class='choiceLabel'>" + name + "</label></div>");
    });

  }

  this.displayCorrect = function() {
    field.append("<div class='prompt'><p class='correct'>Correct!</p><a href='#' class='purpleButton nextButton'>Next Card</a></div>");
  }

  this.displayError = function(name) {
    field.append("<div class='prompt'><p>Oops, the correct answer was " + name + "!</p><a href='#' class='purpleButton nextButton'>Next Card</a></div>");
  }

  this.clearPrompt = function() {
    $( ".prompt" ).remove();
  }

  this.finishGame = function(score, max) {
    field.html("");
    field.append("<h1>Game Finished</h1>");
    field.append("<p class='score'>Your score is " + score + " of " + max + "</p>");
    field.append("<a class='splashButton pinkButton playAgain' href='/game'>Play Again</a>");
  }

  this.displayLoading = function() {
    field.html("<img class='spinner' src='../images/spinner.gif'/>");
  }
}

// controllery
var Game = function() {

  var deck;
  var view = new GameField();
  var score = 0;

  this.initGame = function(cohort_id, callback) {
    view.displayLoading();
    deck = new Deck();
    deck.load(cohort_id, callback);
  }

  this.displayCard = function() {
    card = deck.getNextCard();
    if(card) {
      view.displayCard(card);
    } else {
      view.finishGame(score, deck.getSize());
    }
  }

  this.updateScore = function(selectedPerson) {
    currentCard = deck.getCurrentCard();

    view.clearPrompt();

    if(currentCard.name == selectedPerson) {
      ++score;
      view.displayCorrect();
    } else {
      view.displayError(currentCard.name);
    }
  }
}

//model
var Deck = function() {

  var cards = [];
  var currentCard = -1;

  this.load = function(cohort_id, callback) {

    $.ajax({
      url: "/game/deck/new",
      data: {"cohort_id": cohort_id},
      type: "POST",
      dataType: "JSON",
      success: function(response) {
        buildCards(response);
        callback();
        $(cards).each(function(){
            (new Image()).src = this.gravatar;
        });
      }});
  }

  this.getNextCard = function() {
    currentCard++;

    if(currentCard < cards.length) {
      card = cards[currentCard];
      return card;
    }
  }

  this.getCurrentCard = function() {
    return cards[currentCard];
  }

  this.getSize = function() {
    return cards.length;
  }

  var buildCards = function(data) {
    $.each(data, function(index, card){
      cards.push(new Card(card.name, card.gravatar, card.sample_names));
    });
  }

}

//model
var Card = function(name, gravatar, sampleNames) {
  this.name = name;
  this.gravatar = gravatar;
  this.sampleNames = sampleNames;
}


$(document).ready(function(){

  $("#startGame").on("click", function(event){
    event.preventDefault();
    game = new Game();
    game.initGame($("select").val(), game.displayCard);
  });

  $(".gameField").on("click", "input[type='radio']", function(){
    game.updateScore($(this).val());
  });

   $(".gameField").on("click", ".nextButton", function(){
    game.displayCard();
  });
});

