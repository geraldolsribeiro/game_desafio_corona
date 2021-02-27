all:
	love .

html5:
	love.js -t "Desafio Corona 2020" . ../game_desafio_corona_html5/

serve:
	cd ../game_desafio_corona_html5 && python3 -m http.server 8000
