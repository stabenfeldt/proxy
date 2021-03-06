ruby:
	docker build --no-cache -t rubytest .
	docker run -t rubytest 

go:
	docker build -f Dockerfile-go --no-cache -t go .
	docker run -t go
