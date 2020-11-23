all: clean
	@echo "Building Sineware System Init"
	$(CXX) src/main.cpp -o init
clean:
	rm -rf init
install:
	mv init $(DESTDIR)