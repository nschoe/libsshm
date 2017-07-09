CXX=g++
CXXFLAGS=-Wall -fPIC -Iinclude
LDFLAGS=-shared
LIB_NAME=libsshm.so
SRC=$(wildcard src/*.cpp)
OBJ=$(SRC:.cpp=.o)
INSTALL_LIB_DIR=/usr/local/lib
INSTALL_HEADER_DIR=/usr/local/include

all: $(LIB_NAME)

libsshm.so: $(OBJ)
	$(CXX) -o $@ $^ $(LDFLAGS)

src/libsshm.o: include/libsshm.hpp

%.o: %.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)

install: $(LIB_NAME) include/libsshm.hpp
	@echo "Installing $(LIB_NAME) into $(INSTALL_LIB_DIR)..."
	@cp $(LIB_NAME) $(INSTALL_LIB_DIR)/
	@echo "Installing header file into $(INSTALL_HEADER_DIR)..."
	@cp include/libsshm.hpp $(INSTALL_HEADER_DIR)/libsshm.hpp

uninstall:
	@echo "Uninstalling $(LIB_NAME) from $(INSTALL_LIB_DIR)..."
	@rm -f $(INSTALL_LIB_DIR)/$(LIB_NAME)
	@echo "Uninstalling libsshm.hpp from $(INSTALL_HEADER_DIR)..."
	@rm -rf $(INSTALL_HEADER_DIR)/libsshm.hpp

.PHONY: clean mrproper install uninstall

clean:
	rm -rf src/*.o

mrproper: clean
	rm -rf $(LIB_NAME)
