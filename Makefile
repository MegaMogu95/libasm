NAME    = libasm.a
SRCS    = srcs/ft_strlen.s srcs/ft_strcpy.s srcs/ft_strcmp.s
OBJS    = $(SRCS:.s=.o)

all: $(NAME)

%.o: %.s
	nasm -f elf64 -g $< -o $@

$(NAME): $(OBJS)
	ar rcs $(NAME) $(OBJS)

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re