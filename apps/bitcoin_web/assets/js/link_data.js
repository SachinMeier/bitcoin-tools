
export default {
	init: function () {
		const linked_datas = document.querySelectorAll(".data-linked");
		linked_datas.forEach(item => {
			const linked_items = document.getElementsByName(item.id);
			linked_items.forEach(l_item => {
				l_item.addEventListener("mouseover", () => {makeOrange(item, l_item);}, false);
				l_item.addEventListener("mouseout", () => {makeNormal(item, l_item);}, false);
			});
		});
	}
}

function makeOrange(item, l_item)
{  
	l_item.classList.add("data-hover");
	item.classList.add("data-hover");
}

function makeNormal(item, l_item)
{  
	l_item.classList.remove("data-hover");
	item.classList.remove("data-hover");
}