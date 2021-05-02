
export default {
	init: function (data) {  
		data.select();
		document.execCommand("copy");
	}
}

function copyTextToClipboard(text) {
	// var textArea = document.createElement("textarea");
	
	textArea.value = text;

	document.body.appendChild(textArea);
	textArea.focus();
	textArea.select();

	try {
		var successful = document.execCommand('copy');
		var msg = successful ? 'successful' : 'unsuccessful';
		console.log('Copying text command was ' + msg);
	} catch (err) {
		console.log('Oops, unable to copy');
	}

	document.body.removeChild(textArea);
}