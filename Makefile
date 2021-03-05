run:
	docker build --no-cache -t rubytest .
	docker run -t rubytest 

validate:
	# Install circleci with brew install circleci
	circleci config validate

