NAME    = tester
LIB		= libasm.a
SRCS    = lib/ft_strlen.s lib/ft_strcpy.s lib/ft_strcmp.s lib/ft_write.s lib/ft_read.s lib/ft_strdup.s
OBJS    = $(SRCS:.s=.o)

all: $(LIB)
	cc -Wall -Wextra -Werror -o $(NAME) $(LIB) $(OBJS) main.c

%.o: %.s
	nasm -f elf64 -g $< -o $@

$(LIB): $(OBJS)
	ar rcs $(LIB) $(OBJS)

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)
	rm -f $(LIB)

re: fclean all

.PHONY: all clean fclean re