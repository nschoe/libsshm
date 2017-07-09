CXX=g++
CXXFLAGS=-Wall -fPIC -Iinclude
LDFLAGS=-shared
LIB_NAME=libsshm.so
SRC=$(wildcard src/*.cpp)
OBJ=$(SRC:.cpp=.o)
INSTALL_DIR=/home/nschoe/workspace/lib

all: $(LIB_NAME)

libsshm.so: $(OBJ)
	$(CXX) -o $@ $^ $(LDFLAGS)

src/libsshm.o: include/libsshm.hpp

%.o: %.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)

install: $(LIB_NAME)
	@echo "Installing $< into $(INSTALL_DIR)..."
	@cp $< $(INSTALL_DIR)/

uninstall:
	@echo "Uninstalling $LIB_NAME from $(INSTALL_DIR)..."
	@rm -f $(INSTALL_DIR)/$(LIB_NAME)

.PHONY: clean mrproper install uninstall

clean:
	rm -rf src/*.o

mrproper: clean
	rm -rf $(LIB_NAME)
