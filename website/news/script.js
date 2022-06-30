
let data = document.querySelector('.data');
let body = document.querySelector('body');
let button_back = document.getElementsByClassName('fa-arrow-left');
let button_forward = document.getElementsByClassName('fa-arrow-right');
let img = document.querySelector('.image_item');
let num_img = document.getElementsByClassName('num_img');
let modal_window = document.querySelector('.modal_container');
let modal_img = document.querySelector('.modal_img');

setTimeout(() => body.className += ' visible', 200);
setInterval(() => {
	let options = { timeZone: 'America/New_York', hour: '2-digit', minute:'2-digit' };
	data.innerHTML = ` ${new Date().toLocaleDateString().replace(/[\.\/]/g,'/')}  ${new Date().toLocaleTimeString('en-US',options).replace(/\s/g, '').toLowerCase()}  NYC`;
}, 100);
img.onclick = function handleClickImg() {	
if(window.innerWidth <= 600){
	this.onclick = false;
}else if (window.innerWidth > 600){
	modal_window.style.display  = 'block';}
} 
function noselect() {return false};
body.ondragstart = noselect;
body.onselectstart = noselect;


let current=1;
let kolvo=9; 
tumb = [];
tumb[0]=new Image();
tumb[1]=new Image(); 
tumb[2]=new Image();
tumb[3]=new Image();
tumb[4]=new Image(); 
tumb[5]=new Image(); 
tumb[6]=new Image();
tumb[7]=new Image(); 
tumb[8]=new Image();

tumb[0].src="https://assets.supremenewyork.com/200480/ma/qtcgC-Csbfg.jpg"
tumb[1].src="https://assets.supremenewyork.com/200481/zo/FqGCWbmPrzI.jpg"
tumb[2].src="https://assets.supremenewyork.com/200483/zo/i-u6vWlkCzc.jpg"
tumb[3].src="https://assets.supremenewyork.com/200482/zo/it-7nQTuLT8.jpg"
tumb[4].src="https://assets.supremenewyork.com/200484/zo/HMmDYZJ4wWI.jpg"
tumb[5].src="https://assets.supremenewyork.com/200485/zo/WhfpMUq557Y.jpg"
tumb[6].src="https://assets.supremenewyork.com/200486/zo/lFKTZ-ELxqM.jpg"
tumb[7].src="https://assets.supremenewyork.com/200487/zo/B2rUaHtTsBE.jpg"
tumb[8].src="https://assets.supremenewyork.com/200488/zo/p7cCamfBcFw.jpg"

button_forward[0].onclick = clickForward;
button_forward[1].onclick = clickForward;
button_back[0].onclick = clickBack;
button_back[1].onclick = clickBack;

num_img[0].textContent = 1;
num_img[1].textContent = 1;

function clickForward() {
	if (current < kolvo) {
		current++;
		img.src=tumb[current-1].src;
		modal_img.src=tumb[current-1].src;
		num_img[0].textContent++;
		num_img[1].textContent++;	
	}
	current > 1 ? button_back[0].style.visibility = 'visible' : false;
	current > 1 ? button_back[1].style.visibility = 'visible' : false;
	current == 9 ? button_forward[0].style.visibility = 'hidden' : false;
	current == 9 ? button_forward[1].style.visibility = 'hidden' : false;

}
function clickBack() {
	if (current > 1) {	
		current--;
		img.src=tumb[current-1].src;
		modal_img.src=tumb[current-1].src;
		num_img[0].textContent--;
		num_img[1].textContent--;
	}
	current < 2 ? button_back[0].style.visibility = 'hidden' : false;
	current < 2 ? button_back[1].style.visibility = 'hidden' : false;
	current == 8 ? button_forward[0].style.visibility = 'visible' : false;
	current == 8 ? button_forward[1].style.visibility = 'visible' : false;
}



