
export default {
	init: function () {  
		const copyButtons = document.querySelectorAll(".ccer");
		copyButtons.forEach( item => {
			item.addEventListener("click", () => {copyToClipboard(item);});
		});
	}
}
// very hacky. Looking for a better way to just copy the text.
function copyTextToClipboard(text) {
	const textArea = document.createElement("textarea");
	
	textArea.value = text;

	document.body.appendChild(textArea);
	textArea.focus();
	textArea.select();

	document.execCommand('copy');
	document.body.removeChild(textArea);
}

function copyToClipboard(button) {
  const element = button.nextElementSibling;
	console.log(element);
	copyTextToClipboard(element.innerHTML.trim());
}