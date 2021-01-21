all: clean
	@echo "Building Sineware Nuinit"
	$(CXX) -static -O2 -o init src/SinewareProcess.cpp src/main.cpp
clean:
	rm -rf init
install:
	mv init $(DESTDIR)