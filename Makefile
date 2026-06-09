NAME		= libasm.a
BNAME		= blibasm.a

ASM			= nasm
ASMFLAGS	= -f elf64
AR			= ar rcs

CC			= cc
CFLAGS		= -Wall -Wextra -Werror -std=gnu11

SRC_DIR		= lib

SRCS		= $(SRC_DIR)/ft_strlen.s \
              $(SRC_DIR)/ft_strcpy.s \
              $(SRC_DIR)/ft_strcmp.s \
              $(SRC_DIR)/ft_write.s \
              $(SRC_DIR)/ft_read.s \
              $(SRC_DIR)/ft_strdup.s

BSRCS		= $(SRC_DIR)/ft_atoi_base.s \
              $(SRC_DIR)/ft_list_push_front.s \
              $(SRC_DIR)/ft_list_size.s \
              $(SRC_DIR)/ft_list_sort.s \
              $(SRC_DIR)/ft_list_remove_if.s

OBJS       = $(SRCS:.s=.o)
BOBJS = $(BSRCS:.s=.o)

all: $(NAME)

bonus: $(BNAME)

$(NAME): $(OBJS)
	$(AR) $(NAME) $(OBJS)

$(BNAME): $(OBJS) $(BOBJS)
	$(AR) $(BNAME) $(OBJS) $(BOBJS)

%.o: %.s
	$(ASM) $(ASMFLAGS) $< -o $@

test: $(NAME) main.c
	$(CC) $(CFLAGS) main.c $(NAME) -o test

test_bonus: $(BNAME) main_bonus.c
	$(CC) $(CFLAGS) main_bonus.c $(BNAME) -o test_bonus

clean:
	rm -f $(OBJS) $(BOBJS)

fclean: clean
	rm -f $(NAME) $(BNAME) test test_bonus

re: fclean all

.PHONY: all bonus clean fclean re