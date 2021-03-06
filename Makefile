ruby:
	docker build --no-cache -t ruby .
	docker run -t ruby 

go:
	docker build -f Dockerfile-go --no-cache -t go .
	docker run -t go

validate:
	# Install circleci with brew install circleci
	circleci config validate
