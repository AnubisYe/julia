TARGET = julia
CC = gcc -std=c11
SRCS = base/buffer.c base/list.c\
	   base/map.c base/pool.c\
	   base/string.c base/vector.c\
	   config.c connection.c juson/juson.c parse.c\
       request.c response.c server.c util.c uwsgi.c

INSTALL_DIR = /usr/local/$(TARGET)/

CFLAGS = -g -Wall -DINSTALL_DIR=\"$(INSTALL_DIR)\" -D_XOPEN_SOURCE -D_GNU_SOURCE -I./

BIN_DIR = /usr/local/bin/
OBJS_DIR = build/
OBJS = $(addprefix $(OBJS_DIR), $(SRCS:.c=.o))

default: all

install: all uninstall
	@sudo mkdir -p $(INSTALL_DIR)
	@sudo cp config.json $(INSTALL_DIR)config.json
	@sudo cp -a www/. /var/www/
	@sudo cp $(OBJS_DIR)$(TARGET) $(BIN_DIR)$(TARGET)

uninstall:
	@sudo rm -f $(BIN_DIR)$(TARGET)
	@sudo rm -rf /var/www/
	@sudo rm -rf $(INSTALL_DIR)

all:
	@mkdir -p $(OBJS_DIR)
	@mkdir -p $(OBJS_DIR)base
	@mkdir -p $(OBJS_DIR)juson
	@make $(TARGET)

$(TARGET): $(OBJS)
	gcc -o $(OBJS_DIR)$@ $^

$(OBJS_DIR)%.o: %.c server.h
	$(CC) $(CFLAGS) -o $@ -c $<

.PHONY: clean

clean:
	@rm -rf $(OBJS_DIR)
