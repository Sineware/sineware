all: clean
	@echo "Building Sineware System Init"
	$(CXX) src/inipp.h src/main.cpp -o init
clean:
	rm -rf init
install:
	mv init $(DESTDIR)