var audioPlayer = null;
window.addEventListener('message', function(event) {
	if (event.data.transactionType == "playSound") {

		audioPlayer = new Audio("./sounds/" + event.data.transactionFile + ".ogg");
		audioPlayer.volume = parseFloat(event.data.transactionVolume);
		audioPlayer.play();

	}
});