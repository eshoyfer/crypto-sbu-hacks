var h = document.getElementById("text");
var changeText, stopText;
var i = 0;

function loop() {
    changeText = setInterval(function(){
    	switch (i++) {
    		case 0:
    			h.innerHTML = "Determining winner."
    			break;
    		case 1:
    			h.innerHTML = "Determining winner.."
    			break;
    		case 2:
    			h.innerHTML = "Determining winner..."
    			break;
    	}
    	if (i==3) {i=0;}
    }
    , 500);
}

function stopLoop() {
	stopText = setTimeout(function() {
		clearInterval(changeText);
    	h.innerHTML = "The winner is superuser2"
	}
	, 11000);
}

loop();
stopLoop();