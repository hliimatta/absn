release-install:
	crystal build --release --no-debug src/app.cr
	cp app ~/bin/absn
