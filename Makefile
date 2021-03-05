run:
	docker build --no-cache -t rubytest .
	docker run -t rubytest 
